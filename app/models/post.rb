class Post < ApplicationRecord
  belongs_to :blog
  validates_presence_of :title, :content

end
