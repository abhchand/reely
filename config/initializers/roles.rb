ALL_ROLES =
  if Rails.env.test?
    %w[admin manager director].freeze
  else
    %w[admin].freeze
  end
