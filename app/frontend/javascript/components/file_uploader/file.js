import axios from 'axios';
import ReactOnRails from 'react-on-rails/node_package/lib/Authenticity';

class File {
  static headers() {
    return {
      'Content-Type': 'application/json',
      Accept: 'application/json',
      'X-CSRF-Token': ReactOnRails.authenticityToken()
    };
  }

  constructor(id, fileNamespace, fileObj) {
    this.id = id;

    this.fileNamespace = fileNamespace;
    this.fileObj = fileObj;

    this.name = fileObj.name;
    this.size = fileObj.size;
    this.error = null;
    this.progress = 0;
    this.previewUrl = null;

    this.setProgress = this.setProgress.bind(this);
    this.setError = this.setError.bind(this);
    this.setPreview = this.setPreview.bind(this);
    this.hasStarted = this.hasStarted.bind(this);
  }

  upload(url) {
    const config = { headers: File.headers() };

    const data = new FormData();
    data.append(this.fileNamespace, this.fileObj);

    return axios.post(url, data, config);
  }

  setProgress(value) {
    this.progress = value;
  }

  setError(value) {
    this.error = value;
  }

  setPreview(value) {
    this.previewUrl = value;
  }

  hasStarted() {
    return this.progress > 0;
  }
}

export default File;
