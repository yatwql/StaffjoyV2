import React from 'react';
import PropTypes from 'prop-types';
import { Spinner } from 'react-mdl';

require('./loading-screen.scss');
const imgUrl = require(
  '../../../../frontend_resources/images/staffjoy.png'
);

function LoadingScreen({ containerProps = {} }) {
  return (
    <div className="loading-container" {...containerProps}>
      <img role="presentation" alt="Staffjoy logo" src={imgUrl} />
      <Spinner singleColor />
    </div>
  );
}

LoadingScreen.propTypes = {
  containerProps: PropTypes.object,
};

export default LoadingScreen;
