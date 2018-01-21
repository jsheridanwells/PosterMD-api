require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should belong_to(:blog) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:content) }
end
