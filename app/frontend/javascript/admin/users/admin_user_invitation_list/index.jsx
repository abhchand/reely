/* eslint-disable camelcase */
import CreateUserInvitation from './create_user_invitation';
import { dateToYMD } from 'javascript/utils/date_helpers';
import DeleteUserInvitationModal from './delete_user_invitation_modal';
import FilterTable from 'javascript/components/filter_table';
import { IconTrash } from 'components/icons';
import React from 'react';

class AdminUserInvitationList extends React.Component {

  constructor(props) {
    super(props);

    this.refreshFilterTable = this.refreshFilterTable.bind(this);
    this.openDeleteUserInvitationModal = this.openDeleteUserInvitationModal.bind(this);
    this.closeDeleteUserInvitationModal = this.closeDeleteUserInvitationModal.bind(this);
    this.renderHeader = this.renderHeader.bind(this);
    this.renderBody = this.renderBody.bind(this);
    this.renderCreateUserInvitation = this.renderCreateUserInvitation.bind(this);
    this.renderDeleteUserInvitationModal = this.renderDeleteUserInvitationModal.bind(this);

    this.i18nPrefix = 'components.admin_user_invitation_list';

    this.state = {
      deleteUserInvitation: null,
      filterTableLastRefreshedAt: Date.now()
    };
  }

  refreshFilterTable() {
    this.setState({
      filterTableLastRefreshedAt: Date.now()
    });
  }

  // eslint-disable-next-line padded-blocks
  openDeleteUserInvitationModal(e) {

    /*
     * Store data in the `data-*` fields to avoid having to
     * make a separate request for this info.
     */
    const userInvitationId = e.currentTarget.dataset.id;
    const userInvitationEmail = e.currentTarget.dataset.email;

    this.setState({

      /*
       * NOTE: This format does not match the typical `userInvitation`
       * model format. It's constructed specifically for the
       * <DeleteUserInvitationModal /> component
       */
      deleteUserInvitation: { id: userInvitationId, email: userInvitationEmail }
    });
  }

  closeDeleteUserInvitationModal() {
    this.setState({
      deleteUserInvitation: null
    });
  }

  renderHeader(_userInvitations) {
    return (
      <tr>
        <td className="email">
          {I18n.t(`${this.i18nPrefix}.header.email`)}
        </td>
        <td className="invited-at">
          {I18n.t(`${this.i18nPrefix}.header.invited_at`)}
        </td>
        <td className="delete-user-invitation" />
      </tr>
    );
  }

  renderBody(userInvitations) {
    /* eslint-disable react/jsx-max-depth */
    return (
      userInvitations.map((userInvitation) => {
        return (
          <tr key={userInvitation.id} className="admin-user-invitation-list__row" data-id={userInvitation.id}>
            <td className="email">
              {userInvitation.attributes.email}
            </td>
            <td className="invited-at">
              {dateToYMD(new Date(userInvitation.attributes.invitedAt))}
            </td>
            <td className="delete-user-invitation">
              <button
                type="button"
                data-id={userInvitation.id}
                data-email={userInvitation.attributes.email}
                onClick={this.openDeleteUserInvitationModal}>
                <IconTrash
                  size="18"
                  fillColor="#DC0073"
                  title={I18n.t(`${this.i18nPrefix}.header.delete_user_invitation.icon_title`)} />
              </button>
            </td>
          </tr>
        );
      })
    );
    /* eslint-enable react/jsx-max-depth */
  }

  renderCreateUserInvitation() {
    return (
      <CreateUserInvitation
        key="create-user-invitation"
        refreshFilterTable={this.refreshFilterTable} />
    );
  }

  renderDeleteUserInvitationModal() {
    if (this.state.deleteUserInvitation) {
      return (
        <DeleteUserInvitationModal
          key={`delete-user-invitation-modal-${this.state.deleteUserInvitation.id}`}
          userInvitation={this.state.deleteUserInvitation}
          closeModal={this.closeDeleteUserInvitationModal}
          refreshFilterTable={this.refreshFilterTable} />
      );
    }

    return null;
  }

  render() {
    return [
      this.renderCreateUserInvitation(),
      <FilterTable
        key="filter-table"
        renderHeader={this.renderHeader}
        renderBody={this.renderBody}
        refreshAt={this.state.filterTableLastRefreshedAt}
        fetchUrl="/api/v1/user_invitations"
        containerClass="admin-user_invitation-list" />,
      this.renderDeleteUserInvitationModal()
    ];
  }

}

export default AdminUserInvitationList;
