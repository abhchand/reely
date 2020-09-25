require 'rails_helper'

RSpec.describe Admin::UserRoles::UpdateService, type: :interactor do
  let(:current_user) { create(:user, :admin) }
  let(:user) { create(:user) }

  before do
    stub_const('ALL_ROLES', %w[manager director admin])

    @i18n_prefix = 'admin.user_roles.update_service'
  end

  describe 'adding roles' do
    before { user.add_role(:admin) }

    it 'adds any necessary roles to the user' do
      result = call(roles: %w[admin manager])

      expect(result.success?).to eq(true)

      expect(user.reload.roles.pluck(:name)).to match_array(%w[admin manager])

      expect(result.error).to be_nil
      expect(result.log).to be_nil
      expect(result.status).to be_nil
    end

    it 'audits the addition of roles' do
      call(roles: %w[admin manager director])

      audit = user.audits.last(2)

      # rubocop:disable Metrics/LineLength

      expect(audit[0].auditable).to eq(user)
      expect(audit[0].user).to eq(current_user)
      expect(audit[0].action).to eq('update')
      expect(audit[0].audited_changes).to eq(
        'audited_roles' => [nil, 'manager']
      )
      expect(audit[0].version).to eq(3)
      expect(audit[0].request_uuid).to_not be_nil
      expect(audit[0].remote_address).to be_nil

      expect(audit[1].auditable).to eq(user)
      expect(audit[1].user).to eq(current_user)
      expect(audit[1].action).to eq('update')
      expect(audit[1].audited_changes).to eq(
        'audited_roles' => [nil, 'director']
      )
      expect(audit[1].version).to eq(4)
      expect(audit[1].request_uuid).to_not be_nil
      expect(audit[1].remote_address).to be_nil

      # rubocop:enable Metrics/LineLength
    end
  end

  describe 'removing roles' do
    before do
      user.add_role(:admin)
      user.add_role(:manager)
    end

    it 'removes any necessary roles to the user' do
      result = call(roles: %w[manager])

      expect(result.success?).to eq(true)

      expect(user.reload.roles.pluck(:name)).to match_array(%w[manager])

      expect(result.error).to be_nil
      expect(result.log).to be_nil
      expect(result.status).to be_nil
    end

    it 'audits the removal of roles' do
      call(roles: %w[])

      audit = user.audits.last(2)

      # rubocop:disable Metrics/LineLength

      expect(audit[0].auditable).to eq(user)
      expect(audit[0].user).to eq(current_user)
      expect(audit[0].action).to eq('update')
      expect(audit[0].audited_changes).to eq('audited_roles' => ['admin', nil])
      expect(audit[0].version).to eq(4)
      expect(audit[0].request_uuid).to_not be_nil
      expect(audit[0].remote_address).to be_nil

      expect(audit[1].auditable).to eq(user)
      expect(audit[1].user).to eq(current_user)
      expect(audit[1].action).to eq('update')
      expect(audit[1].audited_changes).to eq(
        'audited_roles' => ['manager', nil]
      )
      expect(audit[1].version).to eq(5)
      expect(audit[1].request_uuid).to_not be_nil
      expect(audit[1].remote_address).to be_nil

      # rubocop:enable Metrics/LineLength
    end
  end

  it 'can remove all roles if needed' do
    user.add_role(:admin)
    user.add_role(:manager)
    result = call(roles: %w[])

    expect(result.success?).to eq(true)

    expect(user.reload.roles.pluck(:name)).to match_array(%w[])

    expect(result.error).to be_nil
    expect(result.log).to be_nil
    expect(result.status).to be_nil
  end

  it 'correctly handles duplicate roles' do
    user.add_role(:admin)

    result = call(roles: %w[admin manager manager])

    expect(result.success?).to eq(true)

    expect(user.reload.roles.pluck(:name)).to match_array(%w[admin manager])

    expect(result.error).to be_nil
    expect(result.log).to be_nil
    expect(result.status).to be_nil
  end

  context 'one ore more roles are invalid' do
    it 'does not update any roles' do
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
      { current_user: current_user, user: user, roles: [] }.merge(opts)
    )
  end
end
