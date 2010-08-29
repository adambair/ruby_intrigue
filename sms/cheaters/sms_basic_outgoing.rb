require 'rubygems'
require 'sms_fu'

class SMSBasic
  PONY_CONFIG = { 
    :via => :smtp, 
    :via_options => {
      :address              => 'smtp.gmail.com',
      :port                 => '587',
      :user_name            => 'username',
      :password             => 'password',
      :authentication       => :plain, 
      :enable_starttls_auto => true,
      :domain               => "localhost.localdomain"
  }}

  def self.send(options = {})
    new(options)
  end
  
  def initialize(options = {})
    deliver(options[:number], options[:carrier], options[:message])
  end
  
  def deliver(number, carrier, message)
    begin
      sms_fu = SMSFu::Client.configure(:delivery => :pony, :pony_config => PONY_CONFIG)
      sms_fu.deliver(number,carrier,message)
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

if __FILE__ == $0
  SMSBasic.send(
    :number => ARGV[0], 
    :carrier => ARGV[1], 
    :message => ARGV[2]
  )  
end