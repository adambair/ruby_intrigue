require 'rubygems'
require 'uri'
require 'restclient'
require 'nokogiri'

class QueuedCrawler
  class NoUrlSpecified < StandardError; end

  def self.start_crawling(options={})
    new(options)
  end

  def initialize(options={})
    @url = options[:url]
    @max_depth = options[:depth]
    
    @mutex = Mutex.new
    @queue = []

    raise NoUrlSpecified unless @url
    puts "We're going to crawl: #{@url} with a max depth of #{@max_depth}"

    start_crawler
    start_fetchers
  end

  def queue
    @mutex.synchronize do
      @queue
    end
  end

  def start_crawler
    #Thread.new { crawl(@url) }
    queue.push([url, 0]
  end

  def start_fetchers
    @fetcher_threads = []
    3.times { 
      @fetcher_threads << Thread.new {
        loop do
          if item = queue.shift
            crawl(*item)
          end

          next unless queue.empty?
          sleep 0.5
        end
      }
    }

    @fetcher_threads.each{|t| t.join}
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
      #log("PUSHING #{new_url} to queue", depth)
      queue.push([new_url, depth+1])
    end
  end

  def log(message, depth=0)
    puts "#{"\t"*depth}#{Thread.current.object_id} - #{message}"
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
  QueuedCrawler.start_crawling :url => ARGV[0], :depth => 2 
end

