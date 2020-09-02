import Base from './base';

/**
 * Models a single `UserInvitation` record
 */
class UserInvitation extends Base {

  constructor(userInvitationJson) {
    super(userInvitationJson);

    // Function Bindings
    this.setInviter = this.setInviter.bind(this);
    this.removeInviter = this.removeInviter.bind(this);
    this.inviter = this.inviter.bind(this);
    this.setInvitee = this.setInvitee.bind(this);
    this.removeInvitee = this.removeInvitee.bind(this);
    this.invitee = this.invitee.bind(this);
    this.email = this.email.bind(this);
    this.invitedAt = this.invitedAt.bind(this);
    this.inviterId = this.inviterId.bind(this);
    this.inviteeId = this.inviteeId.bind(this);
  }

  /**
   * Associations
   */

  setInviter(inviter) {
    this.setAssociation('inviter', [inviter]);
  }

  removeInviter() {
    this.setAssociation('inviter', []);
  }

  inviter() {
    return this.association('inviter')[0];
  }

  setInvitee(invitee) {
    this.setAssociation('invitee', [invitee]);
  }

  removeInvitee() {
    this.setAssociation('invitee', []);
  }

  invitee() {
    return this.association('invitee')[0];
  }

  /**
   * Attributes
   */

  email() {
    return this.attr('email');
  }

  invitedAt() {
    return this.attr('invitedAt');
  }

  inviterId() {
    return this.attr('inviterId');
  }

  inviteeId() {
    return this.attr('inviteeId');
  }

}

export default UserInvitation;
