import PropTypes from 'prop-types';
import React from 'react';

const FileError = (props) => {
  const { error } = props;

  if (!error) {
    return null;
  }

  return <div className="file-uploader__file-error">{error}</div>;
};

FileError.propTypes = {
  error: PropTypes.string
};

export default FileError;
