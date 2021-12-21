require 'erb'
require './app/lib/logic'

class Pet
  include Logic

  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
    @food    = 20
    @water   = 20
    @happy   = 20
    @energy  = 20
    @power   = 2
    @params  = %w[food water happy energy power]
  end

  def response
    case @request.path
    when '/'
      Rack::Response.new(render('form.html.erb'))

    when '/initialize'
      Rack::Response.new do |response|
        response.set_cookie('name', @request.params['name'])
        response.set_cookie('food', @food)
        response.set_cookie('water', @water)
        response.set_cookie('happy', @happy)
        response.set_cookie('energy', @energy)
        response.set_cookie('power', @power)
        response.redirect('/index')
      end

    when '/index'
      if [get('food'), get('water'), get('happy'), get('energy')].one?(&:negative?)
        Rack::Response.new('Game Over', 404)
        Rack::Response.new(render('end.html.erb'))
      elsif get('power').to_i >= 20
        Rack::Response.new('You win', 404)
        Rack::Response.new(render('win.html.erb'))
      elsif get('power').to_i <= 0
        Rack::Response.new('You lose', 404)
        Rack::Response.new(render('low_power.html.erb'))
      else
        Rack::Response.new(render('index.html.erb'))
      end

    when '/change'
      return Logic.change_params(@request, 'food', @params) if @request.params['food']
      return Logic.change_params(@request, 'water', @params) if @request.params['water']
      return Logic.change_params(@request, 'happy', @params) if @request.params['happy']
      return Logic.change_params(@request, 'energy', @params) if @request.params['energy']
      return Logic.change_params(@request, 'power', @params) if @request.params['power']

    when '/exit'
      Rack::Response.new('Game Over', 404)
      Rack::Response.new(render('end.html.erb'))

    when '/simple'
      Rack::Response.new('You win?', 404)
      Rack::Response.new(render('simple_finish.html.erb'))
    end
  end

  def render(layout)
    template = File.expand_path("../views/#{layout}", __FILE__)
    ERB.new(File.read(template)).result(binding)
  end

  def get(param)
    param == 'name' ? @request.cookies['name'] : @request.cookies[param.to_s].to_i
  end
end
