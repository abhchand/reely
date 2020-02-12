import FileDownloader from 'components/file_downloader';
import { IconDownload } from 'components/icons';
import mountReactComponent from 'mount-react-component.jsx';
import PropTypes from 'prop-types';
import React from 'react';

class CollectionsSharingDisplayDownloadFiles extends React.Component {

  static propTypes = {
    collection: PropTypes.object.isRequired
  };

  constructor(props) {
    super(props);

    this.generateCreateDownloadPath = this.generateCreateDownloadPath.bind(this);
    this.generateFetchStatusPath = this.generateFetchStatusPath.bind(this);
  }

  generateCreateDownloadPath() {
    const { share_id } = this.props.collection;
    return `/collections/${share_id}/downloads.json`;
  }

  generateFetchStatusPath(downloadId) {
    const { share_id } = this.props.collection;
    return `/collections/${share_id}/downloads/${downloadId}/status.json`;
  }

  render() {
    return (
      <FileDownloader
        generateCreateDownloadPath={this.generateCreateDownloadPath}
        generateFetchStatusPath={this.generateFetchStatusPath}>
        <IconDownload size="24" fillColor="#888888" />
      </FileDownloader>
    );
  }

}

export default CollectionsSharingDisplayDownloadFiles;

mountReactComponent(CollectionsSharingDisplayDownloadFiles, 'collections-sharing-display-download-files');
