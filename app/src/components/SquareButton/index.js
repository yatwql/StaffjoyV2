import React from 'react';
import PropTypes from 'prop-types';
import { IconButton } from '@rmwc/icon-button';

require('./square-button.scss');

const styles = {
  button: {
      width: 32, height: 32,
      padding: 0
  },
  icon: {
      fontSize:22,
      color:'#fffff'
  },
  tooltip: {
      marginLeft:7
  }
};

function SquareButton({ name, onClick, ...otherProps }) {
  return (
    <IconButton 
      name={name}
      style={styles.button} iconStyle={styles.icon} tooltipStyles={styles.tooltip}
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
