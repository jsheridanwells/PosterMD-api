class User < ApplicationRecord
  has_secure_password

  has_many :blogs, foreign_key: :user_id

  validates_presence_of :first_name, :last_name, :email, :password_digest
end
