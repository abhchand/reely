import ActivateUserModal from './activate_user_modal';
import { dateToYMD } from 'javascript/utils/date_helpers';
import FilterTable from 'javascript/components/filter_table';
import { IconRefresh } from 'components/icons';
import React from 'react';

class AdminDeactivatedUserList extends React.Component {

  constructor(props) {
    super(props);

    this.refreshFilterTable = this.refreshFilterTable.bind(this);
    this.openActivateUserModal = this.openActivateUserModal.bind(this);
    this.closeActivateUserModal = this.closeActivateUserModal.bind(this);
    this.renderHeader = this.renderHeader.bind(this);
    this.renderBody = this.renderBody.bind(this);

    this.i18nPrefix = 'components.admin_deactivated_user_list';

    this.state = {
      activateUser: null,
      filterTableLastRefreshedAt: Date.now()
    };
  }

  refreshFilterTable() {
    this.setState({
      filterTableLastRefreshedAt: Date.now()
    });
  }

  // eslint-disable-next-line padded-blocks
  openActivateUserModal(e) {

    /*
     * Store data in the `data-*` fields to avoid having to
     * make a separate request for this info.
     */
    const userId = e.currentTarget.dataset.id;
    const userName = e.currentTarget.dataset.name;

    this.setState({

      /*
       * NOTE: This format does not match the typical `user`
       * model format. It's constructed specifically for the
       * <ActivateUserModal /> component
       */
      activateUser: { id: userId, name: userName }
    });
  }

  closeActivateUserModal() {
    this.setState({
      activateUser: null
    });
  }

  renderHeader(_users) {
    return (
      <tr>
        <td className="avatar" />
        <td className="name">
          {I18n.t(`${this.i18nPrefix}.header.name`)}
        </td>
        <td className="email">
          {I18n.t(`${this.i18nPrefix}.header.email`)}
        </td>
        <td className="last-signed-in">
          {I18n.t(`${this.i18nPrefix}.header.last_signed_in`)}
        </td>
        <td className="activate-user" />
      </tr>
    );
  }

  renderBody(users) {
    /* eslint-disable react/jsx-max-depth */
    return (
      users.map((user) => {
        const name = `${user.first_name} ${user.last_name}`;

        return (
          <tr key={user.id} className="admin-deactivated-user-list__row" data-id={user.id}>
            <td className="avatar">
              <div className="avatar-container">
                <img alt={name} src={user.avatar_path} />
              </div>
            </td>
            <td className="name">
              {name}
            </td>
            <td className="email">
              {user.email}
            </td>
            <td className="last-signed-in">
              {user.last_sign_in_at ? dateToYMD(new Date(user.last_sign_in_at)) : '-'}
            </td>
            <td className="activate-user">
              <button
                type="button"
                data-id={user.id}
                data-name={name}
                onClick={this.openActivateUserModal}>
                <IconRefresh
                  size="18"
                  fillColor="#000000"
                  title={I18n.t(`${this.i18nPrefix}.header.activate_user.icon_title`)} />
              </button>
            </td>
          </tr>
        );
      })
    );
    /* eslint-enable react/jsx-max-depth */
  }

  renderActivateUserModal() {
    if (this.state.activateUser) {
      return (
        <ActivateUserModal
          key={`deactivate-user-modal-${this.state.activateUser.id}`}
          user={this.state.activateUser}
          closeModal={this.closeActivateUserModal}
          refreshFilterTable={this.refreshFilterTable} />
      );
    }

    return null;
  }

  render() {
    return [
      <FilterTable
        key="filter-table"
        renderHeader={this.renderHeader}
        renderBody={this.renderBody}
        refreshAt={this.state.filterTableLastRefreshedAt}
        fetchUrl="/admin/deactivated_users.json"
        containerClass="admin-deactivated-users-list" />,
      this.renderActivateUserModal()
    ];
  }

}

export default AdminDeactivatedUserList;
