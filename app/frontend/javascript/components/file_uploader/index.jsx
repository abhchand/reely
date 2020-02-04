import File from './file.js';
import FileError from './file_error';
import mountReactComponent from 'mount-react-component.jsx';
import PropTypes from 'prop-types';
import React from 'react';
import UploadCount from './upload_count';
import UploadList from './upload_list';
import Validator from './validator.js';

class FileUploader extends React.Component {

  static propTypes = {
    url: PropTypes.string.isRequired,
    modelName: PropTypes.string.isRequired,
    attrName: PropTypes.string.isRequired,

    maxFileCount: PropTypes.number,
    maxFileSize: PropTypes.number,
    uploadButtonLabel: PropTypes.string
  };

  static defaultProps = {
    maxFileCount: 1,
    // 15 MB
    // eslint-disable-next-line no-magic-numbers
    maxFileSize: 15 * 1024 * 1024,
    uploadButtonLabel: I18n.t('components.file_uploader.upload')
  };

  constructor(props) {
    super(props);

    this.uploadFiles = this.uploadFiles.bind(this);
    this.uploadFile = this.uploadFile.bind(this);
    this.uploadNextQueuedFile = this.uploadNextQueuedFile.bind(this);
    this.onUploadCompletion = this.onUploadCompletion.bind(this);
    this.onUploadFailure = this.onUploadFailure.bind(this);
    this.updateProgress = this.updateProgress.bind(this);
    this.setUploadError = this.setUploadError.bind(this);
    this.renderFileInput = this.renderFileInput.bind(this);

    this.i18nPrefix = 'components.file_uploader';
    this.allowMultipleFiles = props.maxFileCount > 1;
    this.validator = new Validator(this.props.maxFileCount, this.props.maxFileSize);
    this.uploadConcurrency = 5;

    this.state = {
      files: [],
      isUploading: false,
      error: null
    };
  }

  uploadFiles(event) {
    event.preventDefault();

    // Reset everything in case this is not the first upload
    this.setState({
      files: [],
      isUploading: false,
      error: null
    });

    const { modelName, attrName } = this.props;
    const namespace = `${modelName}[${attrName}]`;
    const files = [];

    event.target.files.forEach((fileData, index) => {
      files.push(new File(index, namespace, fileData));
    });

    const error = this.validator.validate(files);

    if (error) {
      this.setState({ error: error });
    }
    else {
      this.setState({ files: files, isUploading: true, error: null });
      files.slice(0, this.uploadConcurrency).forEach(this.uploadFile);
    }
  }

  uploadFile(file) {
    const { url } = this.props;
    const self = this;

    // eslint-disable-next-line no-magic-numbers
    this.updateProgress(file, 10);

    file.upload(url).
      then((response) => self.onUploadCompletion(file, response)).
      catch((error) => self.onUploadFailure(file, error));
  }

  uploadNextQueuedFile() {
    const enqueued = this.state.files.filter((file) => !file.hasStarted());

    if (enqueued.length > 0) {
      this.uploadFile(enqueued[0]);
    }

    return enqueued[0];
  }

  onUploadCompletion(file, response) {
    // eslint-disable-next-line no-magic-numbers
    this.updateProgress(file, 100);
    this.setUploadPreview(file, response.data.paths.thumb);

    if (!this.uploadNextQueuedFile()) {
      this.setState({ isUploading: false });
    }
  }

  onUploadFailure(file, error) {
    this.setUploadError(file, error.response.data.error);

    if (!this.uploadNextQueuedFile()) {
      this.setState({ isUploading: false });
    }
  }

  updateProgress(file, progress) {
    this.setState((prevState) => {
      const { files } = prevState;

      file.setProgress(progress);
      files[file.id] = file;

      return { files: files };
    });
  }

  setUploadPreview(file, path) {
    this.setState((prevState) => {
      const { files } = prevState;

      file.setPreview(path);
      files[file.id] = file;

      return { files: files };
    });
  }

  setUploadError(file, error) {
    this.setState((prevState) => {
      const { files } = prevState;

      file.setError(error);
      files[file.id] = file;

      return { files: files };
    });
  }

  renderFileInput() {
    const name = `${this.props.modelName}[${this.props.attrName}]${this.allowMultipleFiles ? '[]' : ''}`;
    const id = `${this.props.modelName}_${this.props.attrName}`;
    let classModifier;

    if (this.state.isUploading) {
      classModifier = 'file-uploader__select-files-input-label--disabled';
    }

    return (
      <label htmlFor={id} className={`file-uploader__select-files-input-label ${classModifier} cta cta-white`}>
        <input
          id={id}
          type="file"
          disabled={this.state.isUploading}
          className="file-uploader__select-files-input"
          name={name}
          multiple={this.allowMultipleFiles}
          accept="image/*"
          onChange={this.uploadFiles} />
        {this.props.uploadButtonLabel}
      </label>
    );
  }

  render() {
    return (
      <div className="file-uploader">
        <form
          className="file-uploader__form"
          encType="multipart/form-data"
          action={this.props.url}
          acceptCharset="UTF-8"
          method="POST">

          {this.renderFileInput()}
          <FileError error={this.state.error} />
        </form>

        <UploadCount files={this.state.files} />
        <UploadList files={this.state.files} />
      </div>
    );
  }

}

export default FileUploader;

mountReactComponent(FileUploader, 'file-uploader');
