require 'rails_helper'

RSpec.describe AuthorizeApiRequest do
  #create user
  let(:user) { create(:user) }
  # mock auth header
  let(:header) { { 'Authorization' => token_generator(user.id) } }
  # make invalid reuquest 
  subject(:invalid_request_object) { described_class.new({}) }
  # make valid request
  subject(:valid_request_object) { described_class.new(header) }

  describe '#call' do
    context 'when the request is valid' do
      it 'returns the user object' do
        result = valid_request_object.call
        expect(result[:user]).to eq(user)
      end
    end

    context 'when the request is not valid' do
      context 'when the token is missing' do
        it 'raises a Missing Token error' do
          expect { invalid_request_object.call }
            .to raise_error(ExceptionHandler::MissingToken, /Missing Token/)
        end
      end

      context 'when the token is invalid' do
        subject(:invalid_reuqest_object) do
          described_class.new('Authorization' => token_generator(0))
        end
        it 'raises an Invalid Token error' do
          expect { invalid_request_object.call }
            .to raise_error(ExceptionHandler::InvalidToken, /Invalid Token/)
        end
      end

      context 'when the token is expired' do
        let(:header) { { 'Authorization' => expired_token_generator(user.id) } }
        subject(:request_object) { described_class.new(header) }
        it 'raises an Expired Signature error' do
          expect { request_obj.call }
            .to raise_error(
              ExceptionHandler::InvalidToken,
              /Signature has expired/
            )
        end
      end

      context 'when the token is fake' do
        let(:header) { { 'Authorization' => 'faketoken' } }
        subject(:invalid_request_object) { described_class.call(header) }

        it 'raises a JWT::Decode error' do
          expect {invalid_request_object.call}
            .to raise_error(
              ExceptionHandler::InvalidToken,
              /Not enough or too many segments/
            )
        end
      end
    end
  end
end