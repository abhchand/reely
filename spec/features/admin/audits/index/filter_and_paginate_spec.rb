require 'rails_helper'

RSpec.feature 'Filter and Paginate', type: :feature, js: true do
  let(:admin) { create(:user, :admin) }

  before { log_in(admin) }

  it 'admin can filter on a specified modifier and clear the filter' do
    other_user = create(:user)
    other_user.add_role(:director, modifier: admin)

    audits = Audited::Audit.order(:created_at).to_a
    expect(audits.count).to eq(4)

    # View full audits table

    visit admin_audits_path
    expect_audit_table_records_to_be(
      [
        audits[3],
        # `admin` Adding role to `other_user`
        audits[
          2
        ],
        # `other_user` completing their UserInvitation on sign up
        audits[
          1
        ],
        # `admin` adding the "admin" role to itself (FactoryBot)
        audits[
          0
        ] # `admin` user creation
      ]
    )

    # Filter on on changes from `admin`

    filter_audit_table_by_modifier_for(audits[1])
    expect(page).to have_current_path(
      admin_audits_path(modifier: admin.synthetic_id)
    )

    expect_audit_table_records_to_be(
      [
        audits[3],
        # `admin` Adding role to `other_user`
        audits[
          1
        ],
        # `admin` adding the "admin" role to itself (FactoryBot)
        audits[
          0
        ] # `admin` user creation
      ]
    )
    expect(page).to have_selector('.admin__filter-warning')

    # Clear the filter

    clear_audit_table_modifier_filter
    expect(page).to have_current_path(admin_audits_path)
    expect_audit_table_records_to_be(
      [
        audits[3],
        # `admin` Adding role to `other_user`
        audits[
          2
        ],
        # `other_user` completing their UserInvitation on sign up
        audits[
          1
        ],
        # `admin` adding the "admin" role to itself (FactoryBot)
        audits[
          0
        ] # `admin` user creation
      ]
    )
  end

  describe 'Pagination' do
    it 'admin can paginate through results' do
      other_user = create(:user)
      other_user.add_role(:director, modifier: admin)

      audits = Audited::Audit.order(:created_at).to_a
      expect(audits.count).to eq(4)

      # View paginated results

      visit admin_audits_path(per_page: 3)
      expect_audit_table_records_to_be(
        [
          audits[3],
          # `admin` Adding role to `other_user`
          audits[
            2
          ],
          # `other_user` completing their UserInvitation on sign up
          audits[
            1
          ] # `admin` adding the "admin" role to itself (FactoryBot)
        ]
      )
      # audits[0] # (NOT SHOWN) `admin` user creation

      # Click next page

      page.find('.pagination .next_page').click
      expect_audit_table_records_to_be(
        [
          # rubocop:disable Metrics/LineLength
          # audits[3],  # (NOT SHOWN) `admin` Adding role to `other_user`
          # audits[2],  # (NOT SHOWN) `other_user` completing their UserInvitation on sign up
          # audits[1]   # (NOT SHOWN) `admin` adding the "admin" role to itself (FactoryBot)
          audits[
            0
          ] # `admin` user creation
        ]
      )
      # rubocop:enable Metrics/LineLength
    end
  end
end
