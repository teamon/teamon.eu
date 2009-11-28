require 'rubygems'
require 'sinatra'
require 'erb'

require 'jarbuilder'
require 'klp'

get '/' do
  erb :index
end

get '/klp' do
  if params[:url] != "" and !params[:url].nil?
    begin
  <<-EOS
    <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title></title>
      </head>
      <body>
        #{KLPPrinter.parse(params[:url])}
      </body>
    </html>
  EOS
    rescue ArgumentError
      'Niepoprawny adres. <a href="/">Powrót</a>'
    end
  else
    erb :klp
  end
end

get '/jarbuilder' do
  JarBuilder.new.call(params)
end