import axios from 'axios';
import Modal from 'javascript/components/modal';
import ModalError from 'javascript/components/modal/error';
import PropTypes from 'prop-types';
import React from 'react';
import ReactOnRails from 'react-on-rails/node_package/lib/Authenticity';

class UpdateUserRoleModal extends React.Component {

  static propTypes = {
    user: PropTypes.object.isRequired,
    roles: PropTypes.array.isRequired,
    closeModal: PropTypes.func.isRequired,
    // eslint-disable-next-line react/no-unused-prop-types
    refreshFilterTable: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props);

    this.labelFor = this.labelFor.bind(this);
    this.descriptionFor = this.descriptionFor.bind(this);
    this.toggleCheckbox = this.toggleCheckbox.bind(this);
    this.updateUserRole = this.updateUserRole.bind(this);
    this.renderErrorText = this.renderErrorText.bind(this);
    this.renderCheckboxes = this.renderCheckboxes.bind(this);

    this.i18nPrefix = 'components.admin_user_list.update_user_role_modal';

    this.state = {
      selectedRoles: this.props.user.roles,
      errorText: null
    };
  }

  labelFor(role) {
    return I18n.t(`roles.${role}.label`);
  }

  descriptionFor(role) {
    return I18n.t(`roles.${role}.description`);
  }

  toggleCheckbox(e) {
    const selectedRoles = this.state.selectedRoles;
    const role = e.currentTarget.dataset.id;

    if (e.currentTarget.checked) {
      // Box was checked, add it to the list
      selectedRoles.push(role);
    }
    else {
      // Box was unchecked, remove it from the list
      const index = selectedRoles.indexOf(role);
      if (index > -1) { selectedRoles.splice(index, 1); }
    }

    this.setState((_prevState) => ({ selectedRoles: selectedRoles }));
  }

  updateUserRole() {
    const self = this;

    const url = `/admin/user_roles/${this.props.user.id}.json`;
    const data = {
      roles: this.state.selectedRoles
    };
    const config = {
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': ReactOnRails.authenticityToken()
      }
    };

    this.setState({
      errorText: null
    });

    return axios.patch(url, data, config).
      then((_response) => {
        self.props.refreshFilterTable();
        self.props.closeModal();
      }).
      catch((error) => {
        self.setState({
          errorText: error.response.data.error
        });

        /*
         * Return a rejected value so the promise chain remains in
         * a rejected state
         */
        return Promise.reject(error);
      });
  }

  renderErrorText() {
    if (this.state.errorText !== null) {
      return <ModalError text={this.state.errorText} />;
    }

    return null;
  }

  renderCheckboxes() {
    return (
      <form className="update-user-role-modal__roles-form" action="http://www.example.com" method="post">
        <input name="_method" type="hidden" value="patch" />
        {
          this.props.roles.map((role, _i) => {
            return (
              <div key={`user-role-label-${role}`} className="update-user-role-modal__role">
                <label htmlFor={`user_role_${role}`} className="checkbox-label">
                  <input
                    id={`user_role_${role}`}
                    data-id={role}
                    name="user[role]"
                    type="checkbox"
                    checked={this.state.selectedRoles.indexOf(role) > -1}
                    onChange={this.toggleCheckbox} />
                  <span>{this.labelFor(role)}</span>
                </label>
                <p>{this.descriptionFor(role)}</p>
              </div>
            );
          })
        }
      </form>
    );
  }

  render() {
    return (
      <Modal
        modalClassName="update-user-role-modal"
        heading={I18n.t(`${this.i18nPrefix}.heading`, { first_name: this.props.user.firstName })}
        submitButtonLabel={I18n.t(`${this.i18nPrefix}.buttons.submit`)}
        closeButtonLabel={I18n.t(`${this.i18nPrefix}.buttons.close`)}
        onSubmit={this.updateUserRole}
        closeModal={this.props.closeModal}>

        {I18n.t(`${this.i18nPrefix}.body`)}
        {this.renderErrorText()}
        {this.renderCheckboxes()}
      </Modal>
    );
  }

}

export default UpdateUserRoleModal;
