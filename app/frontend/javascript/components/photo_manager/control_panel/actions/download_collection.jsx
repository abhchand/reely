import FileDownloader from 'components/file_downloader';
import { IconDownload } from 'components/icons';
import PropTypes from 'prop-types';
import React from 'react';

class DownloadCollection extends React.Component {

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

  // eslint-disable-next-line padded-blocks
  render() {

    /*
     * NOTE: FileDownloader already wraps the content in a `<button>` so no
     * need to specify a button here
     */
    return (
      <li className="icon-tray__item icon-tray__item--download-collection">
        <FileDownloader
          generateCreateDownloadPath={this.generateCreateDownloadPath}
          generateFetchStatusPath={this.generateFetchStatusPath}>
          <IconDownload size="20" fillColor="#888888" />
        </FileDownloader>
      </li>
    );
  }

}

export default DownloadCollection;
