require 'rails_helper'

RSpec.describe 'Blogs API', type: :request do
  let!(:user) { create(:user) }
  let!(:blogs) { create_list(:blog, 10, user_id: user.id) }
  let(:id) { blogs.first.id }
  let(:headers) { valid_headers }
  # GET /blogs
  describe 'GET /blogs' do
    before { get '/blogs', params: {}, headers: headers }
    it 'returns all the blogs' do
      expect(blogs.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # GET /blogs/:id
  describe 'GET /blogs/:id' do
    before { get "/blogs/#{id}", params: {}, headers: headers }
    context 'when the blog exists' do
      it 'returns the specified blog' do
        expect(json).to_not be_empty
        expect(json['title']).to eq(blogs.first.title)
      end
  
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the blog does not exist' do
      before { get "/blogs/#{0}", params: {}, headers: headers }
      it 'returns the status code 404' do
        expect(response).to have_http_status(404)
      end

       it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Blog/)
       end
    end
  end

  # POST /blogs
  describe 'POST /blogs' do
    let(:valid_post) { { title: 'New Blog', description: 'This is my new description' }.to_json }
    context 'when the request is valid' do
      before { post '/blogs',  params: valid_post, headers: headers }

      it 'creates the blog and returns it ' do
        expect(json['title']).to eq('New Blog')
      end

      it 'returns the status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is not valid' do
      before { post '/blogs', params: {}, headers: headers }
      it 'returns the status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.message).to match(/Unprocessable Entity/)
      end
    end
  end
  
  # PATCH /blogs/:id
  describe 'PATCH /blogs/:id' do
    let(:valid_update) { { title: 'New Title' }.to_json }
    context 'when the blog exists' do
      before { patch "/blogs/#{id}", params: valid_update, headers: headers }
      it 'returns the status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the updated blog' do
        expect(json['title']).to eq('New Title')
      end
    end

    context 'when the blog does not exist' do
      before { patch "/blogs/0", params: valid_update, headers: headers }
      it 'returns the status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  # DELETE /blgos/:id
  describe 'DELETE /blogs/:id' do
    context 'when the blog exists' do
      before { delete "/blogs/#{id}", params: {}, headers: headers }
      it 'returns the status code 204' do
        expect(response).to have_http_status(204)
      end
    end
    context 'when the blog does not exist' do
      before { delete '/blogs/0', params: {}, headers: headers }
      it 'returns the status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

end