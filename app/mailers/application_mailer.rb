class ApplicationMailer < ActionMailer::Base
  default from: 'admin@crowddesk.de'
  layout 'mailer'

  def test
    mail(to: 'liebholz@crowddesk.de', subject: 'It works', body: 'Yeah it does dude!')
  end
end
