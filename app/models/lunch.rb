class Lunch < ApplicationRecord
  belongs_to :user
  belongs_to :group, optional: true

  validates :status, :date, presence: true
  validates :date, uniqueness: { scope: :user }

  scope :on, -> (date) { where(date: date) }

  def confirmed?
    status == 'confirmed'
  end
end
