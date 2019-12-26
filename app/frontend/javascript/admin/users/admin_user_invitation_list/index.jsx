/* eslint-disable camelcase */
import { dateToYMD } from 'javascript/utils/date_helpers';
import FilterTable from 'javascript/components/filter_table';
import React from 'react';

class AdminUserInvitationList extends React.Component {

  constructor(props) {
    super(props);

    this.updateUserInvitations = this.updateUserInvitations.bind(this);
    this.header = this.header.bind(this);
    this.body = this.body.bind(this);

    this.i18nPrefix = 'components.admin_user_invitation_list';

    this.state = {
      user_invitations: []
    };
  }

  updateUserInvitations(newUserInvitations) {
    this.setState({
      user_invitations: newUserInvitations
    });
  }

  header() {
    return (
      <tr>
        <td className="email">
          {I18n.t(`${this.i18nPrefix}.header.email`)}
        </td>
        <td className="invited-at">
          {I18n.t(`${this.i18nPrefix}.header.invited_at`)}
        </td>
      </tr>
    );
  }

  body() {
    /* eslint-disable react/jsx-max-depth */
    return (
      this.state.user_invitations.map((user_invitation) => {
        return (
          <tr key={user_invitation.id} className="admin-user_invitation-list__row" data-id={user_invitation.id}>
            <td className="email">
              {user_invitation.email}
            </td>
            <td className="invited-at">
              {dateToYMD(new Date(user_invitation.invited_at))}
            </td>
          </tr>
        );
      })
    );
    /* eslint-enable react/jsx-max-depth */
  }

  render() {
    return (
      <FilterTable
        items={this.state.user_invitations}
        updateItems={this.updateUserInvitations}
        tableHeader={this.header()}
        tableBody={this.body()}
        fetchUrl="/admin/user_invitations.json"
        containerClass="admin-user_invitation-list" />
    );
  }

}

export default AdminUserInvitationList;
