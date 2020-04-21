/* eslint-disable react/no-danger */
import { registerAsyncProcess, unregisterAsyncProcess } from 'utils/async-registration';

import { closeModal } from './close';
import PropTypes from 'prop-types';
import React from 'react';

class Modal extends React.Component {

  static propTypes = {
    heading: PropTypes.string.isRequired,
    subheading: PropTypes.string,
    onSubmit: PropTypes.func,
    onClose: PropTypes.func,
    closeModal: PropTypes.func,
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
        className="modal-content__button modal-content__button--submit cta cta-purple"
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

    registerAsyncProcess('modal-submit');

    /*
     * Call `onSubmit` if it was specified. There's a few assumptions here
     *
     *    1. `onSubmit`` will return a thenable object (specificaly a Promise)
     *
     *    2. Any error handling that `onSubmit` does with a `catch()` block will
     *       re-raise that error so that the promise chain remains in a rejected
     *       state
     *       Example:
     *
     *           return axios(config).
     *            then((response) => {
     *              // Do stuff
     *            }).
     *            catch((error) => {
     *              // Do stuff
     *
     *              // Keep the promise chain in a rejected state
     *              return Promise.reject(error);
     *            });
     */
    const result = this.props.onSubmit ? this.props.onSubmit() : Promise.resolve();

    const self = this;

    // Automatically close the modal and unregister the async process
    // after running `onSubmit` (regardless of success or error)
    result.
      then(() => { self.close(); }).
      then(() => unregisterAsyncProcess('modal-submit')).
      catch(() => unregisterAsyncProcess('modal-submit'));
  }

  close() {
    if (this.props.onClose) {
      this.props.onClose();
    }

    /*
     * We have two ways of closing modals -
     *
     *  a. Call the handler passed in by the parent that knows how to close
     *     this modal using it's own internal state
     *  b. A default helper that closes the modal by unmounting the react
     *     component on the `#modal` DOM node
     *
     * (b) is used more often when rendering the react modal from vanilla JS
     * instead of rendering it through another component. It's not a great
     * approach and should probably be phased out over time.
     */

    // eslint-disable-next-line no-unused-expressions
    this.props.closeModal ? this.props.closeModal() : closeModal();
  }

  render() {
    return (
      <div className={`modal ${this.props.modalClassName}`}>
        <div className="modal-content">
          <h1 className="modal-content__heading" dangerouslySetInnerHTML={{ __html: this.props.heading }} />
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
