class Group < ApplicationRecord
  belongs_to :leader, class_name: 'User'

  validates :leader, :restaurant, :date, presence: true
end
