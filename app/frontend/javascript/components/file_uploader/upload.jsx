import PropTypes from 'prop-types';
import React from 'react';
import UploadDetails from './upload_details';
import UploadPreview from './upload_preview';
import UploadProgress from './upload_progress';

class Upload extends React.Component {
  static propTypes = {
    dataId: PropTypes.number.isRequired,
    file: PropTypes.object.isRequired
  };

  constructor(props) {
    super(props);

    this.renderStatus = this.renderStatus.bind(this);
  }

  renderStatus() {
    const { file } = this.props;

    if (file.error) {
      return <div className='error'>{file.error}</div>;
    }
    return <UploadProgress progress={file.progress} />;
  }

  render() {
    const { dataId, file } = this.props;

    return (
      <li className='file-uploader__upload' data-id={dataId}>
        <UploadPreview url={file.previewUrl} />
        <UploadDetails filename={file.name} filesize={file.size} />
        {this.renderStatus()}
      </li>
    );
  }
}

export default Upload;
