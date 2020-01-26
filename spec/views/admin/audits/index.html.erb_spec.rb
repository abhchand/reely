require "rails_helper"

RSpec.describe "admin/audits/index.html.erb", type: :view do
  let(:admin) { create(:user) }
  let(:other) { create(:user) }

  before do
    @t_prefix = "admin.audits.index"

    # rubocop:disable Metrics/LineLength
    stub_view_context
    stub_template "admin/_breadcrumb_heading.html.erb" => "_stubbed_breadcrumb_heading"
    expect(view).to receive(:will_paginate) { "_stubbed_will_paginate" }
    # rubocop:enable Metrics/LineLength

    # Create some audits
    admin
    other
    other.add_role(:admin, modifier: admin)

    #
    # Verify we have the right audits
    #

    @audits = Audited::Audit.order(:created_at).to_a
    expect(@audits.size).to eq(3)

    # Creation of `admin`
    expect(@audits[0].action).to eq("create")
    expect(@audits[0].auditable).to eq(admin)

    # Creation of `other`
    expect(@audits[1].action).to eq("create")
    expect(@audits[1].auditable).to eq(other)

    # admin updating role of other
    expect(@audits[2].action).to eq("update")
    expect(@audits[2].user).to eq(admin)
    expect(@audits[2].auditable).to eq(other)
    expect(@audits[2].audited_changes["audited_roles"]).to eq([nil, "admin"])

    # Audits will be rendered in the order defined above since this is a
    # view spec and doesn't use any custom business sorting logic
    assign(:audits, @audits)
  end

  it "renders the breadcrumb heading" do
    render
    expect(page).to have_content("_stubbed_breadcrumb_heading")
  end

  describe "filter message" do
    it "does not render a filter message" do
      render

      expect(page).to_not have_selector(".admin-audits--filter-enabled")
    end

    context "filtering by a modifier" do
      before { assign(:modifier, admin) }

      it "renders a filter message warning and clear link" do
        render

        msg = page.find(".admin-audits--filter-enabled")

        expect(msg.find(".warning").text).to eq(
          t("#{@t_prefix}.filter_enabled.warning", name: admin.name)
        )
        expect(msg.find(".clear")).to have_link(
          t("#{@t_prefix}.filter_enabled.clear"),
          href: admin_audits_path
        )
      end
    end
  end

  describe "audits table" do
    it "renders the table heading" do
      render

      expect(page.all("thead td").map(&:text)).to eq(
        [
          t("#{@t_prefix}.header.modifier"),
          t("#{@t_prefix}.header.description"),
          t("#{@t_prefix}.header.created_at")
        ]
      )
    end

    it "renders the table body" do
      render

      rows = page.all("tbody tr")

      expect(rows.count).to eq(3)

      # Corresponds to `@audits[2]` - admin updating other's role
      last_row = rows.last

      expect(last_row.find(".modifier")).to have_link(
        admin.name,
        href: admin_audits_path(modifier: admin.synthetic_id)
      )
      expect(last_row.find(".description").text).to eq(
        t(
          "admin.audit.user_description.updated_to_add_role",
          name: other.name,
          role: "admin"
        )
      )
      expect(last_row.find(".created_at").text).to eq(
        @audits[0].created_at.strftime(t("time.formats.month_day_and_year"))
      )
      expect(last_row.find(".created_at span")["title"]).to eq(
        @audits[0].created_at.strftime(t("time.formats.timestamp_with_zone"))
      )
    end

    context "a modifier exists for a particular audit record" do
      before { @audits[2].update!(user: nil) }

      it "renders the modifier name as a link" do
        render

        rows = page.all("tbody tr")

        # Corresponds to `@audits[2]` - admin updating other's role
        last_row = rows.last

        expect(last_row.find(".modifier")).to_not have_link(admin.name)
      end
    end
  end
end
