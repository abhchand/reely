class Users::SearchService
  PAGE_SIZE = 20

  attr_reader :page, :total_users

  def initialize(params)
    @search = params[:search]

    # Params come in as String values
    # rubocop:disable Metrics/LineLength
    @page = params[:page].present? ? params[:page].to_i : 1
    @page_size = params[:page_size].present? ? params[:page_size].to_i : PAGE_SIZE
    # rubocop:enable Metrics/LineLength
  end

  def perform
    @users = User.all.order("lower(first_name)")

    filter_results! if @search.present?

    # Compute count before we paginate
    @total_users = @users.count

    paginate_results!
  end

  def total_pages
    return if total_users.nil?

    (total_users.to_f / @page_size).ceil
  end

  private

  def filter_results!
    search_tokens.each do |token|
      @users = @users.where(
        <<-SQL
        lower(first_name) LIKE '%#{token}%'
        OR lower(last_name) LIKE '%#{token}%'
        OR lower(email) LIKE '%#{token}%'
        SQL
      )
    end
  end

  def paginate_results!
    offset = (@page - 1) * @page_size
    @users = @users.limit(@page_size).offset(offset)
  end

  def search_tokens
    @search_tokens ||=
      @search.
      split(" ").
      compact.
      map(&:downcase).
      map { |t| User.sanitize_sql_like(t) }
  end
end
