module ApplicationHelper
  def current_user_presenter
    @current_user_presenter ||= begin
      UserPresenter.new(current_user, view: view_context) if current_user
    end
  end

  # Devise
  def devise_mapping
    Devise.mappings[:user]
  end

  # Devise automatically sets a flash `notice` on succesful sign in.
  # This hacky workaround removes the flash if it is set.
  def after_sign_in_path_for(resource)
    flash.delete(:notice) if flash[:notice] == t("devise.sessions.signed_in")
    super
  end

  # Devise automatically sets a flash `notice` on succesful sign out.
  # This hacky workaround removes the flash if it is set.
  def after_sign_out_path_for(resource)
    flash.delete(:notice) if flash[:notice] == t("devise.sessions.signed_out")
    super
  end

  def page_specific_css_id
    @page_specific_css_id ||=
      "#{params[:controller]}-#{params[:action]}".tr("_", "-").tr("/", "-")
  end

  def render_inside(opts = {}, &block)
    layout = opts.fetch(:parent_layout)

    layout = "layouts/#{layout}" unless layout.start_with?("layout")
    content_for(:nested_layout_content, capture(&block))
    render template: layout
  end

  # Creates a DOM node on which a React component can be mounted. Encodes
  # props into the `data-react-props` attribute so they can be parsed and
  # passed into the component by client-side JS
  def react_component(mount_id, props)
    id = "react-mount-#{mount_id}"

    content_tag(:div, id: id, data: { react_props: props }) do
    end
  end

  # Action Notifications are similar to flash notifications with a few key
  # differences. See description in the `<ActionNotifications />` React
  # component for further explanation
  #
  # This method expects `@action_notifications` to be a Hash of the following
  # format:
  #
  # {
  #    error: "some message",
  #    notice: ["some other message", "some third message"]
  # }
  #
  # The keys must be one of those defined in the `<ActionNotification />`
  # React component. The values may be either a String or an Array of Strings.
  #
  # This method transforms the above hash into an array of JS objects (hashes)
  # that can be consumed by the React component
  def action_notification_props
    [].tap do |result|
      (@action_notifications || {}).map do |type, texts|
        texts = [texts] unless texts.is_a?(Array)

        texts.each do |text|
          result << { id: text.object_id, content: text, type: type.to_s }
        end
      end
    end
  end

  def to_bool(value)
    ActiveRecord::Type::Boolean.new.deserialize(value)
  end

  # Serialize a collection of objects using an existing serializer
  #
  # e.g.
  #   -> serialize(Foo)
  #   -> serialize(Foo, collection: Foo.where("id < ?", 10))
  def serialize(klass, opts = {})
    collection = opts[:collection] || klass.order(:id)
    serializer = "#{klass}Serializer".constantize

    options = { params: {} }.deep_merge(opts)

    serializer.new(collection, options).serializable_hash
  end

  # Useful for translating param `:id` values from :synthetic_id to :id.
  # Raises `ActiveRecord::RecordNotFound` if not found
  def translate_synthetic_id!(id, klass = User)
    return if id.blank?

    klass.find_by_synthetic_id(id).tap do |record|
      if record.nil?
        raise(
          ActiveRecord::RecordNotFound,
          "Couldn't find #{klass} with 'synthetic_id'=#{id}"
        )
      end
    end.id
  end
end
