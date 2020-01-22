require "rails_helper"

RSpec.describe Admin::UserRoles::UpdateService, type: :interactor do
  let(:user) { create(:user) }

  before do
    stub_const("ALL_ROLES", %w[manager director admin])

    @i18n_prefix = "admin.user_roles.update_service"
  end

  it "adds any necessary roles to the user" do
    user.add_role(:admin)

    result = call(roles: %w[admin manager])

    expect(result.success?).to eq(true)

    expect(user.reload.roles.pluck(:name)).to match_array(%w[admin manager])

    expect(result.error).to be_nil
    expect(result.log).to be_nil
    expect(result.status).to be_nil
  end

  it "removes any necessary roles to the user" do
    user.add_role(:admin)
    user.add_role(:manager)

    result = call(roles: %w[manager])

    expect(result.success?).to eq(true)

    expect(user.reload.roles.pluck(:name)).to match_array(%w[manager])

    expect(result.error).to be_nil
    expect(result.log).to be_nil
    expect(result.status).to be_nil
  end

  it "can remove all roles if needed" do
    user.add_role(:admin)
    user.add_role(:manager)
    result = call(roles: %w[])

    expect(result.success?).to eq(true)

    expect(user.reload.roles.pluck(:name)).to match_array(%w[])

    expect(result.error).to be_nil
    expect(result.log).to be_nil
    expect(result.status).to be_nil
  end

  it "correctly handles duplicate roles" do
    user.add_role(:admin)

    result = call(roles: %w[admin manager manager])

    expect(result.success?).to eq(true)

    expect(user.reload.roles.pluck(:name)).to match_array(%w[admin manager])

    expect(result.error).to be_nil
    expect(result.log).to be_nil
    expect(result.status).to be_nil
  end

  context "one ore more roles are invalid" do
    it "does not update any roles" do
      user.add_role(:admin)

      result = call(roles: %w[admin manager foo])

      expect(result.success?).to eq(false)

      expect(user.reload.roles.pluck(:name)).to match_array(%w[admin])

      expect(result.error).to eq(I18n.t("#{@i18n_prefix}.invalid_roles"))
      expect(result.log).to_not be_nil
      expect(result.status).to eq(403)
    end
  end

  def call(opts = {})
    Admin::UserRoles::UpdateService.call(
      { user: user, roles: [] }.merge(opts)
    )
  end
end
