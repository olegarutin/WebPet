require './app/tamagotchi'

use Rack::Reloader, 0
use Rack::Static, urls: ['/public"']
use Rack::Auth::Basic do |username, _password|
  username == 'admin'
end

run Pet
