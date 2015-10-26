require 'mechanize'
require 'uri'
require 'scraper/helpers/link'
require 'json'
require 'scraper/link_content_parser'
require 'byebug'

module Scraper
  class Crawler
    attr_accessor :domain, :link_regex
    # should be passed in as an options parameter
    LINK_REGEX = /^([\#\/\!\$\&\-\;\=\?\-\[\]\_\~\.a-z0-9]+)$/

    def initialize(domain, link_regex = nil)
      @domain = domain
      @link_regex = link_regex || LINK_REGEX
    end

    def do_crawl
      pages = crawl(@domain, {})
      File.open("sites.json", 'w') do |f|
        f.write pages.to_json
      end
    end

    ## ufh
    def get_assets(page)
      assets = []
      assets << page.images_with(:mime_type => /gif|jpeg|png/).map(&:to_s)
      assets
    end

    def crawl(domain, data = {})
      # ignore list
      return if /community|help|one-click-apps|blog/ =~ domain

      content = Scraper::LinkContentParser.new(domain, link_regex)
      pages = content.get_all_links

      # or if pages is blank
      return data if pages === nil

      data = {uri: domain}

      link_col = []

      pages.each do |p|
        link_col << crawl(p, data)
      end

      data.merge({pages: link_col.compact})
    end
  end
end

