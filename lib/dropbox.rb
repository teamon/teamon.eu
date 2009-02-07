require "mechanize"

class Dropbox
  def initialize(email, password)
    @agent = WWW::Mechanize.new
    page = @agent.get('https://www.getdropbox.com/')
    form = page.forms.first
    form.email = email
    form.password = password 
    @agent.submit(form)
  end
  
  def get(path)
    links = []
    @agent.post("https://getdropbox.com/browse2/#{path}?ajax=yes", "d=0&mini&t=6bf8f0d91d").links.each do |link|
      unless link.text.blank? or link.text == "Parent directory"
        links << if link.href =~ %r[/browse2/#{path}/.+]
          [link.text, get(link.href.sub('/browse2/', ''))]
        else
          link
        end
      end
    end
    links
  end
end
