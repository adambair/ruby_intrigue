# sudo gem install tmail
# sudo gem install mms2r
# sudo gem install eventmachine

require 'rubygems'
require 'net/imap'
require 'tmail'
require 'mms2r'
require 'eventmachine'

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
        setup_imap(@server, @port, @username, @password, @folder, @ssl) 
      }
    end
  end
  
  def setup_imap(server, port, username, password, folder, ssl)
    imap = Net::IMAP::new(server, port, ssl)
    imap.login(username, password)
    imap.select(folder)
    mail_items = imap.search(["NOT", "SEEN"])
  end
  
  def log(message)
    puts "#{Time.now.to_s}: #{message}"
  end
end

command = ARGV[0] || 'start'
SMSImporter.send(command.to_sym)