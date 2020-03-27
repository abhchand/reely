require "rails_helper"

RSpec.describe Admin::AuditPresenter, type: :presenter do
  describe "#description" do
    # Aribtrarily pick an object type to test with, e.g. Native User
    let!(:user) { create(:user, :native) }

    before do
      @i18n_prefix = "admin.audit.user_description"
      @audit = Audited::Audit.last
    end

    it "fetches the audit description" do
      description = Admin::AuditPresenter.new(@audit, view: nil).description

      expect(description[:error]).to eq(false)
      expect(description[:text]).to eq(t("#{@i18n_prefix}.created_as_native"))
    end

    context "there is an error generating the description" do
      before do
        expect_any_instance_of(User).to receive(:native?).and_raise("💣")
      end

      it "returns a generic error description" do
        description = Admin::AuditPresenter.new(@audit, view: nil).description

        error = I18n.t(
          "admin.audit.shared.error_constructing_description",
          id: @audit.id,
          action: "create",
          auditable_type: "User",
          auditable_id: user.id
        )

        expect(description[:error]).to eq(true)
        expect(description[:text]).to eq(error)
      end
    end
  end
end
