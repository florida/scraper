require 'uri'
module Scraper
  module Helpers
    class Link
      def self.link_valid?(uri)
        uri =~ /\A#{URI::regexp}\z/

        #!!URI.parse(uri)
      #rescue URI::InvalidURIError
      #  false
      end

      def self.get_url_with_scheme(url)
        return true if /http/ =~ url
        URI.parse(url).scheme.nil? ? "http://#{url}" : url
      end

      def self.get_host(url)
        url = get_url_with_scheme(url)
        url = URI.parse(url)
        url.host
      end

      def self.stitch_relative_path(domain, relative_path)
        URI.join(domain, relative_path).to_s.gsub(/\#+$/, '')
      end
    end
  end
end

