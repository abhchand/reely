import PropTypes from 'prop-types';
import React from 'react';

const UploadCount = (props) => {
  /* eslint-disable no-magic-numbers */
  const { files } = props;

  if (files.length === 0) { return null; }

  const text = I18n.t(
    'components.file_uploader.upload_count.heading',
    {
      uploaded: files.filter((file) => file.progress === 100).length,
      count: files.length
    }
  );

  return <div className="file-uploader__upload-count">{text}</div>;
  /* eslint-enable no-magic-numbers */
};

UploadCount.propTypes = {
  files: PropTypes.array.isRequired
};

export default UploadCount;
