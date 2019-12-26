import { dateToYMD } from 'javascript/utils/date_helpers';
import FilterTable from 'javascript/components/filter_table';
import mountReactComponent from 'mount-react-component.jsx';
import React from 'react';

class AdminUserList extends React.Component {

  constructor(props) {
    super(props);

    this.updateUsers = this.updateUsers.bind(this);
    this.header = this.header.bind(this);
    this.body = this.body.bind(this);

    this.i18nPrefix = 'components.admin_user_list';

    this.state = {
      users: []
    };
  }

  updateUsers(newUsers) {
    this.setState({
      users: newUsers
    });
  }

  header() {
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
      </tr>
    );
  }

  body() {
    /* eslint-disable react/jsx-max-depth */
    return (
      this.state.users.map((user) => {
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
          </tr>
        );
      })
    );
    /* eslint-enable react/jsx-max-depth */
  }

  render() {
    return (
      <FilterTable
        items={this.state.users}
        updateItems={this.updateUsers}
        tableHeader={this.header()}
        tableBody={this.body()}
        fetchUrl="/admin/users.json"
        containerClass="admin-user-list" />
    );
  }

}

export default AdminUserList;

mountReactComponent(AdminUserList, 'admin-user-list');
