require 'scraper/helpers/link'
require 'scraper/helpers/logging'
require 'mechanize'
require 'set'

module Scraper
  class LinkContentParser
    include Scraper::Logging

    @@agent = nil
    @@links = Set.new

    def initialize(domain, link_regex)
      @domain = validate_domain(domain)
      @link_regex = link_regex
      @page = get_page
    end

    def get_all_links
      return unless @page
      record_link(@page.uri.to_s)

      links = []
      @page.links_with(href: @link_regex).each do |link|
        link_uri = Scraper::Helpers::Link.stitch_relative_path(@domain, link.uri.to_s)
        #next if link isn't valid
        next if link_already_exists? link_uri

        logger.info("crawling #{link_uri}")

        record_link(link_uri)
        links << link_uri
      end
      links
    end

    def get_all_assets
      @page.images_with(:mime_type => /gif|jpeg|png/).map(&:to_s)
    end

    protected

    def get_page
      return unless domain_is_valid?

      @@agent ||= Mechanize.new
      @@agent.get(@domain)

    rescue Mechanize::ResponseCodeError
    rescue SocketError
    end

    def validate_domain(domain)
      Scraper::Helpers::Link.add_scheme(domain)
    end

    def domain_is_valid?
      Scraper::Helpers::Link.link_valid?(@domain)
    end

    def link_already_exists?(link)
      @@links.include? link
    end

    def record_link(link)
      @@links << link
    end
  end
end
