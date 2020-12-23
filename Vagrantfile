# -*- mode: ruby -*-
# vi: set ft=ruby :

ip = '192.168.33.11'
cpus = 2
memory = 1024 * 6

def fail_with_message(msg)
  fail Vagrant::Errors::VagrantError.new, msg
end

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.box_url = "https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64-vagrant.box"
  config.vm.network :private_network, ip: ip, hostsupdater: 'skip'
  config.vm.hostname = 'staffjoy-v2.local'

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder ".", "/home/vagrant/golang/src/v2.staffjoy.com", SharedFoldersEnableSymlinksCreate: true, owner: "vagrant", group: "vagrant"

  # increase original disk size
  if Vagrant.has_plugin? 'vagrant-disksize'
    config.disksize.size = '30GB' # vagrant plugin install vagrant-disksize
  else
    fail_with_message "vagrant-disksize missing, please install the plugin with this command:\nvagrant plugin install vagrant-disksize"
  end

  config.vm.provider 'virtualbox' do |vb|
    vb.name = config.vm.hostname
    vb.customize ['modifyvm', :id, '--cpus', cpus]
    vb.customize ['modifyvm', :id, '--memory', memory]

    # Fix for slow external network connections
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
  end

  # configure hostnames to access from localmachine
  if Vagrant.has_plugin? 'vagrant-hostmanager'
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.aliases = [
      'account.staffjoy-v2.local',
      'app.staffjoy-v2.local',
      'company.staffjoy-v2.local',
      'faraday.staffjoy-v2.local',
      'kubernetes.staffjoy-v2.local',
      'myaccount.staffjoy-v2.local',
      'superpowers.staffjoy-v2.local',
      'signal.staffjoy-v2.local',
      'waitlist.staffjoy-v2.local',
      'whoami.staffjoy-v2.local',
      'www.staffjoy-v2.local',
      'ical.staffjoy-v2.local',
    ]
  else
    fail_with_message "vagrant-hostmanager missing, please install the plugin with this command:\nvagrant plugin install vagrant-hostmanager"
  end

  config.vm.provision "shell", path: "vagrant/provision.sh", privileged: false
end