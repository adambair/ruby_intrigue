# Show all the carriers within sms_fu and how addresses are formatted

require 'rubygems'
require 'sms_fu'

SMSFu.carriers.each do |carrier|
  puts "\n#{carrier[1]['name']} [#{carrier[0]}]"
  puts SMSFu.sms_address("123-456-7890", carrier[0])
end

puts "\n#{SMSFu.carriers.count} carriers"