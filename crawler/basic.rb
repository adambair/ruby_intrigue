require 'rubygems'
require 'uri'
require 'restclient'
require 'nokogiri'

class Crawler
  class NoUrlSpecified < StandardError; end

  def self.start_crawling(options={})
    new(options)
  end

  def initialize(options={})
    @url = options[:url]
    @max_depth = options[:depth]
    raise NoUrlSpecified unless @url
    puts "We're going to crawl: #{@url} with a max depth of #{@max_depth}"
    crawl(@url) 
  end

  def crawl(url, depth=0)
    begin
      page_content = RestClient.get(url) 
    rescue Exception
      log("FAILED: #{url}", depth)
    end

    page = Nokogiri::HTML(page_content)
    log ("FETCHED: #{depth} - #{url} - #{page.css('title').first.content rescue ''}", depth)
    return true if depth+1 > @max_depth

    page.css('a').each do |link|
      new_url = link['href']
      next unless valid_url?(new_url)
      crawl(new_url, depth+1)
    end
  end

  def log(message, depth=0)
    puts "#{"\t"*depth}#{message}"
  end

  def valid_url?(url)
    return false if url.nil? || url =~ /^#/ || url =~ /^javascript/
    begin
      URI.parse(url)
      return true
    rescue URI::InvalidURIError
      return false 
    end
  end
end

if __FILE__ == $0
  Crawler.start_crawling :url => ARGV[0], :depth => 2 
end
