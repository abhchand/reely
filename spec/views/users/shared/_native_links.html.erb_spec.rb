require 'rails_helper'

RSpec.describe 'users/shared/_native_links.html.erb', type: :view do
  before do
    @t_prefix = 'users.shared.native_links'
    allow(controller).to receive(:controller_name) { controller_name }
  end

  context 'confirmations controller' do
    let(:controller_name) { 'confirmations' }

    it 'renders the links' do
      render

      expect(page).to have_link(
        t("#{@t_prefix}.log_in"),
        href: new_user_session_path
      )
      expect(page).to have_link(
        t("#{@t_prefix}.register"),
        href: new_user_registration_path
      )
      expect(page).to have_link(
        t("#{@t_prefix}.reset_password"),
        href: new_user_password_path
      )
      expect(page).to_not have_link(
                            t("#{@t_prefix}.resend_confirmation"),
                            href: new_user_confirmation_path
                          )
    end
  end

  context 'passwords controller' do
    let(:controller_name) { 'passwords' }

    it 'renders the links' do
      render

      expect(page).to have_link(
        t("#{@t_prefix}.log_in"),
        href: new_user_session_path
      )
      expect(page).to have_link(
        t("#{@t_prefix}.register"),
        href: new_user_registration_path
      )
      expect(page).to_not have_link(
                            t("#{@t_prefix}.reset_password"),
                            href: new_user_password_path
                          )
      expect(page).to have_link(
        t("#{@t_prefix}.resend_confirmation"),
        href: new_user_confirmation_path
      )
    end
  end

  context 'registrations controller' do
    let(:controller_name) { 'registrations' }

    it 'renders the links' do
      render

      expect(page).to have_link(
        t("#{@t_prefix}.log_in"),
        href: new_user_session_path
      )
      expect(page).to_not have_link(
                            t("#{@t_prefix}.register"),
                            href: new_user_registration_path
                          )
      expect(page).to_not have_link(
                            t("#{@t_prefix}.reset_password"),
                            href: new_user_password_path
                          )
      expect(page).to have_link(
        t("#{@t_prefix}.resend_confirmation"),
        href: new_user_confirmation_path
      )
    end
  end

  context 'sessions controller' do
    let(:controller_name) { 'sessions' }

    it 'renders the links' do
      render

      expect(page).to_not have_link(
                            t("#{@t_prefix}.log_in"),
                            href: new_user_session_path
                          )
      expect(page).to have_link(
        t("#{@t_prefix}.register"),
        href: new_user_registration_path
      )
      expect(page).to have_link(
        t("#{@t_prefix}.reset_password"),
        href: new_user_password_path
      )
      expect(page).to have_link(
        t("#{@t_prefix}.resend_confirmation"),
        href: new_user_confirmation_path
      )
    end
  end
end
