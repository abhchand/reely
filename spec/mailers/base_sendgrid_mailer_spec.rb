require "rails_helper"

RSpec.describe BaseSendgridMailer do
  describe "#send_mail" do
    let(:user) { create(:user) }
    let(:mailer) { BaseSendgridMailer.send(:new) }

    it "delivers the email" do
      mailer.instance_variable_set(:@recipient, user.email)
      mailer.instance_variable_set(:@subject, "test")

      expect(mailer).to receive(:mail)
      mailer.send(:send_mail)
    end

    describe "no subject is set" do
      it "raises an error" do
        mailer.instance_variable_set(:@recipient, user.email)
        mailer.instance_variable_set(:@subject, "")

        expect { mailer.send(:send_mail) }.
          to raise_error(BaseSendgridMailer::MissingSubject)
      end
    end

    describe "SMTPAPI Header" do
      let(:user) { create(:user) }
      let(:smtpapi_header) { JSON.parse(find_header(mailer, "X-SMTPAPI")) }

      describe "categories" do
        let(:mailer) { ExampleMailer.new_example(user.id) }

        it "adds the tenant name and method name as a category" do
          expect(smtpapi_header["category"]).to eq(["new_example"])
        end
      end
    end
  end

  def find_header(email, property)
    email.header.detect { |h| h.name == property }.value
  end
end
