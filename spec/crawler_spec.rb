require 'spec_helper'
require 'byebug'

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
    let(:fake_json) { {'uri' => 'http://do.co'} }
    it "call crawl and write to the json file" do
      allow_any_instance_of(Scraper::Crawler).to receive(:crawl).and_return(fake_json)
      crawler.do_crawl
      file_content = read_file("#{Dir.pwd}/sites.json")
      expect(JSON.parse(file_content)).to eq(fake_json)
    end

    it "should give out proper error when it cannot write to a file" do
      allow(crawler).to receive(:crawl).and_return(fake_json)
      allow(File).to receive(:open).and_raise(Errno::EACCES, 'File not found')
      expect_any_instance_of(Scraper::Crawler).to receive(:error).with(/File not found/)
      crawler.do_crawl
    end
  end

  describe "#crawl" do
    let(:link_regex) {  }
    it "should crawl domain" do
      fake_links = [
        'http://hotline.bling',
        'http://hotline.blingy'
      ]
      fake_link_parser = double(get_all_links: fake_links, get_all_assets: ['fake_assets'])
      fake_empty_parser = double(get_all_links: [], get_all_assets: [])


      expect(Scraper::LinkContentParser).to receive(:new).at_least(:once).with(anything()) do |dom|
        (fake_links.include? dom) ? fake_empty_parser : fake_link_parser
      end

      expected_data = {
        uri: domain,
        pages: fake_links.map { |uri| {uri: uri, pages: [], assets: []} },
        assets: ['fake_assets']
      }

      expect(crawler.crawl(domain, {})).to eq(expected_data)
    end

    it "return data passed if the pages is nil" do
      data = {uri: domain, pages: []}

      allow_any_instance_of(Scraper::LinkContentParser).to receive(:get_all_links).and_return(nil)

      expect(crawler.crawl(domain, data)).to be(data)
    end
  end
end

