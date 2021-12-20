module Logic
  def self.change_params(request, need, needs)
    Rack::Response.new do |response|

      needs.each { |param| response.set_cookie(param, request.cookies[param.to_s].to_i - rand(2)) }

      response.set_cookie(need, request.cookies[need.to_s].to_i + rand(5)) if request.cookies[need.to_s].to_i < 17

      response.redirect('/index')
    end
  end
end
