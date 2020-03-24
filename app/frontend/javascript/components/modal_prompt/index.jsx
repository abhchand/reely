import axios from 'axios';
import Modal from 'javascript/components/modal';
import ModalError from 'javascript/components/modal/error';
import PropTypes from 'prop-types';
import React from 'react';
import ReactOnRails from 'react-on-rails/node_package/lib/Authenticity';

class ModalPrompt extends React.Component {

  static propTypes = {
    // Modal Props
    heading: PropTypes.string.isRequired,
    subheading: PropTypes.string,

    /*
     * `onSubmit` for the modal is not configurable. The submit behavior
     * is pre-defined in the `onSubmit` function below. However, this
     * module does offer an `onSubmitSuccess` to be executed after
     * submit.
     * onSubmit: PropTypes.func,
     */
    onClose: PropTypes.func,
    submitButtonLabel: PropTypes.string,
    closeButtonLabel: PropTypes.string,

    /*
     * Not configurable. Submit button is always enabled
     * since this is a prompt. Preserved here for clarity
     * submitButtonEnabled: PropTypes.bool,
     */
    modalClassName: PropTypes.string,

    // ModalPrompt props
    bodyText: PropTypes.string,
    submitUrl: PropTypes.string.isRequired,
    httpMethod: PropTypes.string.isRequired,
    // eslint-disable-next-line react/no-unused-prop-types
    onSubmitSuccess: PropTypes.func
  };

  static defaultProps = Modal.defaultProps;

  constructor(props) {
    super(props);

    this.onSubmit = this.onSubmit.bind(this);
    this.renderErrorText = this.renderErrorText.bind(this);

    this.state = {
      errorText: null
    };
  }

  onSubmit() {
    const self = this;

    const config = {
      method: this.props.httpMethod,
      url: this.props.submitUrl,
      data: null,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': ReactOnRails.authenticityToken()
      }
    };

    this.setState({
      errorText: null
    });

    return axios(config).
      then((_response) => {
        if (self.props.onSubmitSuccess) {
          self.props.onSubmitSuccess();
        }
      }).
      catch((error) => {
        self.setState({
          errorText: error.response.data.errors[0].description
        });

        /*
         * Return a rejected value so the promise chain remains in
         * a rejected state
         */
        return Promise.reject(error);
      });
  }

  renderErrorText() {
    if (this.state.errorText !== null) {
      return <ModalError text={this.state.errorText} />;
    }

    return null;
  }

  render() {
    return (
      <Modal
        heading={this.props.heading}
        subheading={this.props.subheading}
        onSubmit={this.onSubmit}
        onClose={this.props.onClose}
        submitButtonLabel={this.props.submitButtonLabel}
        closeButtonLabel={this.props.closeButtonLabel}
        submitButtonEnabled
        modalClassName={this.props.modalClassName}>

        {this.renderErrorText()}
        <div className="modal-content__body">
          {this.props.bodyText}
        </div>
      </Modal>
    );
  }

}

export default ModalPrompt;
