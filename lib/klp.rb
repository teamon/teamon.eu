require 'net/http'
require 'iconv'

class Klp
  def initialize(url)
    @http = Net::HTTP.new('klp.pl')
    match = url.match(%r[http://(.+).klp.pl/a-(\d+).html])
    raise ArgumentError unless match
    @name = match[1]
    @id = match[2]
    @content = [] 
  end

  def fetch_page(page)
    resp, body = @http.get "/doda.php?akcja=druk&ida=#{@id}&strona=#{page}"
    Iconv.iconv('utf-8', 'iso-8859-2', body).first
  end
  
  def parse_content(body)
    body = body[%r[</h1>(.+)strona: &nbsp;&nbsp;]um, 1] || body[%r[</h1>(.+)<a(.+)drukuj]um, 1]
    body.gsub(/\[b\](.+?)\[\/b\]/m, '<strong>\1</strong>').gsub(/\[c\](.+?)\[\/c\]/m, '<blockquote>\1</blockquote>')
  end
  
  def join
    page = fetch_page(1)
    @title = page[%r[<h1>(.+?)</h1>], 1]
    pages_count = page.scan(%r[<a href=\?akcja=druk&ida=\d+&strona=(\d+)>]u).flatten.map {|e| e.to_i}.max || 1
    @content << parse_content(page)
    if pages_count > 1
      (2..pages_count).each do |p|
        @content << parse_content(fetch_page(p))
      end
    end
    
    @title + "<br/><br/><p>" + @content.join("</p><p>") + "</p>"
  end
end