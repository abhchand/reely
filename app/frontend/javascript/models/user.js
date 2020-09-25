import BaseModel from './framework/base-model';

/**
 * Models a single `User` record
 */
class User extends BaseModel {
  constructor(id) {
    super('user', id);

    // Function Bindings
    this.avatarPath = this.avatarPath.bind(this);
    this.hasAbility = this.hasAbility.bind(this);
    this.name = this.name.bind(this);
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
