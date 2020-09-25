require 'rails_helper'

RSpec.describe 'users/passwords/edit.html.erb', type: :view do
  let(:user) { create(:user) }

  before do
    # rubocop:disable Metrics/LineLength
    stub_template 'layouts/_flash.html.erb' => '_stubbed_flash'
    stub_template 'users/shared/_error_messages.html.erb' =>
                    '_stubbed_error_messages'
    stub_template 'users/shared/_native_links.html.erb' =>
                    '_stubbed_users_native_links'
    # rubocop:enable Metrics/LineLength

    assign(:user, user)

    @t_prefix = 'users.passwords.edit'
  end

  subject { rendered }

  it 'renders the auth form' do
    render

    # General

    is_expected.to have_selector('.auth__logo svg')
    expect(page.find('.auth__heading')).to have_content(
      t("#{@t_prefix}.heading")
    )

    expect(page.find('.auth__form')['action']).to eq(user_password_path)

    # Partials

    is_expected.to have_content('_stubbed_flash')
    is_expected.to have_content('_stubbed_error_messages')
    is_expected.to have_content('_stubbed_users_native_links')

    # Password

    password = page.find('#user_password')
    expect(password['autocomplete']).to eq('new-password')
    expect(password['autofocus']).to eq('autofocus')
    expect(password['type']).to eq('password')
    expect(password['placeholder']).to eq(User.human_attribute_name(:password))

    expect(page.find("label[for='user_password']")).to have_content(
      User.human_attribute_name(:password)
    )

    # Password Confirmation

    password_confirmation = page.find('#user_password_confirmation')
    expect(password_confirmation['autocomplete']).to eq('off')
    expect(password_confirmation['type']).to eq('password')
    expect(password_confirmation['placeholder']).to eq(
      User.human_attribute_name(:password_confirmation)
    )

    expect(
      page.find("label[for='user_password_confirmation']")
    ).to have_content(User.human_attribute_name(:password_confirmation))

    # Submit

    submit = page.find('.auth__form-input--submit input')
    expect(submit['type']).to eq('submit')
    expect(submit['value']).to eq(t("#{@t_prefix}.form.submit"))
    expect(submit['data-disable-with']).to eq(t('form.disable_with'))
  end
end
