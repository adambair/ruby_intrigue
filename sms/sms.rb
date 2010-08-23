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

class SMSServer
  def self.send(options = {})
    new(options)
  end
  
  def initialize(options = {})
    1.times do  # You can really spam somebody here *hint*
      deliver(options[:number], options[:carrier], options[:message])
    end
  end
  
  def deliver(number, carrier, message)
    begin
      SMSFu.deliver_sms(number,carrier,message)
      log("Delivered \"#{message}\" to #{SMSFu.get_sms_address(number,carrier)}")
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

SMSServer.send(
  :number => ARGV[0], 
  :carrier => ARGV[1], 
  :message => ARGV[2]
)