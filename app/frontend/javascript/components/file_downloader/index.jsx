import axios from 'axios';
import LoadingIconSpinner from 'components/icons/loading_icon_spinner';
import PropTypes from 'prop-types';
import React from 'react';
import ReactOnRails from 'react-on-rails/node_package/lib/Authenticity';
import { setFlash } from 'application/flash';

class FileDownloader extends React.Component {
  static headers() {
    return {
      'Content-Type': 'application/json',
      Accept: 'application/json',
      'X-CSRF-Token': ReactOnRails.authenticityToken()
    };
  }

  static propTypes = {
    generateCreateDownloadPath: PropTypes.func.isRequired,
    generateFetchStatusPath: PropTypes.func.isRequired,

    children: PropTypes.node
  };

  constructor(props) {
    super(props);

    this.setFlash = this.setFlash.bind(this);
    this.requestDownload = this.requestDownload.bind(this);
    this.startPolling = this.startPolling.bind(this);
    this.fetchStatus = this.fetchStatus.bind(this);
    this.parseStatus = this.parseStatus.bind(this);
    this.startDownload = this.startDownload.bind(this);

    this.downloadId = null;
    this.pollingDelay = 1000;

    this.state = {
      isDownloading: false
    };
  }

  setFlash(msg) {
    setFlash('error', msg || I18n.t('generic_error'));
    this.setState({ isDownloading: false });
  }

  requestDownload() {
    const self = this;

    const url = this.props.generateCreateDownloadPath();
    const data = {};
    const config = { headers: FileDownloader.headers() };

    this.setState({ isDownloading: true });

    return axios
      .post(url, data, config)
      .then((response) => {
        self.startPolling(response.data.id);
      })
      .catch((error) => {
        self.setFlash(error.response.data.error);
      });
  }

  startPolling(downloadId) {
    this.downloadId = downloadId;
    this.fetchStatus();
  }

  fetchStatus() {
    const self = this;

    const url = this.props.generateFetchStatusPath(this.downloadId);
    const config = { headers: FileDownloader.headers(), params: {} };

    return axios
      .get(url, config)
      .then((response) => {
        self.parseStatus(response.data.download);
      })
      .catch((error) => {
        self.setFlash(error.response.data.error);
      });
  }

  parseStatus(download) {
    if (download.isComplete) {
      this.startDownload(download.url);
      return;
    }

    setTimeout(this.fetchStatus, this.pollingDelay);
  }

  startDownload(url) {
    this.setState({ isDownloading: false });

    const link = document.createElement('a');
    link.href = url;

    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  }

  render() {
    if (this.state.isDownloading) {
      return (
        <button type='button' className='file-downloader'>
          <LoadingIconSpinner />
        </button>
      );
    }

    return (
      <button
        type='button'
        className='file-downloader'
        onClick={this.requestDownload}>
        {this.props.children}
      </button>
    );
  }
}

export default FileDownloader;
