class Logic
  def self.change_params(request, param, params)
    Rack::Response.new do |response|
      response.set_cookie(param, request.cookies["#{param}"].to_i + rand(5))

      params.each { |param| response.set_cookie(param, request.cookies["#{param}"].to_i - rand(4)) }

      response.redirect('/index')
  end
end
