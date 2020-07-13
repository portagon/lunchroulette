class User < ApplicationRecord
  validates :email, presence: true, reduce: true, format: {
    with: /\A\S+@crowddesk\.de\z/,
    message: "is not a valid CrowdDesk email address"
  }
end
