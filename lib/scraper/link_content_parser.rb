require 'scraper/helpers/link'
require 'scraper/helpers/logging'
require 'mechanize'
require 'set'

module Scraper
  class LinkContentParser
    include Scraper::Logging

    LINK_REGEX = /^([\#\/\!\$\&\-\;\=\?\-\[\]\_\~\.a-z0-9]+)$/

    @@agent = nil
    @@links = Set.new

    def initialize(domain, link_regex = {})
      @domain = validate_domain(domain)
      @link_regex = link_regex || LINK_REGEX
      @page = get_page
    end

    def get_all_links
      return unless @page
      record_link(@page.uri.to_s)

      links = []
      @page.links_with(href: LINK_REGEX).each do |link|
        link_uri = Scraper::Helpers::Link.stitch_relative_path(@domain, link.uri.to_s)

        next if !domain_is_valid? link_uri
        next if link_already_exists? link_uri

        logger.info("crawling #{link_uri}")

        record_link(link_uri)
        links << link_uri
      end
      links
    end

    def get_all_assets
      get_images.concat(get_videos.concat(get_js).concat(get_css))
    end

    protected

    def get_images
      @page.images_with(:mime_type => /gif|jpeg|png|bmp/).map(&:to_s)
    end

    def get_videos
      video_sources = @page.search('//source[@src]')
      video_sources.map {|vs| vs.attributes["src"].value }
    end

    def get_js
      scripts = @page.search('//script[@src]')
      scripts.map {|s| s.attributes["src"].value }
    end

    def get_css
      css = @page.search('//link[@rel="stylesheet" and @href]')
      css.map {|c| c.attributes["href"].value }
    end

    def get_page
      return unless domain_is_valid?(@domain)

      @@agent ||= Mechanize.new
      @@agent.get(@domain)

    rescue Mechanize::ResponseCodeError
    rescue SocketError
    end

    def validate_domain(domain)
      Scraper::Helpers::Link.add_scheme(domain)
    end

    def domain_is_valid?(domain)
      Scraper::Helpers::Link.link_valid?(domain)
    end

    def link_already_exists?(link)
      @@links.include? link
    end

    def record_link(link)
      @@links << link
    end
  end
end
