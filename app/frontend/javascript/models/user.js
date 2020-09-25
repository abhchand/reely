import BaseModel from './framework/base-model';

/**
 * Models a single `User` record
 */
class User extends BaseModel {
  constructor(id) {
    super('user', id);

    // Function Bindings
    this.email = this.email.bind(this);
    this.firstName = this.firstName.bind(this);
    this.lastName = this.lastName.bind(this);
    this.lastSignInAt = this.lastSignInAt.bind(this);
    this.name = this.name.bind(this);
    this.roles = this.roles.bind(this);
    this.avatarPath = this.avatarPath.bind(this);
    this.hasAbility = this.hasAbility.bind(this);
    this.name = this.name.bind(this);
  }

  /**
   * Attributes
   */

  email() {
    return this.attr('email');
  }

  firstName() {
    return this.attr('firstName');
  }

  lastName() {
    return this.attr('lastName');
  }

  lastSignInAt() {
    return this.attr('lastSignInAt');
  }

  name() {
    return `${this.attr('firstName')} ${this.attr('lastName')}`;
  }

  roles() {
    return this.attr('roles');
  }

  /**
   * Helpers
   */

  avatarPath(size = null) {
    const _size = size || 'thumb';
    return this.avatarPaths[_size];
  }

  hasAbility(ability) {
    const allAbilities = this.currentUserAbilities;
    if (!allAbilities) {
      return null;
    }

    return allAbilities[ability];
  }

  name() {
    return `${this.firstName} ${this.lastName}`;
  }
}

export default User;
