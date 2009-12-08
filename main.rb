require 'rubygems'
require 'sinatra'
require 'erb'

require 'jarbuilder'
require 'klp'
require 'grunwald'

set :environment, :production
set :port, 3031

get '/' do
  erb :index
end


post '/jarbuilder' do
  JarBuilder.new.call(params)
  "done"
end