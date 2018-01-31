class User < ApplicationRecord
  has_secure_password

  has_many :blogs, foreign_key: :user_id

  validates :first_name, :last_name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX }
  
  validates :password, presence: true, length: { minimum: 6 }
            


end
