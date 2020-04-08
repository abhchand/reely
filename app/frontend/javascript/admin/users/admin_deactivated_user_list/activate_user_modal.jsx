import axios from 'axios';
import Modal from 'javascript/components/modal';
import PropTypes from 'prop-types';
import React from 'react';
import ReactOnRails from 'react-on-rails/node_package/lib/Authenticity';

class ActivateUserModal extends React.Component {

  static propTypes = {
    user: PropTypes.object.isRequired,
    closeModal: PropTypes.func.isRequired,
    refreshFilterTable: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props);

    this.body = this.body.bind(this);
    this.activateUser = this.activateUser.bind(this);

    this.i18nPrefix = 'components.admin_deactivated_user_list.activate_user_modal';
  }

  body() {
    return I18n.t(`${this.i18nPrefix}.body`, { name: this.props.user.name });
  }

  activateUser() {
    const url = `/deactivated_users/${this.props.user.id}`;
    const config = {
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': ReactOnRails.authenticityToken()
      },
      params: {}
    };

    return axios.delete(url, config).
      then((_response) => {
        this.props.refreshFilterTable();
        this.props.closeModal();
      }).
      catch((error) => {
        // eslint-disable-next-line no-console
        console.error(`Error deleting user - HTTP ${error.response.status}: '${error.response.data.error}'`);
        this.props.closeModal();
      });
  }

  render() {
    return (
      <Modal
        modalClassName="activate-user-modal"
        heading={I18n.t(`${this.i18nPrefix}.heading`)}
        submitButtonLabel={I18n.t(`${this.i18nPrefix}.buttons.submit`)}
        closeButtonLabel={I18n.t(`${this.i18nPrefix}.buttons.close`)}
        onSubmit={this.activateUser}
        onClose={this.props.closeModal}>
        {this.body()}
      </Modal>
    );
  }

}

export default ActivateUserModal;
