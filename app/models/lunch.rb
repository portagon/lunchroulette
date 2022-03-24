class Lunch < ApplicationRecord
  belongs_to :user
  belongs_to :group, optional: true

  validates :status, :date, presence: true
  validates :date, uniqueness: { scope: :user }

  scope :on, ->(date) { where(date: date) }

  def confirmed?
    status == 'confirmed'
  end

  def confirm!
    update(status: 'confirmed')
    UserMailer.lunch_confirmed_mail(self).deliver_later
  end

  def add_single_to_group
    update(status: 'confirmed')

    groups = Group.on(date)
    actual_sizes = groups.map { |group| group.lunches.count }
    update(group: groups[actual_sizes.index(actual_sizes.min)])
  end
end
