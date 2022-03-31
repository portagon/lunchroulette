class User < ApplicationRecord
  has_many :groups, foreign_key: 'leader'
  has_many :lunches

  ALLOWED_MAILS = /\A\S+@portagon\.com\z/.freeze

  validates :email, presence: true, reduce: true, format: {
    with: ALLOWED_MAILS,
    message: 'is not a valid portagon email address'
  }

  def name
    email.split('@').first.capitalize
  end

  def send_reminder
    return unless email.match?(ALLOWED_MAILS)
    return unless Time.now.thursday?
    return if lunches.on(Date.today.next_occurring(:friday)).any?

    UserMailer.reminder_mail(self).deliver_later
  end
end
