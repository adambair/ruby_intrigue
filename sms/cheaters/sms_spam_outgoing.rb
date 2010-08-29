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

  def self.start
    new.prompt
  end
  
  def initialize
    @sms_fu = SMSFu::Client.configure(:delivery => :pony, :pony_config => PONY_CONFIG) 
  end
  
  def deliver(number, carrier, message, count = 1)
    begin
      count.times do 
        @sms_fu.deliver(number,carrier,message)
        log("Delivered \"#{message}\" to #{SMSFu.sms_address(number,carrier)}")
      end
    rescue Errno::ECONNREFUSED => e
      log("Connection refused: " + e.message)
    rescue Exception => e
      log("Exception " + e.message)
    end
    puts "\n\n"
    prompt
  end
  
  def prompt  
    print "Phone Number: "
    number = gets.chomp
    print "Carrier (e.g, at&t): "
    carrier = gets.chomp
    print "Message: "
    message = gets.chomp
    print "Number of messages: "  # This could get dangeous
    count = gets.chomp.to_i
    puts "\n\n"
  
    deliver(number, carrier, message, count)
  end

  def log(message)
    puts "[#{Time.now.to_s}] #{message}"
  end
end

if __FILE__ == $0
  SMSBasic.start
end