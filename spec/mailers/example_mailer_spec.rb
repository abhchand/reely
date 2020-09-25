require 'rails_helper'

RSpec.describe ExampleMailer do
  let(:hostname) { BaseSendgridMailer.send(:new).send(:hostname) }

  describe 'new_example' do
    let(:mail) { ExampleMailer.new_example(@user.id) }

    before do
      @user = create(:user)
      @t_prefix = 'example_mailer.new_example'
    end

    it 'sends the email to the user' do
      expect(mail.from).to eq([ENV['EMAIL_FROM']])
      expect(mail.to).to eq([@user.email])
      expect(mail.subject).to eq(t("#{@t_prefix}.subject"))
    end

    it "displays the user's name" do
      expect(mail.body).to have_content(@user.name)
    end
  end
end
