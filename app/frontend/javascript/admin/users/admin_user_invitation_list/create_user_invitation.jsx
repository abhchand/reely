import CreateUserInvitationModal from './create_user_invitation_modal';
import PropTypes from 'prop-types';
import React from 'react';

class CreateUserInvitation extends React.Component {

  static propTypes = {
    refreshFilterTable: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props);

    this.closeModal = this.closeModal.bind(this);
    this.openModal = this.openModal.bind(this);
    this.renderButton = this.renderButton.bind(this);

    this.i18nPrefix = 'components.admin_user_invitation_list.create_user_invitation';

    this.state = {
      isModalOpen: false
    };
  }

  closeModal() {
    this.setState({
      isModalOpen: false
    });
  }

  openModal() {
    this.setState({
      isModalOpen: true
    });
  }

  renderButton() {
    return (
      <input
        key="create-user-invitation-button"
        type="button"
        className="admin-user-invitation-list__create-user-invitation-btn cta cta-green"
        value={I18n.t(`${this.i18nPrefix}.button_label`)}
        onClick={this.openModal} />
    );
  }

  renderModal() {
    if (this.state.isModalOpen) {
      return (
        <CreateUserInvitationModal
          key="create-user-invitation-modal"
          closeModal={this.closeModal}
          refreshFilterTable={this.props.refreshFilterTable} />
      );
    }

    return null;
  }

  render() {
    return [
      this.renderButton(),
      this.renderModal()
    ];
  }

}

export default CreateUserInvitation;
