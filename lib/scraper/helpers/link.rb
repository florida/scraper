require 'uri'
module Scraper
  module Helpers
    class Link
      def self.link_valid?(uri)
        !!(uri =~ /\A#{URI::regexp}\z/)
      end

      def self.add_scheme(url)
        URI.parse(url).scheme.nil? ? "http://#{url}" : url
      end

      def self.stitch_relative_path(domain, relative_path)
        URI.join(domain, relative_path).to_s.gsub(/\#+$/, '')
      end
    end
  end
end

