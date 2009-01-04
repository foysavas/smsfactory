# SMSFactory

Send SMS via email using Ruby and MailFactory.

As simple as possible because that's what was needed. Carrier list and email generation method taken from Justin Smestad's merb-slice-sms:

http://github.com/jsmestad/merb-slice-sms

## Creating the Message

    sms = SmsFactory.new
    sms.provider = 'tmobile'
    sms.number = '6175553561'
    sms.message = 'y0'
 
    # or alternatively
 
    sms = SmsFactory.new(:provider => 'tmobile', :number => '6175551234', :message => 'y0')
 
## Sending it with sendmail

    sendmail = IO.popen("/usr/sbin/sendmail #{sms.to}", 'w+')
    sendmail.puts sms.to_s
    sendmail.close
 
## Sending with Merb Mailer
 
    m = Merb::Mailer.new
    m.mail = sms
    m.deliver!
 
