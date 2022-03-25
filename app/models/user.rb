class User < ApplicationRecord
  has_many :groups, foreign_key: 'leader'
  has_many :lunches

  validates :email, presence: true, reduce: true, format: {
    with: /\A\S+@portagon\.com\z/,
    message: 'is not a valid portagon email address'
  }

  def name
    email.split('@').first.capitalize
  end

  def send_reminder
    return unless Time.now.tuesday?
    return if lunches.on(Date.today.next_occurring(:friday)).any?

    UserMailer.reminder_mail(self).deliver_later
  end
end
