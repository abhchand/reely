module GeneralHelpers
  def view_context
    @view_context ||= ActionView::Base.new
  end
end
