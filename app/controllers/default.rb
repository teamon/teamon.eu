class Default < Application

  def index
    render
  end
  
  def klp
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
          #{Parser.parse(params[:url])}
        </body>
      </html>
    EOS
      rescue ArgumentError
        'Niepoprawny adres. <a href="/">Powrót</a>'
      end
    else
      render
    end
  end

end
