import { IconLoading } from 'components/icons';
import PropTypes from 'prop-types';
import React from 'react';

const LoadingIconSpinner = (props) => {
  return (
    <div className="loading-icon loading-icon--spinner">
      <IconLoading
        size={props.size}
        backgroundFillColor={props.backgroundFillColor}
        foregroundFillColor={props.foregroundFillColor} />
    </div>
  );
};

LoadingIconSpinner.propTypes = {
  size: PropTypes.string,
  backgroundFillColor: PropTypes.string,
  foregroundFillColor: PropTypes.string
};

LoadingIconSpinner.defaultProps = {
  backgroundFillColor: '#888888',
  foregroundFillColor: '#4F14C8',
  size: '24'
};

export default LoadingIconSpinner;
