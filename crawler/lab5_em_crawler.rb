require 'rubygems'
require 'eventmachine'
require 'em-http-request'
require 'restclient'
require 'uri'
require 'nokogiri'

EM.run do
  MAX_DEPTH = 2
  def crawl(url, depth=0)
    uri = URI.parse(url)
    _fetched_url = "http://#{uri.host}#{uri.path}"

    http = EventMachine::HttpRequest.new(_fetched_url).get :query => uri.query, 
            :timeout => 2, :headers => {"Accept" => "text/html"} 
    http.callback {
      page = Nokogiri::HTML(http.response)
      log("FETCHED: #{depth} - #{url} - #{page.css('title').first.content rescue ''}", depth)
      if depth+1 <= MAX_DEPTH 
        page.css('a').each do |link|
          new_url = link['href']
          next unless valid_url?(new_url)
          crawl(new_url, depth+1)
        end
      end
    }

    http.errback {
      log("FAILED: #{depth} - #{url}", depth)
    }
  rescue Exception => e
    puts e.message
    return true
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

  crawl(ARGV[0], 0)
end

