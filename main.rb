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

get '/grunwald' do
  <<-EOS
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
  <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
  	<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;">
  	<title>Grunwald</title>
  	<link rel="apple-touch-icon" href="http://grab.by/10Yq"/>  
  	<style type="text/css">
  	  body[orient="landscape"] {
  	    width: 480px;
  	  }

  	  body[orient="portrait"] {
  	    width: 320px;
  	  }

  	  body {
  	    background-color: #000;
  	    color: #eee;
  	    font-family: Helvetica;
  	    text-align: center;
      }

      ul {
        padding: 0;
      }

      ul li {
        list-style: none;
      }

      span {color: #f90;}
  	</style>
  </head>

  <body>
    #{Grunwald.offblast!}
  </body>
  </html>
   EOS
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

post '/jarbuilder' do
  JarBuilder.new.call(params)
  "done"
end