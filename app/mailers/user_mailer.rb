class UserMailer < ApplicationMailer
  def login_mail(user)
    @user = user
    mail(to: user.email, subject: 'Login to CrowdDesk Coffee Break Roulette')
  end

  def lunch_confirmed_mail(lunch)
    @lunch = lunch
    mail(to: @lunch.user.email, subject: "Your coffee break on #{@lunch.date} was confirmed!")
  end

  def reminder_mail(user)
    @user = user
    mail(to: user.email, subject: 'Sign up for tomorrows coffee break roulette')
  end
end
