require 'spec_helper'
describe Scraper::LinkContentParser do
  let(:domain) { 'http://digitalocean.com' }
  let(:link_regex) { /^([\#\/\!\$\&\-\;\=\?\-\[\]\_\~\.a-z0-9]+)$/ }
  let(:link_content) { Scraper::LinkContentParser.new(domain, link_regex) }
  describe "#initialize" do
    it "should assign instance variables" do
      expect(link_content.instance_variable_get(:@domain)).to eq domain
      expect(link_content.instance_variable_get(:@link_regex)).to eq link_regex
    end

    it "should get the mechanize page object" do
      expect(link_content.instance_variable_get(:@page)).to be_a Mechanize::Page
    end


    context "domain without schema" do
      let(:domain) { 'digitalocean.com' }
      it "should accept links without schemas" do
        expect(link_content.instance_variable_get(:@domain)).to eq('http://digitalocean.com')
      end
    end

    context "invalid domain" do
      let(:domain) { 'http://bt' }

      it "should not set the page" do
        expect(link_content.instance_variable_get(:@page)).to be_nil
      end
    end
  end

  describe "#get_all_links" do
    let(:fake_pages) {[
      double(uri: 'http://do.co/mo'),
      double(uri: 'http://do.co/momo')
    ]}

    before { allow_any_instance_of(Mechanize::Page).to receive(:links_with).with(anything()).and_return(fake_pages) }

    it "should get all the links in the domain" do
      links = link_content.get_all_links
      expect(links).to eq(['http://do.co/mo', 'http://do.co/momo'])
    end

    it "should skip link if it already exists" do
      links = link_content.get_all_links
      expect(links).to eq([])
    end

    context "invalid domain" do
      let(:domain) { 'domnein' }

      it "should exit early if link is invalid" do
        links = link_content.get_all_links
        expect(links).to be_nil
      end
    end
  end

  describe "#get_all_assets" do
    it "should concatenate the assets" do
      fake_search_result_value = double(value: 'meowcats')
      fake_search_results = [ double(attributes: { 'src' => fake_search_result_value, 'href' => fake_search_result_value }) ]
      fake_images = ['meow.jpg']
      allow_any_instance_of(Mechanize::Page).to receive(:search).and_return(fake_search_results)
      allow_any_instance_of(Mechanize::Page).to receive(:images_with).and_return(fake_images)

      expect(link_content.get_all_assets).to eq(["meow.jpg", "meowcats", "meowcats", "meowcats"])
    end
  end

  describe "protected" do
    describe "#get_page" do
      it "should get the page" do
        page = link_content.send(:get_page)
        expect(page).to be_a Mechanize::Page
      end
    end

    context "page returns 404" do
      let(:domain) { 'http://digitalocean.com/nolink' }

      it "should return nil" do
        page = link_content.send(:get_page)
        expect(page).to be_nil
      end
    end

    context "page is not valid" do
      let(:domain) { 'nope' }

      it "should return nil" do
        page = link_content.send(:get_page)
        expect(page).to be_nil
      end
    end
  end
end
