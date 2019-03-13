class ApplicationPresenter < SimpleDelegator
  include Rails.application.routes.url_helpers

  attr_accessor :model

  def initialize(model, view:)
    @model = model
    @view = view

    super(@model)
  end

  def self.wrap(collection, view:)
    collection.map { |obj| new(obj, view: view) }
  end
end
