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
    @audits ||=
      begin
        audits = fetch_audits
        audits = filter_by_modifier!(audits) if modifier
        audits = filter_by_modified!(audits) if modified
        audits
      end
  end

  def modifier
    @modifier ||= User.find_by_synthetic_id(params[:modifier])
  end

  def modified
    @modified ||= User.find_by_synthetic_id(params[:modified])
  end

  private

  attr_reader :params

  def fetch_audits
    Audited::Audit.paginate(page: params[:page], per_page: per_page).order(
      created_at: :desc
    )
  end

  def filter_by_modifier!(audits)
    audits.where(<<-SQL)
      (
        -- Filter where the modifier is the `audits.user`
        (user_type = 'User' AND user_id = #{
      modifier.id
    })
        OR
        (
          -- Also filter for the specific case where the `User` record
          -- is created. The modifier does not get set as the `audits.user`
          -- but they should be captured as the creator of their own accounts.
          user_type IS NULL
          AND user_id IS NULL
          AND auditable_type = 'User'
          AND auditable_id = #{
      modifier.id
    }
          AND action = 'create'
        )
      )
      SQL
  end

  def filter_by_modified!(audits)
    # The following are events that can occur to a modified user "M":
    #   - Any audited change to a User object M
    #   - Any audited change to a Comment where M is the owner
    #   - Any audited change to a UserInvitation where M is the invitee
    #   - Any audited change to a UserLevel where M is the user
    audits.where(<<-SQL)
      (
        auditable_type = 'User' AND auditable_id = '#{
      modified.id
    }'
      )
      OR
      (
        auditable_type = 'Comment' AND audited_changes->>'owner_id' = '#{
      modified.id
    }'
      )
      OR
      (
        auditable_type = 'UserInvitation' AND audited_changes->>'invitee_id' = '#{
      modified.id
    }'
      )
      OR
      (
        auditable_type = 'UserLevel' AND audited_changes->>'user_id' = '#{
      modified.id
    }'
      )
    SQL
  end

  def per_page
    case
    when params[:per_page].blank?
      PAGE_SIZE
    when params[:per_page].to_i < 1
      PAGE_SIZE
    when params[:per_page].to_i > MAX_PAGE_SIZE
      MAX_PAGE_SIZE
    else
      params[:per_page]
    end
  end
end
