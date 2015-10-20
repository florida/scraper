require 'nokogiri'
require 'mechanize'
require 'uri'
require 'scraper/helpers/link_validation'
require 'json'

module Scraper
  class Crawler
    @@links = []
    attr_accessor :domain, :link_regex
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

    protected

    # gets page
    # params @string domain
    def get_page(domain)
      return unless Scraper::LinkValidation.link_valid?(domain.to_s)

      @mechanize ||= Mechanize.new
      @mechanize.get(domain)

    rescue Mechanize::ResponseCodeError
      false
    end

    #unsure
    def get_text(link_children)
      return link_children if node.element_children.empty?
      link.node.element_children.first.node_name ## get image link if
      # link.node.element_children.attr('src')
    end

    # returns an array of links
    def get_all_links(domain)
      links = []
      #match all relative path pages
      match =
      page = get_page(domain)
      return unless page

      page.links_with(href: match).each do |link|
        link_uri = URI.join(domain, link.uri.to_s).to_s
        if link_uri[-1, 1] === '#'
          link_uri[-1, 1] = ''
        end
        next if link_already_exists?(link_uri)
        @@links <<  link_uri
        links << {title: link.to_s, uri: link_uri}
      end
      links
    end

    def link_already_exists?(link)
      @@links.include? link
    end

    def crawl(domain, data = {})
      return unless Scraper::LinkValidation.link_valid?(domain.to_s)

      return if /community/ =~ domain
      return if /help/ =~ domain
      return if /one-click-apps/ =~ domain
      return if /blog/ =~ domain

      pages = get_all_links(domain)
      return data if pages === nil

      data = {uri: domain}

      coop = []
      pages.each do |pagina|
        coop << crawl(pagina[:uri], data)
      end
      data.merge({pages: coop.compact})
    end
  end
end

