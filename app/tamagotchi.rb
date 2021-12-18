require 'erb'

class Pet

  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
    @food = 20
    @water = 20
    @happy = 20
    @energy = 20
    @skills = 0
    @params = %w[food water happy energy skills]
  end

  def response
    case @request.path
    when '/'
      Rack::Response.new(render("form.html.erb"))
    when '/initialize'
      Rack::Response.new do |response|
        response.set.cookies('food', @food)
        response.set.cookies('water', @water)
        response.set.cookies('happy', @happy)
        response.set.cookies('energy', @energy)
        response.set.cookies('skills', @skills)
        response.set.cookies('sleep', @sleep)
        response.redirect('/index')
    when '/index'
      if [@food, @water, @energy, @happy, @sleep].one?(&:negative?)
        Rack::Response.new('Game Over', 404)
        Rack::Response.new(render("game_over.html.erb"))
      elsif @skills >= 50
        Rack::Response.new('End Game', 404)
        Rack::Response.new(render("end_game.html.erb"))
      else
        Rack::Response.new(render("index.html.erb"))
      end
  end
  
  def render(layout)
    template = File.expand_path("..views/#{layout}", __FILE__)
    ERB.new(File.read(template)).result(binding)
  end

end
