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
    if user.email="bergmann@crowddesk.de" || user.email="liebholz@crowddesk.de"
      return mail(to: user.email, subject:"Sign up for tomorrows lunch roulette") unless user.lunches.on(Date.today.next_occurring(:thursday)).any?
    end
  end
end
