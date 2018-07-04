module ViewHelpers
  def stub_current_user(current_user = user)
    allow(view).to receive(:current_user) { current_user }
  end
end
