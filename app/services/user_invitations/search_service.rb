class UserInvitations::SearchService
  PAGE_SIZE = 20

  attr_reader :page, :total_user_invitations

  def initialize(params)
    @search = params[:search]

    # Params come in as String values
    # rubocop:disable Metrics/LineLength
    @page = params[:page].present? ? params[:page].to_i : 1
    @page_size = params[:page_size].present? ? params[:page_size].to_i : PAGE_SIZE
    # rubocop:enable Metrics/LineLength
  end

  def perform
    @user_invitations = UserInvitation.where(invitee: nil).order("lower(email)")

    filter_results! if @search.present?

    # Compute count before we paginate
    @total_user_invitations = @user_invitations.count

    paginate_results!
  end

  def total_pages
    return if total_user_invitations.nil?

    (total_user_invitations.to_f / @page_size).ceil
  end

  private

  def filter_results!
    search_tokens.each do |token|
      @user_invitations = @user_invitations.where(
        <<-SQL
        lower(email) LIKE '%#{token}%'
        SQL
      )
    end
  end

  def paginate_results!
    offset = (@page - 1) * @page_size
    @user_invitations = @user_invitations.limit(@page_size).offset(offset)
  end

  def search_tokens
    @search_tokens ||=
      @search.
      split(" ").
      compact.
      map(&:downcase).
      map { |t| UserInvitation.sanitize_sql_like(t) }
  end
end
