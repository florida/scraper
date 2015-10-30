require 'thor'
require 'scraper/crawler'
require 'scraper/helpers/logging'

module Scraper
  class CLI < Thor
    include Scraper::Logging

    option :ignore_list
    option :output_file

    desc "scrape [DOMAIN]", "Scrapes the url of a given [DOMAIN] and outputs to a json file"
    desc "scrape [DOMAIN] --output_file=[OUTPUTFILE]", "Scrapes the url of a given [DOMAIN] and outputs to the [OUTPUTFILE]"

    def scrape(domain)
      crawler = Scraper::Crawler.new(domain, options)
      crawler.do_crawl
      logger.info(set_color "scraping #{domain}", :yellow)
    rescue SocketError
      logger.error(set_color "Internet connection not found, please check internet connection or try again later.", :red)
    end
  end
end


