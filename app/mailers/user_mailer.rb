class UserMailer < ApplicationMailer
  def login_mail(user)
    @user = user
    mail(to: user.email, subject: 'Login to CrowdDesk Lunch Roulette')
  end

  def lunch_confirmed_mail(lunch)
    @lunch = lunch
    mail(to: @lunch.user.email, subject: "Your lunch on #{@lunch.date} was confirmed!")
  end

  def reminder_mail(user)
    @user = user
    #check if user is not yet signed_up for next thursdays lunch
    unless user.lunches.last.date == Date.today.next_occurring(:thursday)
    #only then send mail
      mail(to: user.email, subject:"Sign up for tomorrows lunch roulette")
    end
  end
end
