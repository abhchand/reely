import ActivateUserModal from './activate_user_modal';
import { dateToYMD } from 'javascript/utils/date_helpers';
import FilterTable from 'javascript/components/filter_table';
import { IconRefresh } from 'components/icons';
import React from 'react';

class AdminDeactivatedUserList extends React.Component {
  constructor(props) {
    super(props);

    this._i18nPrefix = 'components.admin_deactivated_user_list';

    // Function Bindings
    this.refreshFilterTable = this.refreshFilterTable.bind(this);
    this.openActivateUserModal = this.openActivateUserModal.bind(this);
    this.closeActivateUserModal = this.closeActivateUserModal.bind(this);
    this.renderHeader = this.renderHeader.bind(this);
    this.renderBody = this.renderBody.bind(this);

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
        <td className='avatar' />
        <td className='name'>{I18n.t(`${this._i18nPrefix}.header.name`)}</td>
        <td className='email'>{I18n.t(`${this._i18nPrefix}.header.email`)}</td>
        <td className='last-signed-in'>
          {I18n.t(`${this._i18nPrefix}.header.last_signed_in`)}
        </td>
        <td className='activate-user' />
      </tr>
    );
  }

  renderBody(users) {
    /* eslint-disable react/jsx-max-depth */
    return users.map((user) => {
      return (
        <tr
          key={user.id}
          className='admin-deactivated-user-list__row'
          data-id={user.id}>
          <td className='avatar'>
            <div className='avatar-container'>
              <img alt={user.name()} src={user.avatarPath('thumb')} />
            </div>
          </td>
          <td className='name'>{user.name()}</td>
          <td className='email'>{user.email}</td>
          <td className='last-signed-in'>
            {user.lastSignInAt ? dateToYMD(new Date(user.lastSignInAt)) : '-'}
          </td>
          <td className='activate-user'>
            <button
              type='button'
              data-id={user.id}
              data-name={user.name()}
              onClick={this.openActivateUserModal}>
              <IconRefresh
                size='18'
                fillColor='#000000'
                title={I18n.t(
                  `${this._i18nPrefix}.header.activate_user.icon_title`
                )}
              />
            </button>
          </td>
        </tr>
      );
    });
    /* eslint-enable react/jsx-max-depth */
  }

  renderActivateUserModal() {
    if (this.state.activateUser) {
      return (
        <ActivateUserModal
          key={`deactivate-user-modal-${this.state.activateUser.id}`}
          user={this.state.activateUser}
          closeModal={this.closeActivateUserModal}
          refreshFilterTable={this.refreshFilterTable}
        />
      );
    }

    return null;
  }

  render() {
    return [
      <FilterTable
        key='filter-table'
        renderHeader={this.renderHeader}
        renderBody={this.renderBody}
        refreshAt={this.state.filterTableLastRefreshedAt}
        fetchUrl='/api/v1/users?active=false'
        containerClass='admin-deactivated-users-list'
      />,
      this.renderActivateUserModal()
    ];
  }
}

export default AdminDeactivatedUserList;
