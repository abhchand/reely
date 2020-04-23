class UserInvitations::SearchService
  PAGE_SIZE = 20

  def self.perform(user_invitations, search)
    new(user_invitations, search).perform
  end

  def initialize(user_invitations, search)
    @user_invitations = user_invitations
    @search = search
  end

  def perform
    user_invitations = @user_invitations.dup

    return user_invitations if @search.blank?

    search_tokens.each do |token|
      user_invitations = user_invitations.where(
        <<-SQL
        lower(email) LIKE '%#{token}%'
        SQL
      )
    end

    user_invitations
  end

  private

  def search_tokens
    @search_tokens ||=
      @search.
      split(" ").
      compact.
      map(&:downcase).
      map { |t| UserInvitation.sanitize_sql_like(t) }
  end
end
