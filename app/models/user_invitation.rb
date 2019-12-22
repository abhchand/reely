class UserInvitation < ApplicationRecord
  belongs_to :inviter, class_name: "User", validate: false
  belongs_to :invitee, class_name: "User", validate: false, optional: true

  validates :email, presence: true, uniqueness: true
  validates :inviter_id, presence: true
  validates :invitee_id, uniqueness: true, allow_nil: true

  before_save { self[:email].downcase! if self[:email].present? }
end
