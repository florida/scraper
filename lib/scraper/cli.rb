require 'thor'
require 'scraper/crawler'

module Scraper
  class CLI < Thor
    option :domain
    option :ignore_list

    desc "url", "scrape url"
    def scrape
      crawler = Scraper::Crawler.new(options[:domain])
      crawler.do_crawl
      puts "scraping #{options[:domain]}"
    end
  end
end


