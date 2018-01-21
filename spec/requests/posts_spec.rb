require 'rails_helper'

RSpec.describe 'Posts API', type: :request do
  let!(:blog) { create(:blog) } 
  let!(:posts) { create_list(:post), 20, blog_id: blog.id }
  let(:blog_id) { blog.id }
  let(:post_id) { posts.first.id }

  # GET '/todos/:todo_id/
end