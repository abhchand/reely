module ViewHelpers
  def stub_current_user(current_user = user)
    allow(view).to receive(:current_user) { current_user }
  end

  def stub_view_context
    # `view_context()` is defined in the general helpers, which should be
    # included in all views by default
    allow(view).to receive(:view_context) { view_context }
  end
end
