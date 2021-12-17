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
    #Class: Rack::Response
  end
  
  def render(layout)
    # File.expand_path("../../lib/mygem.rb", __FILE__)
    # ERB.new(File.read(filename)
    # template = ERB.new
    # puts template.result(binding)
    template = File.expand_path("..views/#{layout}", __FILE__)
    ERB.new(File.read(template)).result(binding)
  end

end
