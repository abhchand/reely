import { formatFilesize } from 'javascript/utils/filesize_helpers';
import PropTypes from 'prop-types';
import React from 'react';

const UploadDetails = (props) => {
  return (
    <div className='file-uploader__upload-details'>
      <div className='filename'>
        <span title={props.filename}>{props.filename}</span>
      </div>
      <div className='filesize'>{formatFilesize(props.filesize, 1)}</div>
    </div>
  );
};

UploadDetails.propTypes = {
  filename: PropTypes.string.isRequired,
  filesize: PropTypes.number.isRequired
};

export default UploadDetails;
