module FeatureHelpers
  def url_params(url_to_parse = current_url)
    params =
      Rack::Utils.
      parse_query(URI.parse(url_to_parse).query).
      with_indifferent_access

    params.each { |k, v| params[k] = CGI.unescape(v) }
    params
  end

  def prepend_host_to_path(path)
    host = Capybara.current_session.server.host
    port = Capybara.current_session.server.port
    path = "/#{path}" unless path.first == "/"

    "http://#{host}:#{port}#{path}"
  end
end
