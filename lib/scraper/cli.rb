require 'thor'
require 'scraper/crawler'
require 'scraper/helpers/logging'

module Scraper
  class CLI < Thor
    include Scraper::Logging

    option :ignore_list

    desc "scrape [DOMAIN]", "Scrapes the url of a given [DOMAIN] and outputs to a json file"
    def scrape(domain)
      logger.info(set_color "scraping #{domain}", :yellow)
      crawler = Scraper::Crawler.new(domain)
      crawler.do_crawl
    rescue SocketError
      logger.error(set_color "Internet connection not found, please check internet connection or try again later.", :red)
    end
  end
end


