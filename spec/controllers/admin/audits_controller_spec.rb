require 'rails_helper'

RSpec.describe Admin::AuditsController, type: :controller do
  let(:admin) { create(:user, :admin) }

  let(:params) { {} }

  before { sign_in(admin) }

  describe 'GET index' do
    before do
      # Create some audits
      other = create(:user)
      other.add_role(:admin, modifier: admin)

      #
      # Verify we have the right audits
      #

      @audits = Audited::Audit.order(:created_at).to_a
      expect(@audits.size).to eq(4)

      # Creation of `admin`
      expect(@audits[0].action).to eq('create')
      expect(@audits[0].auditable).to eq(admin)

      # admin updating role of itself to :admin
      expect(@audits[1].action).to eq('update')
      expect(@audits[1].user).to eq(admin)
      expect(@audits[1].auditable).to eq(admin)
      expect(@audits[1].audited_changes['audited_roles']).to eq([nil, 'admin'])

      # Creation of `other`
      expect(@audits[2].action).to eq('create')
      expect(@audits[2].auditable).to eq(other)

      # admin updating role of other
      expect(@audits[3].action).to eq('update')
      expect(@audits[3].user).to eq(admin)
      expect(@audits[3].auditable).to eq(other)
      expect(@audits[3].audited_changes['audited_roles']).to eq([nil, 'admin'])
    end

    it 'calls the `admin_only` filter' do
      expect(controller).to receive(:admin_only).and_call_original
      get :index
    end

    it 'assigns @audits and @modifier' do
      get :index, params: params

      expect(assigns[:audits]).to eq(
        [@audits[3], @audits[2], @audits[1], @audits[0]]
      )
      expect(assigns[:modifier]).to be_nil
    end

    context '`modifier` param is present' do
      it 'assigns @audits and @modifier' do
        params[:modifier] = admin.synthetic_id
        get :index, params: params

        expect(assigns[:audits]).to eq([@audits[3], @audits[1], @audits[0]])
        expect(assigns[:modifier]).to eq(admin)
      end
    end
  end
end
