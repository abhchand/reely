import PropTypes from 'prop-types';
import React from 'react';
import Upload from './upload';

const UploadList = (props) => {
  const { files } = props;

  if (files.length === 0) {
    return null;
  }

  return (
    <ul className='file-uploader__upload-list'>
      {files.map((file, index) => {
        // eslint-disable-next-line react/no-array-index-key
        return (
          <Upload key={`file-dialog-${index}`} dataId={index} file={file} />
        );
      })}
    </ul>
  );
};

UploadList.propTypes = {
  files: PropTypes.array.isRequired
};

export default UploadList;
