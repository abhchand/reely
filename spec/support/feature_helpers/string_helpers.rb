module FeatureHelpers
  def strip_tags(str)
    str.to_s.gsub(/<[^>]*>/, "")
  end
end
