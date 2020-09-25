import PropTypes from 'prop-types';
import React from 'react';

const UploadProgress = (props) => {
  let { progress } = props;
  let classModifier;

  /* eslint-disable no-magic-numbers */
  if (progress < 0) {
    progress = 0;
  }
  if (progress > 100) {
    progress = 100;
  }

  if (progress === 100) {
    classModifier = 'file-uploader__upload-progress--done';
  }
  /* eslint-enable no-magic-numbers */

  return (
    <div className='file-uploader__upload-progress-container'>
      <div
        className={`file-uploader__upload-progress ${classModifier}`}
        style={{ width: `${progress}%` }}
      />
    </div>
  );
};

UploadProgress.propTypes = {
  progress: PropTypes.number.isRequired
};

export default UploadProgress;
