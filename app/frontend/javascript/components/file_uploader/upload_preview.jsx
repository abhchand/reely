import { IconFile } from 'components/icons';
import PropTypes from 'prop-types';
import React from 'react';

const UploadPreview = (props) => {
  const { url } = props;

  if (url) {
    return (
      <div
        className="file-uploader__upload-preview file-uploader__upload-preview--enabled covered-background"
        style={{ backgroundImage: `url(${url})` }} />
    );
  }

  return (
    <div className="file-uploader__upload-preview">
      <IconFile size="40" fillColor="#4F14C8" secondaryColor="#DDDDDD" />
    </div>
  );
};

UploadPreview.propTypes = {
  url: PropTypes.string
};

export default UploadPreview;
