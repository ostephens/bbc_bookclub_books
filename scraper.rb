require 'scraperwiki'
require 'nokogiri'

class Episode
    def initialize(url, booktitle)
        @url = url
        @booktitle = booktitle
    end
    
    attr_reader :booktitle, :url
    attr_accessor :bookauthor
    
    def getAuthor
        xmlurl = @url.to_s + '.xml'
        xml = ScraperWiki.scrape(xmlurl)
        doc = Nokogiri::XML(xml)
        doc.xpath("/programme/title").each do |title|
            @bookauthor = title.inner_text.strip
        end
    end
end

page_add = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','09']

page_add.each do |add|
  url = "http://www.bbc.co.uk/radio4/features/book-club/archives/books-" + add.to_s + '/'
  html = ScraperWiki.scrape(url)
  doc = Nokogiri::HTML(html)
  doc.xpath("//div[@class='box list-promos']/ul/li/a").each do |episodes|
      episode = Episode.new(episodes.attribute("href"),episodes.xpath("strong").inner_text)
      episode.getAuthor
      data = {
      episodeurl: episode.url.to_s,
      booktitle: episode.booktitle.to_s,
      author: episode.bookauthor.to_s
      }
      ScraperWiki::save_sqlite([], data)
  end
end

