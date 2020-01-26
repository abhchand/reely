class Admin::Audits::ListService
  PAGE_SIZE = 20
  MAX_PAGE_SIZE = 100

  def self.call(params)
    new(params)
  end

  def initialize(params)
    @params = params
  end

  def audits
    @audits ||= begin
      audits = fetch_audits
      audits = filter_by_modifier!(audits) if modifier
      audits
    end
  end

  def modifier
    @modifier ||= User.find_by_synthetic_id(params[:modifier])
  end

  private

  attr_reader :params

  def fetch_audits
    Audited::Audit.
      paginate(page: params[:page], per_page: per_page).
      order(created_at: :desc)
  end

  def filter_by_modifier!(audits)
    audits.where(
      <<-SQL
      (
        -- Filter where the modifier is the `audits.user`
        (user_type = 'User' AND user_id = #{modifier.id})
        OR
        (
          -- Also filter for the specific case where the `User` record
          -- is created. The modifier does not get set as the `audits.user`
          -- but they should be captured as the creator of their own accounts.
          user_type IS NULL
          AND user_id IS NULL
          AND auditable_type = 'User'
          AND auditable_id = #{modifier.id}
          AND action = 'create'
        )
      )
      SQL
    )
  end

  def per_page
    case
    when params[:per_page].blank?   then PAGE_SIZE
    when params[:per_page].to_i < 1 then PAGE_SIZE
    when params[:per_page].to_i > MAX_PAGE_SIZE then MAX_PAGE_SIZE
    else
      params[:per_page]
    end
  end
end
