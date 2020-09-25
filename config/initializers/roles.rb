ALL_ROLES =
  Rails.env.test? ? %w[admin manager director].freeze : %w[admin].freeze
