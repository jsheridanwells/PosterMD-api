require 'rails_helper'

RSpec.describe AuthenticateUser, type: :request do
  # create test user

  # create valid request subject

  # create invalid request subject

  describe '#call' do
    context 'when the credentials are valid' do
      it 'returns an auth token' do
        expect { valid_auth_object.call }
          .not_to be(nil)
      end
    end

    context 'when the credentials are not valid' do
      expect { invalid_auth_object }
        .to raise_error(
          ExceptionHandler::AuthenticationError,
          /Invalid credentials/
        )
    end
  end
end