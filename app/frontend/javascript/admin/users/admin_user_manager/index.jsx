import AdminUserInvitationList from 'javascript/admin/users/admin_user_invitation_list';
import AdminUserList from 'javascript/admin/users/admin_user_list';
import mountReactComponent from 'mount-react-component.jsx';
import React from 'react';

class AdminUserManager extends React.Component {

  constructor(props) {
    super(props);

    this.handleClick = this.handleClick.bind(this);
    this.renderTabs = this.renderTabs.bind(this);
    this.renderContent = this.renderContent.bind(this);

    this.i18nPrefix = 'components.admin_user_manager';

    this.tabs = [
      { name: 'users', component: <AdminUserList /> },
      { name: 'user_invitations', component: <AdminUserInvitationList /> }
    ];

    this.state = {
      currentTabIndex: 0
    };
  }

  handleClick(e) {
    this.setState({
      currentTabIndex: parseInt(e.currentTarget.dataset.id, 10)
    });
  }

  renderTabs() {
    const tabs = [];

    for (let n = 0; n < this.tabs.length; n++) {
      const btnClass = n === this.state.currentTabIndex ? 'active' : '';

      // eslint-disable-next-line function-paren-newline
      tabs.push(
        <li key={`tab-${n}`} className="admin-user-manager__tab">
          <button data-id={n} className={btnClass} type="button" onClick={this.handleClick}>
            {I18n.t(`${this.i18nPrefix}.tabs.${this.tabs[n].name}`)}
          </button>
        </li>
      // eslint-disable-next-line function-paren-newline
      );
    }

    return <ul className="admin-user-manager__tabs">{tabs}</ul>;
  }

  renderContent() {
    return (
      <div className="admin-user-manager__content">
        {this.tabs[this.state.currentTabIndex].component}
      </div>
    );
  }

  render() {
    return (
      <div className="admin-user-manager">
        {this.renderTabs()}
        {this.renderContent()}
      </div>
    );
  }

}

export default AdminUserManager;

mountReactComponent(AdminUserManager, 'admin-user-manager');
