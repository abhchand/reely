import PropTypes from 'prop-types';
import React from 'react';
import UpdateUserRoleModal from './update_user_role_modal';

class UpdateUserRole extends React.Component {

  static propTypes = {
    user: PropTypes.object.isRequired,
    roles: PropTypes.array.isRequired,
    refreshFilterTable: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props);

    this.closeModal = this.closeModal.bind(this);
    this.openModal = this.openModal.bind(this);
    this.renderRolesButton = this.renderRolesButton.bind(this);
    this.renderModal = this.renderModal.bind(this);

    this.i18nPrefix = 'components.admin_user_list.update_user_role';

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

  renderRolesButton() {
    return (
      <input
        key="update-user-role-button"
        type="button"
        className="update-user-role__update-btn cta cta-white"
        value={I18n.t(`${this.i18nPrefix}.button_label`)}
        onClick={this.openModal} />
    );
  }

  renderModal() {
    if (this.state.isModalOpen) {
      return (
        <UpdateUserRoleModal
          key="update-user-role-modal"
          user={this.props.user}
          roles={this.props.roles}
          closeModal={this.closeModal}
          refreshFilterTable={this.props.refreshFilterTable} />
      );
    }

    return null;
  }

  render() {
    return [
      this.renderRolesButton(),
      this.renderModal()
    ];
  }

}

export default UpdateUserRole;
