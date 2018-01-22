require 'rails_helper'

RSpec.describe 'Posts API', type: :request do
  let!(:blog) { create(:blog) }
  let!(:posts) { create_list(:post, 20, blog_id: blog.id, publish_date: Date.today) }
  let(:blog_id) { blog.id }
  let(:id) { posts.first.id }

  # GET /blogs/:blog_id/posts
  describe 'GET /blogs/:blog_id/posts' do
    context 'the posts exist' do
      before { get "/blogs/#{blog_id}/posts" } 
      it 'returns the status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns 20 posts' do
        expect(json.size).to eq(20)
      end
    end

    context 'the posts do not exist' do
      before { get "/blogs/0/posts" }
      it 'returns the status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns the error message not found' do
        expect(response.message).to match(/Not Found/)
      end
    end
  end
  
  # GET /blogs/:blog_id/posts/:post_id
  describe 'GET /blogs/:blog_id/posts/:post_id' do
    context 'the post exists' do
      before { get "/blogs/#{blog_id}/posts/#{id}" }
      it 'returns the item' do
        expect(json['id']).to eq(id)
      end

      it 'returns the status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'the item does not exist' do
      before { get "/blogs/#{blog_id}/posts/0" }
      it 'returns the status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'it returns the error message not found' do
        expect(response.message).to match(/Not Found/)
      end
    end

  end
  
  # POST /blogs/:blog_id/posts
  describe 'POST /blogs/:blog_id/posts' do

    let(:valid_post) do
      {
        title: 'New Post Title',
        content: 'New Post Content',
        published: false,
        publish_date: Date.today
      }
    end

    context 'the post contents are valid' do
      context 'the blog exists' do
        before { post "/blogs/#{blog_id}/posts", params: valid_post }
        it 'returns the status 201' do
          expect(response).to have_http_status(201)
        end

        it 'creates and returns the item' do
          expect(json['title']).to eq('New Post Title')
        end
      end

      context 'the blog does not exist' do
        before { post "/blogs/0/posts", params: valid_post }
        it 'returns the status 404' do
          expect(response).to have_http_status(404)
        end
      end
    end

    context 'the post contents are not valid' do
      context 'the blog exists' do
        before { post "/blogs/#{blog_id}/posts", params: {} }
        it 'returns the message unprocessable entity' do
          expect(response.message).to match(/Unprocessable Entity/)
        end

        it 'returns the status code 422' do
          expect(response).to have_http_status(422)
        end
      end

      context 'the blog does not exists' do
        before { post "/blogs/0/posts", params: {} }
        it 'returns the status code 404' do
          expect(response).to have_http_status(404)
        end
      end
    end
  end
  
  # PATCH /blogs/:blog_id/posts/:post_id
  describe 'PATCH /blogs/:blog_id/posts/:post_id' do

    let(:valid_update) { { title: 'New Title' } }

    context 'the update content is valid' do
      before { patch "/blogs/#{blog_id}/posts/#{id}", params: valid_update }
      it 'updates and returns the content' do
        expect(json['title']).to eq('New Title')
      end

      it 'returns the status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'the post record does not exist' do
      before { patch "/blogs/0/posts/#{id}", params: valid_update }
      it 'returns the status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns the error message Not Found' do
        expect(response.message).to match(/Not Found/)
      end
    end
  end
  
  # DELETE /blogs/:blog_id/posts/:post_id
  describe 'DELETE /blogs/:blog_id/posts/:post_id' do
    context 'the post exists' do
      before { delete "/blogs/#{blog_id}/posts/#{id}" }
      it 'returns the status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'the post does not exist' do
      before { delete "/blogs/0/posts/#{id}" }
      it 'returns the status code 404' do
        expect(response).to have_http_status(404)
      end
      it 'returns the error message Not Found' do
        expect(response.message).to match(/Not Found/)
      end
    end
  end
  
end