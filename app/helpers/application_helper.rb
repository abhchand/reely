module ApplicationHelper
  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def current_user_presenter
    @current_user_presenter ||= begin
      UserPresenter.new(current_user, view: view_context) if current_user
    end
  end

  def page_specific_css_id
    "#{params[:controller]}-#{params[:action]}".tr("_", "-")
  end

  def render_inside(opts = {}, &block)
    layout = opts.fetch(:parent_layout)

    layout = "layouts/#{layout}" unless layout.start_with?("layout")
    content_for(:nested_layout_content, capture(&block))
    render template: layout
  end
end
