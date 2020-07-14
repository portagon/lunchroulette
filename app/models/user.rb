class User < ApplicationRecord
  has_many :groups, foreign_key: 'leader'
  has_many :lunches

  validates :email, presence: true, reduce: true, format: {
    with: /\A\S+@crowddesk\.de\z/,
    message: "is not a valid CrowdDesk email address"
  }

  def name
    email.split('@').first.capitalize
  end
end
