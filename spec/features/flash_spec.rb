require 'rails_helper'

RSpec.feature 'Flash message', type: :feature do
  it "displays the flash message and close 'link'" do
    log_in(User.new, email: 'bad-email@ga.gov')

    expect(page).to have_current_path(new_user_session_path)

    expect(find('.flash')).to be_visible
    expect(find('.flash .message').text).to eq(
      t(
        'devise.failure.invalid',
        authentication_keys: User.human_attribute_name(:email)
      )
    )
    expect(find('.flash .close').text).to eq(t('layouts.flash.close'))
  end

  it 'allows the user to close the flash', js: true do
    log_in(User.new, email: 'bad-email@ga.gov')

    expect(page).to have_current_path(new_user_session_path)

    expect(page).to have_selector('.flash')
    find('.flash .close').click
    expect(page).to_not have_selector('.flash')
  end
end
