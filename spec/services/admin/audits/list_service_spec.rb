require 'rails_helper'

RSpec.describe Admin::Audits::ListService, type: :interactor do
  let(:users) { create_list(:user, 2) }
  let(:service) { Admin::Audits::ListService.call(params) }

  let(:params) { {} }

  before do
    stub_const('Admin::Audits::ListService::PAGE_SIZE', 5)

    # Create some audits
    users[1].add_role(:admin, modifier: users[0])
    users[0].add_role(:admin, modifier: users[1])

    #
    # Verify we have the right audits
    #

    @audits = Audited::Audit.order(:created_at).to_a

    # Creation of `users[0]`
    expect(@audits[0].action).to eq('create')
    expect(@audits[0].auditable).to eq(users[0])

    # Creation of `users[1]`
    expect(@audits[1].action).to eq('create')
    expect(@audits[1].auditable).to eq(users[1])

    # users[0] updating role of users[1]
    expect(@audits[2].action).to eq('update')
    expect(@audits[2].user).to eq(users[0])
    expect(@audits[2].auditable).to eq(users[1])
    expect(@audits[2].audited_changes['audited_roles']).to eq([nil, 'admin'])

    # users[1] updating role of users[0]
    expect(@audits[3].action).to eq('update')
    expect(@audits[3].user).to eq(users[1])
    expect(@audits[3].auditable).to eq(users[0])
    expect(@audits[3].audited_changes['audited_roles']).to eq([nil, 'admin'])
  end

  describe '#audits' do
    it 'fetches audit records sorted by descending created_at' do
      expect(service.audits).to eq(
        [@audits[3], @audits[2], @audits[1], @audits[0]]
      )
    end

    describe 'pagination' do
      before { stub_const('Admin::Audits::ListService::PAGE_SIZE', 3) }

      it 'paginates results' do
        expect(service.audits).to eq([@audits[3], @audits[2], @audits[1]])
      end

      it '`page` param returns the correct page' do
        params[:page] = 2

        expect(service.audits).to eq([@audits[0]])
      end

      it '`per_page` overrides the default page size' do
        params[:per_page] = 2

        expect(service.audits).to eq([@audits[3], @audits[2]])
      end

      context '`per_page` is greater than max allowable page size' do
        before do
          stub_const('Admin::Audits::ListService::PAGE_SIZE', 2)
          stub_const('Admin::Audits::ListService::MAX_PAGE_SIZE', 3)

          params[:per_page] = 100
        end

        it 'defaults to the max allowable page size' do
          expect(service.audits).to eq([@audits[3], @audits[2], @audits[1]])
        end
      end

      context '`per_page` is less than 1' do
        before { params[:per_page] = 0 }

        it 'defaults to the default page size' do
          expect(service.audits).to eq([@audits[3], @audits[2], @audits[1]])
        end
      end
    end

    context '`modifier` is specified' do
      before { params[:modifier] = users[0].synthetic_id }

      it 'returns only audits where the user is the modifier' do
        # This tests that we fetch both types of records:
        #   - Audits where the modifier is the `audits.user`
        #   - Audits capturing the creation of the modifier's own User record
        expect(service.audits).to eq([@audits[2], @audits[0]])
      end

      describe 'pagination' do
        before { stub_const('Admin::Audits::ListService::PAGE_SIZE', 1) }

        it 'paginates results' do
          expect(service.audits).to eq([@audits[2]])
        end
      end

      context '`modifier` is invalid' do
        before { params[:modifier] = 'abcde' }

        it 'ignores the param' do
          expect(service.audits).to eq(
            [@audits[3], @audits[2], @audits[1], @audits[0]]
          )
        end
      end
    end

    context '`modified` is specified' do
      before { params[:modified] = users[0].synthetic_id }

      it 'returns only audits where the user is modified' do
        # This tests that we fetch both types of records:
        #   - Audits where the user is modified
        #   - Audits capturing the creation of the modified's own User record
        expect(service.audits).to eq([@audits[3], @audits[0]])
      end

      describe 'pagination' do
        before { stub_const('Admin::Audits::ListService::PAGE_SIZE', 1) }

        it 'paginates results' do
          expect(service.audits).to eq([@audits[3]])
        end
      end

      context '`modifier` is invalid' do
        before { params[:modified] = 'abcde' }

        it 'ignores the param' do
          expect(service.audits).to eq(
            [@audits[3], @audits[2], @audits[1], @audits[0]]
          )
        end
      end
    end
  end

  describe '#modifier' do
    # Most of this functionality is already tested above

    before { params[:modifier] = users[0].synthetic_id }

    it 'returns the modifier' do
      expect(service.modifier).to eq(users[0])
    end
  end
end
