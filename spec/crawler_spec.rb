require 'spec_helper'

describe Scraper::Crawler do
  let(:domain) { 'http://digitalocean.com' }
  let(:crawler) { Scraper::Crawler.new(domain) }

  def read_file(filename)
    File.read(filename).chomp
  end

  describe "#initialize" do
    it "should set the proper instance variables" do
      link = 'http://digitalocean.com'
      scraper = Scraper::Crawler.new(link)
      expect(scraper.domain).to eq(link)
    end
  end

  describe "#do_crawl" do
    it "call crawl and write to the json file" do
      fake_json = {'uri' => 'http://do.co'}
      allow_any_instance_of(Scraper::Crawler).to receive(:crawl).and_return(fake_json)
      crawler.do_crawl
      file_content = read_file("#{Dir.pwd}/sites.json")
      expect(JSON.parse(file_content)).to eq(fake_json)
    end

    it "should give out proper error when it cannot write to a file" do

    end
  end

  describe "#crawl" do
    let(:link_regex) {  }
    it "should crawl domain" do
      link_regex = /^([\#\/\!\$\&\-\;\=\?\-\[\]\_\~\.a-z0-9]+)$/

      fake_link_parser_1 = [
        'http://hotline.bling',
        'http://hotline.blingy'
      ]
      fake_links = double(get_all_links: fake_link_parser_1)
      empty_links = double(get_all_links: [])

      expect(Scraper::LinkContentParser).to receive(:new).at_least(:once).with(anything(), link_regex) do |dom|
        fake_link_parser_1.include? dom ? empty_links : fake_links
      end

      expected_data = {
        uri: domain,
        pages: fake_link_parser_1.map { |uri| {uri: uri, pages: []} }
      }

      expect(crawler.crawl(domain, {})).to eq(expected_data)
    end

    it "return data passed if the pages is nil" do
      data = {uri: domain, pages: []}

      allow_any_instance_of(Scraper::LinkContentParser).to receive(:get_all_links).and_return(nil)

      expect(crawler.crawl(domain, data)).to be(data)
    end

    it "#dacrw" do
      expect(crawler.do_crawl).to eq({})
    end
  end
end

