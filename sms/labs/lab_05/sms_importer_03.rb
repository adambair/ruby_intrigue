# Importer used to receive SMS/MMS via e-mail

require 'rubygems'
require 'net/imap'

class SMSImporter
  def initialize(options = {})
    @server   = "imap.gmail.com"
    @username = "email@domain.com" # Full e-mail needed
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
      log("We've got mail")
    end
  end
  
  def log(message)
    puts "#{Time.now.to_s}: #{message}"
  end
end

if __FILE__ == $0
  SMSImporter.start
end