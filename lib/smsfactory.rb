require 'mailfactory'

# Creating the Message
# ====================
#
#   sms = SmsFactory.new
#   sms.provider = 'tmobile'
#   sms.number = '6175553561'
#   sms.message = 'y0'
#
#   # or alternatively
#
#   sms = SmsFactory.new(:provider => 'tmobile', :number => '6175551234', :message => 'y0')
#
# Sending it with sendmail
# ========================
#   sendmail = IO.popen("/usr/sbin/sendmail #{sms.to}", 'w+')
#   sendmail.puts sms.to_s
#   sendmail.close
#
# Sending with Merb Mailer
# ========================
#
#   m = Merb::Mailer.new
#   m.mail = sms
#   m.deliver!
#
class SmsFactory < MailFactory

  attr_accessor :provider

  unless $CARRIERS
    require 'yaml'
    $CARRIERS = YAML::load_file("carriers.yml")['carriers']
  end

  def initialize(o={})
    super()
    @provider = o.delete(:provider)
    o.each { |k,v| self.send "#{k}=", v }
  end

  def number=(value)
    @number = value
    self.to = generate_email
  end

  def message=(value)
    @message = value
    self.html = value
  end

  def generate_email
    SmsFactory.generate_email(@number, @provider)
  end

  def self.generate_email(number, provider)
    if $CARRIERS.has_key?(provider.downcase)
      "#{number}#{$CARRIERS[provider.downcase]}"
    else
      raise SMSException.new("Provider, #{provider}, was not found.")
    end
  end

end
