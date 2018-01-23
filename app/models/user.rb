class User < ApplicationRecord
  validates_presence_of :first_name, :last_name, :email, :password_digest
  has_secure_password
  has_many :blogs, foreign_key: :user_id
end
