class Group < ApplicationRecord
  belongs_to :leader, class_name: 'User'
  has_many :lunches

  validates :leader, :restaurant, :date, presence: true
end
