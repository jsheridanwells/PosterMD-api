require 'rails_helper'

RSpec.describe Blog, type: :model do
  it { should have_many(:posts).dependent(:destroy) }
  it { should validate_presence_of(:title) }
end
