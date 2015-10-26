require 'spec_helper'

describe Scraper::Crawler do
  # test dont scrape if it's not a link
  # exceptions
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

    it "should accept links with proper schema" do

    end

    it "should accept links with proper schema" do

    end

    it "should return proper error message when link is not valid" do

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
    # TODO: IMPROVE ME
    it "should crawl domain" do

      link_regex = /^([\#\/\!\$\&\-\;\=\?\-\[\]\_\~\.a-z0-9]+)$/

      fake_link_parser_1 = [
        'http://hotline.bling',
        'http://hotline.blingy'
      ]

      sm = double(get_all_links: fake_link_parser_1)
      sma = double(get_all_links: [])

      expect(Scraper::LinkContentParser).to receive(:new).at_least(:once).with(anything(), link_regex) do |dom|
        if fake_link_parser_1.include? dom
          sma
        else
          sm
        end
      end


      #exbpect(Scraper::LinkContentParser).to receive(:new).with('http://hotline.bling', link_regex) do

      expected_data = {
        uri: domain,
        pages: fake_link_parser_1.map { |uri| {uri: uri, pages: []} }
      }

      expect(crawler.crawl(domain, {})).to eq(expected_data)
    end
  end




  describe "errors" do

  end
  describe "it displays links" do


    it "should return array" do
     ######## scraper = Scraper::Crawler.new('http://digitalocean.com')

      #x = scraper.do_crawl
      #x = scraper.get_all_links('http://digitalocean.com')
      #expect(x).to be_instance_of(Array)
    end

    it "should do things" do
      scraper = Scraper::Crawler.new('http://digitalocean.com')

      #x = scraper.do_crawl
#      x = scraper.do_crawl
#      expect(x).to eq('hey')
    end
  end
end


