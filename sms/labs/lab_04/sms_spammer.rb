# Gmail
# ====================================================================================================
# sudo gem install ambethia-smtp-tls -v '1.1.2' --source http://gems.github.com
# sudo gem install sms-fu
# ActionMailer::Base.delivery_method = :smtp
# ActionMailer::Base.smtp_settings = {
#    :address => "smtp.gmail.com",
#    :port => 587,
#    :domain => "gmail.com",
#    :authentication => :plain,
#    :user_name => "username",  # don't put "@gmail.com"
#    :password => "password",
#    :enable_starttls_auto => true }
   
# Sendmail
# ====================================================================================================
# Be sure to start the postfix daemon
# sudo launchctl start org.postfix.master
# tail -n 200 -f /var/log/mail.log
# ActionMailer::Base.delivery_method = :sendmail

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

class SMSSpammer
  def self.start
    new.prompt
  end
  
  def deliver(number, carrier, message, count = 1)
    begin
      count.times do 
        SMSFu.deliver(number,carrier,message)
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

SMSSpammer.start