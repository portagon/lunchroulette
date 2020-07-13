class Lunch < ApplicationRecord
  belongs_to :user
  belongs_to :group, optional: true

  validates :status, :date, presence: true
end
