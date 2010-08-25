# More structured script to send an SMS

require 'rubygems'
require 'sms_fu'
require 'smtp-tls'

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
   :address => "smtp.gmail.com",
   :port => 587,
   :domain => "gmail.com",
   :authentication => :plain,
   :user_name => "username",  # don't put "@gmail.com"
   :password => "password",
   :enable_starttls_auto => true }

class SMSSender
  def self.send(options = {})
    new(options)
  end
  
  def initialize(options = {})
    deliver(options[:number], options[:carrier], options[:message])
  end
  
  def deliver(number, carrier, message)
    begin
      SMSFu.deliver(number,carrier,message)
      log("Delivered \"#{message}\" to #{SMSFu.sms_address(number,carrier)}")
    rescue Errno::ECONNREFUSED => e
      log("Connection refused: " + e.message)
    rescue Exception => e
      log("Exception " + e.message)
    end
  end
  
  def log(message)
    puts "[#{Time.now.to_s}] #{message}"
  end
end

SMSSender.send(
  :number => ARGV[0], 
  :carrier => ARGV[1], 
  :message => ARGV[2]
)