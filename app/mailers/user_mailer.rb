class UserMailer < ApplicationMailer
  def login_mail(user)
    @user = user
    mail(to: user.email, subject: 'Login to CrowdDesk Lunch Roulette')
  end

  def lunch_confirmed_mail(lunch)
    @lunch = lunch
    mail(to: @lunch.user.email, subject: "Your lunch on #{@lunch.date} was confirmed!")
  end

  def send_kevin
    mail(to: 'liebholz@crowddesk.de', subject: 'from send_kevin', body: 'you got it man!')
  end
end
