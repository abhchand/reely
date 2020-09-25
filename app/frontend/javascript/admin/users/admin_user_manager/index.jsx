import AdminDeactivatedUserList from 'javascript/admin/users/admin_deactivated_user_list';
import AdminUserInvitationList from 'javascript/admin/users/admin_user_invitation_list';
import AdminUserList from 'javascript/admin/users/admin_user_list';
import mountReactComponent from 'mount-react-component.jsx';
import PropTypes from 'prop-types';
import React from 'react';
import Tabnav from 'javascript/components/tabnav';

/**
 * Parent component that renders tabs and content on
 * /admin/users
 */
class AdminUserManager extends React.Component {
  static propTypes = {
    roles: PropTypes.array.isRequired
  };

  constructor(props) {
    super(props);

    this._i18nPrefix = 'components.admin_user_manager';
    this._tabs = [
      {
        label: I18n.t(`${this._i18nPrefix}.tabs.users`),
        component: <AdminUserList roles={this.props.roles} />
      },
      {
        label: I18n.t(`${this._i18nPrefix}.tabs.user_invitations`),
        component: <AdminUserInvitationList />
      },
      {
        label: I18n.t(`${this._i18nPrefix}.tabs.deactivated_users`),
        component: <AdminDeactivatedUserList />
      }
    ];

    /*
     * Function Bindings
     */
    this.handleClick = this.handleClick.bind(this);
    this.renderContent = this.renderContent.bind(this);

    this.state = {
      currentTabIndex: 0
    };
  }

  handleClick(index) {
    this.setState({
      currentTabIndex: index
    });
  }

  renderContent() {
    return (
      <div className='admin-user-manager__content'>
        {this._tabs[this.state.currentTabIndex].component}
      </div>
    );
  }

  render() {
    return (
      <div className='admin-user-manager'>
        <Tabnav
          tabLabels={this._tabs.map((t) => t.label)}
          currentTabIndex={this.state.currentTabIndex}
          onClick={this.handleClick}
        />
        {this.renderContent()}
      </div>
    );
  }
}

export default AdminUserManager;

mountReactComponent(AdminUserManager, 'admin-user-manager');
