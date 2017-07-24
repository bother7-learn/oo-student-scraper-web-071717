require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    student = Nokogiri::HTML(html)
    # binding.pry
    scraper = []

    student.css("div.student-card").map do |name|
      scraper << {name: name.css("h4").text, location: name.css("p").text, profile_url: name.css("a").attribute("href").value}
      # scraper[:name] = name.css("h4").text
      # scraper[:location] = name.css("p").text
      # scraper[:profile_url] = name.css("a").attribute("href").value
      # binding.pry
    end

    # binding.pry
    scraper

  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    student = Nokogiri::HTML(html)
    # binding.pry
    scraper = []
    dictionary = {}
    student.css("div.main-wrapper.profile").css("div.social-icon-container").css("a").map do |name|
    scraper << name.attribute("href").value
    # binding.pry
    end
    quote = student.css("div.profile-quote").text ## .gsub!(/\A"|"\Z/, '')
    # binding.pry
    dictionary = dictionary.merge(:profile_quote => quote)
    bio = student.css("div.description-holder").first.text
    bio = bio.gsub(/\s+/, ' ')
    # binding.pry
    dictionary= dictionary.merge(:bio => bio.strip)
    scraper.each do |quote|
      if quote.include? ("linkedin")
        dictionary = dictionary.merge(:linkedin => quote)
      elsif quote.include? ("github")
        dictionary = dictionary.merge(:github => quote)
      elsif quote.include? ("twitter")
        dictionary = dictionary.merge(:twitter => quote)
      elsif quote.empty?
      else
        dictionary = dictionary.merge(:blog => quote)
      end
    end
    dictionary
  end

end
