require 'json'
require 'scraper/link_content_parser'

module Scraper
  class Crawler
    include Scraper::Logging
    attr_accessor :domain

    IGNORE_LIST = /community|blog/

    def initialize(domain, options = {})
      @domain = domain
      @ignore_list = options[:ignore_list] || IGNORE_LIST
      @output_file = options[:output_file] || 'sites.json'
    end

    def do_crawl
      pages = crawl(@domain, {})
      File.open(@output_file, 'w') do |f|
        f.write pages.to_json
      end
    end

    def crawl(domain, data = {})
      return if /community|help|one-click-apps|blog/ =~ domain

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

