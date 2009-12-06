require "open-uri"
require "nokogiri"

module Enumerable
   # Like each_with_index, but the value is the array of block results.
   def map_with_index
     a = []
     each_with_index { |e,i| a << yield(e, i) }
     a
   end
end

class Grunwald
  class << self
    def rozklad(url)
      Nokogiri::HTML(open("http://www.wroclaw.pl/rozklady/przystanki/#{url}")).css('table.dzien').inject({}) do |data, table|
        data[table.css('thead tr td').first.content] = table.css('tr').inject([]) do |h, tr|
          if th = tr.css('th').first
            h[th.content.to_i] = tr.css('td').map {|td| td.content =~ /nbsp/ ? nil : td.content.to_i}.reject {|td| td.nil?}
          end
          h
        end
        data
      end
    end

    def offblast!
      out = []
      time = Time.now
      hm = "#{time.hour}#{"%02d" % time.min}".to_i
      r = ['0L_16_2.html', '1_9_1.html'].map_with_index {|a, l| rozklad(a)[
          case time.wday
          when 0 then "Niedziela"
          when 6 then "Sobota"
          else "W dni robocze"
          end
        ].map_with_index {|e, i| 
          unless e.nil?
            e.map {|a| "#{i}#{"%02d" % a}".to_i}
          end
        }.flatten.select{|e| !e.nil? && e >= hm}.map {|e| [e,l]}
      }.inject {|s,a| s + a}.sort{|a,b| a[0] <=> b[0]}[0, 5]
      
      out << "<h2>ZAPIERDALAJ NA #{r.first[1]}</h2>"
      out << "<ul>"
      r.each do |h, l|
        out << "<li>#{h/100}:#{"%02d" % (h%100)} [#{l}]</li>"
      end
      out << "</ul>"
      out.join("\n")
    end
    
  end
end


if $0 == __FILE__
  Grunwald.offblast!
end