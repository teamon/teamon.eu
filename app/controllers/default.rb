class Default < Application

  # ...and remember, everything returned from an action
  # goes to the client...
  def index
    @links = {
      '/klp' => 'KLP Printer',
      '/fizyka' => 'Fizyka'
    }
    render
  end
  
  def klp
    require "lib/klp"
    
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
          #{Klp.new(params[:url]).join}
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

  
  def forms
    Marshal.load(File.read('form_1228610949_0')).inspect
  end
  
  def form
    if request.post?
      File.open("form_#{Time.now.to_i}_#{rand(100)}", "w") {|f| 
        f.puts Marshal.dump(params)
      }
      render "Formularz został wysłany.", :layout => "form"
    else
    
    
    @form = <<-EOS
Opis firmy
  Streść w kilku punktach misję Twojej firmy

Charakterystyka produktu
  Jakie produkty, usługi sprzedajesz?
  Jak długo Twój produkt lub usługa znajduję się na rynku?
  Co wyróżnia twój produkt lub usługę od innych tego typu?
  Dodatkowe uwagi

Rynek oraz konkurencja
  Z kim konkurujesz?
  Jak wygląda Twoja sprzedaż względem konkurencji?
  Jakie są trendy na rynku, czego szuka klient, którego chcemy przyciągnać?
  Dodatkowe uwagi

Dotychczasowe działania promocyjne (nie tylko w Internecie)
  Z jakich narzędzi internetowych korzystałeś wcześniej w firmie?

Cele firmy
  Opisz cele, jakie wyznaczono firmie oraz poszczególnym twoim produktom i usługom na najbliższe lata.

Oczekiwania komunikacyjne od serwisu
  Co Twój serwis ma mówić o Tobie, jakie informacje chcesz przekazac użytwnikom twojego serwisu?
  Jak chcesz być ocenaiany przez użytkowników na podstawie wyglądu i treści twojego serwisu?
  Dodatkowe uwagi

Grupa docelowa
  Kim mają być twoi klienci (płeć, wiec, wykształcenie, upodobania, zawód, miejsce zamieszkania)
  Przedstaw do czego ma im służyć Twój produkt, w jaki sposób i jak często będą go używać?
  Jakie były Twoje dotychczasowe relacje z klientami, scharakteryzuj ich pod względem wiedzy o danej kategorii produktu, usług oraz zainteresowanie nimi.

Budżet
  Jaki posiadasz roczny budżet reklamowy?
  Ile w skali roku chcesz przeznaczyć z tych funduszy na promocje w Internecie?
  Dodatkowe uwagi

Wykonanie
  Jaką kolorystykę chciałbyś nadać serwisowi?
  Co ma być motywem przewodnim projektu (elementy, abstrakcyjne, elementy naturalne, postaci ludzi, zdjęcia produktów)?
  Elementy serwisu na umieszczeniu których najbardziej Ci zależy
  Dodatkowe uwagi

Dane kontaktowe
    


    EOS
    @form = @form.split("\n\n").map {|e| e.split("\n").map{ |e| e.strip } }

    render :layout => "form"
  end
  end
  
  
  def fizyka
    @links = files("lib/fizyka")
    render
  end
  
  protected 
  
  def files(path)
    html = []
    Dir["#{path}/*"].each do |path|
      unless File.directory?(path)
        html << "<li><a href=\"#{path}\">#{File.basename(path)}</a></li>"
      else
        html << "<li>#{File.basename(path)}<ul>"
        html << files(path)
        html << "</ul></li>"
      end
    end
    
    html.join
  end
  
end
