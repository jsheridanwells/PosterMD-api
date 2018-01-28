require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  let!(:user) { create(:user) }
  let(:headers) { valid_headers.except('Authorization') }
  let(:valid_credentials) { { email: user.email, password: user.password }.to_json }
  let(:invalid_credentials) { { email: Faker::Internet.email, password: Faker::Internet.password }.to_json }

  context 'when request is valid' do
    before { post '/auth/login', params: valid_credentials, headers: headers }
    it 'returns an auth token' do
      expect(json['auth_token']).not_to be_nil
    end
  end

  context 'when request is not valid' do
    before { post '/auth/login', params: invalid_credentials, headers: headers }
    it 'returns an InvalidCredentials error message' do
      expect(json['message']).to match(/Invalid credentials/)
    end
  end

end