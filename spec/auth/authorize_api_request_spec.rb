require 'rails_helper'

RSpec.describe AuthorizeApiRequest do
  # create test user with mock header, valid request, invalid request headers
  let(:user) { create(:user) }
  let(:header) { { 'Authorization' => token_generator(user.id) } }
  subject(:invalid_request_obj) { described_class.new({}) }
  subject(:request_obj) { described_class.new(header) }

  describe '#call' do
    context 'when the request is valid' do
      it 'returns the user object' do
        result = request_obj.call
        expect(result[:user]).to eq(user)
      end
    end

    context 'when the request is not valid' do
      context 'when token is missing' do
        subject(:invalid_request_obj) do
          described_class.new('Authorization' => token_generator(0))
        end
        it 'raises an InvalidToken error' do
          expect { invalid_request_obj.call }
            .to raise_error(ExceptionHandler::InvalidToken, /Invalid token/)
        end
      end

      context 'when token is expired' do
        let(:header) { { 'Authorization' => expired_token_generator(user.id)} }
        subject(:request_obj) { described_class.new(header) }

        it 'raises ExpiredSignature error' do
          expect { request_obj.call }
            .to raise_error(ExceptionHandler::InvalidToken, /Signature has expired/)
        end
      end

      context 'when token has been faked' do
        let(:header) { { 'Authorization' => 'fakedToken' } }
        subject(:invalid_request_obj) { described_class.new(header) }

        it 'raises JWT::DecodeError' do
          expect { invalid_request_obj.call }
            .to raise_error(ExceptionHandler::InvalidToken, /Not enough or too many segments/)
        end
      end
    end
  end
end