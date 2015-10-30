require 'spec_helper'

describe Scraper::Helpers::Link do
  let(:link_helper) { Scraper::Helpers::Link }
  describe "#link_valid?" do
    it "should return true if the link is valid" do
      expect(link_helper.link_valid?('http://digitalocean.com')).to be_truthy
      expect(link_helper.link_valid?('https://digitalocean.com')).to be_truthy
    end

    context "link is invalid" do
      it "should return false if link is invalid" do
        expect(link_helper.link_valid?('notaink')).to be_falsy
        expect(link_helper.link_valid?('special^characters')).to be_falsy
        expect(link_helper.link_valid?('')).to be_falsy
      end
    end
  end

  describe "#add_scheme" do
    it "should add a scheme to a valid url that doesn't have a scheme" do
      expect(link_helper.add_scheme('digitalocean.com')).to eq 'http://digitalocean.com'
    end

    it "should return a link submitted with a scheme" do
      link = 'http://digitalocean.com'
      expect(link_helper.add_scheme(link)).to eq link
    end
  end

  describe "#stitch_relative_path" do
    it "should stitch the relative path to the domain" do
      domain = 'http://do.co'
      path = '/cool-things'

      expect(link_helper.stitch_relative_path(domain, path)).to eq 'http://do.co/cool-things'
    end

    it "should remove the # sign if it's at the end of the line" do
      domain ='http://do.co'

      path = '/#'
      expect(link_helper.stitch_relative_path(domain, path)).to eq 'http://do.co/'

      path = '/woop#'
      expect(link_helper.stitch_relative_path(domain, path)).to eq 'http://do.co/woop'

      path = '/#woop'
      expect(link_helper.stitch_relative_path(domain, path)).to eq 'http://do.co/#woop'
    end
  end
end
