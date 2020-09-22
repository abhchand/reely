import BaseModel from './framework/base-model';

/**
 * Models a single `UserInvitation` record
 */
class UserInvitation extends BaseModel {

  constructor(id) {
    super('userInvitation', id);

    // Function Bindings
    this.setInviter = this.setInviter.bind(this);
    this.removeInviter = this.removeInviter.bind(this);
    this.setInvitee = this.setInvitee.bind(this);
    this.removeInvitee = this.removeInvitee.bind(this);
  }

  /**
   * Associations
   */

  setInviter(inviter) {
    this.setRelationship('inviter', inviter);
  }

  removeInviter() {
    this.setRelationship('inviter', null);
  }

  setInvitee(invitee) {
    this.setRelationship('invitee', invitee);
  }

  removeInvitee() {
    this.setRelationship('invitee', null);
  }

}

export default UserInvitation;
