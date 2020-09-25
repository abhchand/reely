class Api::Response::PaginationLinksService
  PAGE_SIZE = 50

  def initialize(data, request_url, query_params)
    @data = data
    @request_url = request_url
    @params = query_params
  end

  def next_url
    return if max_page.zero?
    return if page >= max_page

    new_params = @params.dup
    new_params[:page] = page + 1

    build_with_params(new_params)
  end

  def last_url
    return if max_page.zero?

    new_params = @params.dup
    new_params[:page] = max_page

    build_with_params(new_params)
  end

  private

  def base_url
    @base_url ||= @request_url.split('?', 2).first
  end

  def build_with_params(new_params)
    new_params[:per_page] = safe_per_page if new_params.key?(:per_page)

    [base_url, new_params.to_query].join('?')
  end

  def safe_per_page
    @safe_per_page ||=
      case
      when @params[:per_page].blank?
        PAGE_SIZE
      when !@params[:per_page].to_i.between?(1, PAGE_SIZE)
        PAGE_SIZE
      else
        @params[:per_page].to_i
      end
  end

  def page
    @page ||= (@params[:page] || 1).to_i
  end

  def max_page
    @max_page ||= (@data.count.to_f / safe_per_page).ceil
  end
end
