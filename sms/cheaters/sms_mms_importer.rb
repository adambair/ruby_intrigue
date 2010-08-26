# sudo gem install tmail
# sudo gem install mms2r
# sudo gem install eventmachine

require 'rubygems'
require 'net/imap'
require 'tmail'
require 'mms2r'
require 'eventmachine'

class SMSImporter
  def initialize
    @server   = "imap.gmail.com"
    @username = "username@gmail.com" # Full e-mail needed
    @password = "password"
    @port     = 993
    @folder   = "INBOX"
    @ssl      = true
  end
  
  def self.start
    new.start
  end
  
  def start
    EM.run do 
      EM::add_periodic_timer(10) { 
        setup_imap
      }
    end
  end
  
  def setup_imap
    begin
      imap = Net::IMAP::new(@server, @port, @ssl)
      imap.login(@username, @password)
      imap.select(@folder)
      mail_items = imap.search(["NOT", "SEEN"])
      check_for_new_mail(mail_items, imap)
    rescue Net::IMAP::NoResponseError => e
      log("#{e.class} - Command sent to server could not be completed successfully: #{e.message}")
      log(e.backtrace.join("\n"))
    rescue Net::IMAP::ByeResponseError => e
      log("#{e.class} - Login issues or timed out due to inactivity: #{e.message}")
      log(e.backtrace.join("\n"))
    rescue Exception => e
      log("#{e.class}: #{e.message}")
      log(e.backtrace.join("\n"))
    ensure
      imap.logout rescue log("Logout has crashed")
    end
  end
  
  def check_for_new_mail(mail_items, imap) 
    if mail_items.empty?
      log("There are currently no e-mails to process.")
    else
      mail_items.each do |message_id|
        email = imap.fetch(message_id,'RFC822')[0].attr['RFC822']
        process_email(email, message_id, imap)
      end
    end
  end
  
  def process_email(email, message_id, imap)
    begin
      tmail = TMail::Mail.parse(email)
      mms = MMS2R.parse(email)

      if mms.body.downcase.include?("sms")
        log("Received [#{mms.body}] from [#{tmail.from}] with number [#{mms.number}]")
        imap.store(message_id, "+FLAGS", [:Deleted])
        log("Deleted...")
        imap.expunge
      else
        log("Ignoring from [#{tmail.from}]")
      end
    rescue Exception => e
      log("#{e.class}: #{e.message}")
      log(e.backtrace.join("\n"))
    end
  end
  
  def log(message)
    puts "#{Time.now.to_s}: #{message}"
  end
end

if __FILE__ == $0
  SMSImporter.start
end