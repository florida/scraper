require 'json'
require 'scraper/link_content_parser'

module Scraper
  class Crawler
    include Scraper::Logging
    attr_accessor :domain

    def initialize(domain, options = {})
      @domain = domain
      @ignore_list = options[:ignore_list] || IGNORE_LIST
      @output_file = options[:output_file] || 'sites.json'
    end

    def do_crawl
      pages = crawl(@domain, {})

      begin
        File.open(@output_file, 'w') do |f|
          f.write pages.to_json
        end
      rescue Errno::EACCES => e
        logger.error(e.message)
      end
    end

    def crawl(domain, data = {})
      content = Scraper::LinkContentParser.new(domain)
      pages = content.get_all_links
      assets = content.get_all_assets

      return data if pages === nil

      data = {uri: domain}

      link_col = []
      pages.each do |p|
        link_col << crawl(p, data)
      end

      data.merge({pages: link_col.compact, assets: assets})
    end
  end
end

