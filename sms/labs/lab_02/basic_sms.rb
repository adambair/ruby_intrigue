# Deliver a basic SMS
# sudo gem install ambethia-smtp-tls -v '1.1.2' --source http://gems.github.com

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

number  = "123-456-7890"
carrier = "at&t"
message = "hello world"

SMSFu.deliver(number,carrier,message)