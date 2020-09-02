import Base from './base';

/**
 * Models a single `User` record
 */
class User extends Base {

  constructor(userJson) {
    super(userJson);

    // Function Bindings
    this.email = this.email.bind(this);
    this.firstName = this.firstName.bind(this);
    this.lastName = this.lastName.bind(this);
    this.lastSignInAt = this.lastSignInAt.bind(this);
    this.name = this.name.bind(this);
    this.roles = this.roles.bind(this);
    this.avatarPath = this.avatarPath.bind(this);
    this.hasAbility = this.hasAbility.bind(this);
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

    return this.attr('avatarPaths')[_size];
  }

  hasAbility(ability) {
    const allAbilities = this.attr('currentUserAbilities');
    if (!allAbilities) { return null; }

    return allAbilities[ability];
  }

}

export default User;
