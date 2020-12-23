#!/bin/bash

# VERSIONS:
MINIKUBE_VERSION=v1.4.0
KUBECTL_CLI_VERSION=v1.16.0


# ARGS
FORCE_UPDATE=false
for arg in "$@"
do
    case $arg in
        -f|--force)
        FORCE_UPDATE=true
            shift # Remove --force from processing
        ;;
    esac
done


# We need to run a local registry - k8s cannot just pull locally
if ! pgrep -c registry >/dev/null 2>&1 ; then
    docker run -d \
        -p 5000:5000 \
        --restart=always \
        --name registry \
        registry:2
fi


$FORCE_UPDATE && [ -f /usr/local/bin/kubectl ] && sudo rm -rf /usr/local/bin/kubectl && echo "[x] Force update flag used. Removing existing version of kubectl";
$FORCE_UPDATE && [ -f /usr/local/bin/minikube ] && sudo rm -rf /usr/local/bin/minikube && echo "[x] Force update flag used. Removing existing version of minikube";


# download and install kubectl ...
# Latest stable: https://storage.googleapis.com/kubernetes-release/release/stable.txt
if [ ! -f "/usr/local/bin/kubectl" ] ; then
    echo "[x] Downloading kubectl ${MINIKUBE_VERSION}...";
    curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_CLI_VERSION}/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/
fi


# ... and minikube
# Latest stable: 
if [ ! -f "/usr/local/bin/minikube" ] ; then
    echo "[x] Downloading minikube ${MINIKUBE_VERSION}...";
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/${MINIKUBE_VERSION}/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
fi


sudo -E minikube start \
    --kubernetes-version=${KUBECTL_CLI_VERSION} \
    --vm-driver=none \
    --dns-domain="cluster.local" \
    --service-cluster-ip-range="10.0.0.0/12" \
    --extra-config="kubelet.cluster-dns=10.0.0.10"

# enables dashboard
sudo -E minikube addons enable dashboard
sudo -E minikube dashboard &>/dev/null &

# either use sudo on all kubectl commands, or chown/chgrp to your user
sudo chown -R ${USER}:${USER} /home/${USER}/.kube /home/${USER}/.minikube


# this will write over any previous configuration)
# wait for the cluster to become ready/accessible via kubectl
echo -e -n " [ ] Waiting for master components to start...";
JSONPATH='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}';
until sudo kubectl get nodes -o jsonpath="$JSONPATH" 2>&1 | grep -q "Ready=True"; do
    echo -n "."
    sleep 1
done


kubectl cluster-info

kubectl config set-cluster staffjoy-dev --server=https://10.0.2.15:8443 --certificate-authority=/home/${USER}/.minikube/ca.crt
kubectl config set-context staffjoy-dev --cluster=staffjoy-dev --user=minikube
kubectl config use-context staffjoy-dev

kubectl create namespace development

kubectl --namespace=development create -R -f ~/golang/src/v2.staffjoy.com/ci/k8s/development/infrastructure/app-mysql

kubectl --context minikube proxy &>/dev/null &
