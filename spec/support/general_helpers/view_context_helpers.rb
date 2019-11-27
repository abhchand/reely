module GeneralHelpers
  def view_context
    @view_context ||= begin
      lookup_context = ActionView::Base.build_lookup_context(nil)
      ActionView::Base.new(lookup_context)
    end
  end
end
