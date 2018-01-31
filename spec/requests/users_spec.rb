require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user) { build(:user) }
  let(:headers) { valid_headers.except('Authorization') }
  let(:valid_attributes) { attributes_for(:user, password_confirmation: user.password) }

  describe 'POST /signup' do
    context 'when the request is valid' do
      before { post '/signup', params: valid_attributes.to_json, headers: headers }
      it 'creates a new user' do
        expect(response).to have_http_status(201)
      end

      it 'returns a success message' do
        expect(json['message']).to match(/Account created successfully/)
      end

      it 'returns an auth token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    context 'when the params are not valid' do
      before { post '/signup', params: {}, headers: headers }
      it 'does not create a new user' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(json['message']).to match(/Validation failed/)
      end
    end

    context 'when user.first_name is longer than 50 characters' do
      let(:invalid_attributes) { attributes_for(:user, first_name: ('a' * 51)) }
      before { post '/signup', params: invalid_attributes.to_json, headers: headers }
      it 'does not create a new user' do
        expect(response).to have_http_status(422)
      end

      it 'returns an error message' do
        expect(json['message']).to match(/Validation failed/)
      end
    end

    context 'when user.last_name is longer than 50 characters' do
      let(:invalid_attributes) { attributes_for(:user, last_name: ('a' * 51)) }
      before { post '/signup', params: invalid_attributes.to_json, headers: headers }
      it 'does not create a new user' do
        expect(response).to have_http_status(422)
      end

      it 'returns an error message' do
        expect(json['message']).to match(/Validation failed/)
      end
    end

    context 'when email is not valid' do
      let(:invalid_attributes) { attributes_for(:user, email: 'example_example.com') }
      before { post '/signup', params: invalid_attributes.to_json, headers: headers }
      it 'does not create a new user' do
        expect(response).to have_http_status(422)
      end

      it 'returns an error message' do
        expect(json['message']).to match(/Validation failed/)
      end
    end

    context 'when email is not unique' do
      before { @user_2 = user }
      before { post '/signup', params: @user_2.to_json, headers: headers }
      
      it 'does not create a new user' do
        puts "user is:#{user.email}:::::#{@user_2.to_json}"
        expect(response).to have_http_status(422)
      end

      it 'returns an error message' do
        expect(json['message']).to match(/Validation failed/)
      end
    end

    context 'when email is more than 255 characters' do
      let(:invalid_attributes) { attributes_for(:user, email: "#{('a'*256)}@email.com") }
      before { post '/signup', params: invalid_attributes.to_json, headers: headers }
      it 'does not create a new user' do
        expect(response).to have_http_status(422)
      end

      it 'returns an error message' do
        expect(json['message']).to match(/Validation failed/)
      end
    end

    context 'when passwords do not match' do
      let(:invalid_attributes) do
        attributes_for(:user, password:'1234567', password_confirmation:'123456') 
      end

      before { post '/signup', params: invalid_attributes.to_json, headers: headers }
      it 'does not create a new user' do
        expect(response).to have_http_status(422)
      end

      it 'returns an error message' do
        expect(json['message']).to match(/Validation failed/)
      end
    end

    context 'when password is less than 6 charcters' do
      let(:invalid_attributes) { attributes_for(:user, password: '12345', password_confirmation: '12345') }
      before { post '/signup', params: invalid_attributes.to_json, headers: headers }
      it 'does not create a new user' do
        expect(response).to have_http_status(422)
      end

      it 'returns an error message' do
        expect(json['message']).to match(/Validation failed/)
      end
    end

  end
end