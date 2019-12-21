/* eslint-disable react/no-danger */
import { closeModal } from './close';
import PropTypes from 'prop-types';
import React from 'react';

class Modal extends React.Component {

  static propTypes = {
    heading: PropTypes.string.isRequired,
    subheading: PropTypes.string,
    onSubmit: PropTypes.func,
    onClose: PropTypes.func,
    submitButtonLabel: PropTypes.string,
    closeButtonLabel: PropTypes.string,
    submitButtonEnabled: PropTypes.bool,
    modalClassName: PropTypes.string,

    children: PropTypes.node
  };

  static defaultProps = {
    closeButtonLabel: I18n.t('components.modal.buttons.close'),
    submitButtonEnabled: true,
    submitButtonLabel: I18n.t('components.modal.buttons.submit')
  }

  constructor(props) {
    super(props);

    this.submitButton = this.submitButton.bind(this);
    this.closeButton = this.closeButton.bind(this);
    this.submit = this.submit.bind(this);
    this.close = this.close.bind(this);

    this.i18nPrefix = 'components.modal';
  }

  submitButton() {
    if (!this.props.onSubmit) {
      return null;
    }

    return (
      <input
        type="button"
        className="modal-content__button modal-content__button--submit cta cta-white"
        value={this.props.submitButtonLabel}
        disabled={!this.props.submitButtonEnabled}
        onClick={this.submit} />
    );
  }

  closeButton() {
    return (
      <input
        type="button"
        className="modal-content__button modal-content__button--close cta cta-white"
        value={this.props.closeButtonLabel}
        onClick={this.close} />
    );
  }

  // eslint-disable-next-line padded-blocks
  submit() {

    /*
     * Call `onSubmit` if it was specified. Assumption here is that submit will
     * always return a Promise
     */
    const result = this.props.onSubmit ? this.props.onSubmit() : Promise.resolve();

    // Automatically close the modal after running `onSubmit`
    result.then(() => { closeModal(); });
  }

  close() {
    if (this.props.onClose) {
      this.props.onClose();
    }

    closeModal();
  }

  render() {
    return (
      <div className={`modal ${this.props.modalClassName}`}>
        <div className="modal-content">
          <h1 className="modal-content__heading" dangerouslySetInnerHTML={{ __html: this.props.heading }} />;
          <h3 className="modal-content__subheading">{this.props.subheading}</h3>

          <div className="modal-content__body">
            {this.props.children}
          </div>

          <div className="modal-content__button-container">
            {this.submitButton()}
            {this.closeButton()}
          </div>
        </div>
      </div>
    );
  }

}

export default Modal;
