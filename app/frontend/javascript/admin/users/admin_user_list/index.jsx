import { dateToYMD } from 'javascript/utils/date_helpers';
import DeactivateUserModal from './deactivate_user_modal';
import FilterTable from 'javascript/components/filter_table';
import { IconTrash } from 'components/icons';
import React from 'react';

class AdminUserList extends React.Component {

  constructor(props) {
    super(props);

    this.refreshFilterTable = this.refreshFilterTable.bind(this);
    this.openDeactivateUserModal = this.openDeactivateUserModal.bind(this);
    this.closeDeactivateUserModal = this.closeDeactivateUserModal.bind(this);
    this.renderHeader = this.renderHeader.bind(this);
    this.renderBody = this.renderBody.bind(this);

    this.i18nPrefix = 'components.admin_user_list';

    this.state = {
      deactivateUser: null,
      filterTableLastRefreshedAt: Date.now()
    };
  }

  refreshFilterTable() {
    this.setState({
      filterTableLastRefreshedAt: Date.now()
    });
  }

  // eslint-disable-next-line padded-blocks
  openDeactivateUserModal(e) {

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
       * <DeactivateUserModal /> component
       */
      deactivateUser: { id: userId, name: userName }
    });
  }

  closeDeactivateUserModal() {
    this.setState({
      deactivateUser: null
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
        <td className="role">
          {I18n.t(`${this.i18nPrefix}.header.role`)}
        </td>
        <td className="last-signed-in">
          {I18n.t(`${this.i18nPrefix}.header.last_signed_in`)}
        </td>
        <td className="deactivate-user" />
      </tr>
    );
  }

  renderBody(users) {
    /* eslint-disable react/jsx-max-depth */
    return (
      users.map((user) => {
        const name = `${user.first_name} ${user.last_name}`;

        return (
          <tr key={user.id} className="admin-user-list__row" data-id={user.id}>
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
            <td className="role">
              {user.role || '-'}
            </td>
            <td className="last-signed-in">
              {user.last_sign_in_at ? dateToYMD(new Date(user.last_sign_in_at)) : '-'}
            </td>
            <td className="deactivate-user">
              <button
                type="button"
                data-id={user.id}
                data-name={name}
                onClick={this.openDeactivateUserModal}>
                <IconTrash
                  size="18"
                  fillColor="#DC0073"
                  title={I18n.t(`${this.i18nPrefix}.header.deactivate_user.icon_title`)} />
              </button>
            </td>
          </tr>
        );
      })
    );
    /* eslint-enable react/jsx-max-depth */
  }

  renderDeactivateUserModal() {
    if (this.state.deactivateUser) {
      return (
        <DeactivateUserModal
          key={`deactivate-user-modal-${this.state.deactivateUser.id}`}
          user={this.state.deactivateUser}
          closeModal={this.closeDeactivateUserModal}
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
        fetchUrl="/admin/users.json"
        containerClass="admin-user-list" />,
      this.renderDeactivateUserModal()
    ];
  }

}

export default AdminUserList;
