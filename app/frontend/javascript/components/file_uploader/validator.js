import { formatFilesize } from 'javascript/utils/filesize_helpers';

class Validator {
  constructor(maxFileCount, maxFileSize) {
    this.maxFileCount = maxFileCount;
    this.maxFileSize = maxFileSize;

    // eslint-disable-next-line camelcase
    this.i18n_prefix = 'components.file_uploader.validator';
  }

  validate(files) {
    if (!this.__validateCount(files)) {
      return this.__messageForInvalidCount();
    }

    if (!this.__validateSize(files)) {
      return this.__messageForInvalidSize();
    }

    return null;
  }

  __validateCount(files) {
    return files.length <= this.maxFileCount;
  }

  __validateSize(files) {
    let largeFileCount = 0;

    files.forEach((file) => {
      if (file.size > this.maxFileSize) {
        largeFileCount += 1;
      }
    });

    return largeFileCount === 0;
  }

  __messageForInvalidCount() {
    return I18n.t(`${this.i18n_prefix}.count`, { count: this.maxFileCount });
  }

  __messageForInvalidSize() {
    const maxFileSize = formatFilesize(this.maxFileSize);

    // eslint-disable-next-line camelcase
    return I18n.t(`${this.i18n_prefix}.size`, { max_size: maxFileSize });
  }
}

export default Validator;
