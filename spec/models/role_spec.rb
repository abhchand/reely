require "rails_helper"

RSpec.describe Role, type: :model do
  subject { create(:role) }

  describe "Associations" do
    it { should have_and_belong_to_many(:users).join_table("users_roles") }
    it { should belong_to(:resource).optional }
  end

  describe "Validations" do
    before { stub_const("Role::RESOURCE_TYPES", %w[Photo]) }

    it { should validate_inclusion_of(:name).in_array(Role::ROLES) }

    it do
      should validate_inclusion_of(:resource_type).
        in_array(Rolify.resource_types).
        allow_nil
    end
  end
end
