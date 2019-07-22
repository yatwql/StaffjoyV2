import React from 'react';
import PropTypes from 'prop-types';
import { IconButton } from 'react-mdl';

require('./square-button.scss');

function SquareButton({ name, onClick, ...otherProps }) {
  return (
    <IconButton
      name={name}
      className="square-button"
      onClick={onClick}
      {...otherProps}
    />
  );
}

SquareButton.propTypes = {
  name: PropTypes.string.isRequired,
  onClick: PropTypes.func,
};

export default SquareButton;
