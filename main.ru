ENV['RACK_ENV'] = "production"

require 'main.rb'

run Sinatra::Application