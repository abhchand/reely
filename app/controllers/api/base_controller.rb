class Api::BaseController < ApplicationController
  # See: https://stackoverflow.com/a/42804099/2490003
  skip_forgery_protection

  before_action :ensure_json_request

  rescue_from Exception do |_exception|
    # NOTE: Errors not visible to end users are not translated
    error = {
      title: "An unknown error occurred",
      status: "500"
    }

    render json: { errors: [error] }, status: 500
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    # NOTE: Errors not visible to end users are not translated
    error = {
      title: "Record Not Found",
      description: exception.message,
      status: "404"
    }

    render json: { errors: [error] }, status: 404
  end

  rescue_from CanCan::AccessDenied do |_exception|
    # NOTE: Errors not visible to end users are not translated
    error = {
      title: "Insufficient Permissions",
      status: "403"
    }

    render json: { errors: [error] }, status: 403
  end

  private

  def ensure_can_read_rubric
    authorize! :read, :rubric
  end

  def ensure_can_write_rubric
    authorize! :write, :rubric
  end

  def load_resource
    raise NotImplementedError
  end

  def paginate(collection)
    default = Api::Response::PaginationLinksService::PAGE_SIZE

    collection.
      paginate(
        page: params[:page],
        per_page: params[:per_page] || default
      )
  end

  def pagination_links(collection)
    service = Api::Response::PaginationLinksService.new(
      collection,
      request.url,
      request.query_parameters
    )

    { self: request.url, next: service.next_url, last: service.last_url }
  end
end
