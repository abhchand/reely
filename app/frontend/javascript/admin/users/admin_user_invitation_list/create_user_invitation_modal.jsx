import axios from 'axios';
import Modal from 'javascript/components/modal';
import ModalError from 'javascript/components/modal/error';
import PropTypes from 'prop-types';
import React from 'react';
import ReactOnRails from 'react-on-rails/node_package/lib/Authenticity';

class CreateUserInvitationModal extends React.Component {

  static propTypes = {
    closeModal: PropTypes.func.isRequired,
    // eslint-disable-next-line react/no-unused-prop-types
    refreshFilterTable: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props);

    this.createUserInvitation = this.createUserInvitation.bind(this);
    this.renderErrorText = this.renderErrorText.bind(this);
    this.renderInput = this.renderInput.bind(this);

    this.inputRef = React.createRef();
    this.i18nPrefix = 'components.admin_user_invitation_list.create_user_invitation_modal';

    this.state = {
      errorText: null
    };
  }

  createUserInvitation() {
    const self = this;

    const url = '/user_invitations.json';
    const data = {
      user_invitation: {
        email: this.inputRef.current.value
      }
    };
    const config = {
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': ReactOnRails.authenticityToken()
      }
    };

    this.setState({
      errorText: null
    });

    return axios.post(url, data, config).
      then((_response) => {
        self.props.refreshFilterTable();
        self.props.closeModal();
      }).
      catch((error) => {
        self.setState({
          errorText: error.response.data.error
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

  renderInput() {
    return (
      <input
        ref={this.inputRef}
        className="create-user-invitation-modal__email"
        type="text"
        name="user_invitation[email]"
        autoComplete="off" />
    );
  }

  render() {
    return (
      <Modal
        modalClassName="create-user-invitation-modal"
        heading={I18n.t(`${this.i18nPrefix}.heading`)}
        submitButtonLabel={I18n.t(`${this.i18nPrefix}.buttons.submit`)}
        closeButtonLabel={I18n.t(`${this.i18nPrefix}.buttons.close`)}
        onSubmit={this.createUserInvitation}
        closeModal={this.props.closeModal}>

        {I18n.t(`${this.i18nPrefix}.body`)}
        {this.renderErrorText()}
        {this.renderInput()}
      </Modal>
    );
  }

}

export default CreateUserInvitationModal;
