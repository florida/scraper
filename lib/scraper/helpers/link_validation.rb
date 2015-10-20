require 'uri'
require 'byebug'
class Scraper::LinkValidation
  def self.in_same_domain?

  end

  def self.link_valid?(uri)
    #uri = get_url_with_scheme(uri)
    uri =~ /\A#{URI::regexp}\z/
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
end
