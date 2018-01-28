module ExceptionHandler
  extend ActiveSupport::Concern

  # add standard error subclasses
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end

  # define custom exception handlers
  included do
    rescue_from ActiveRecord::RecordInvalid, with: :return_422
    rescue_from ExceptionHandler::AuthenticationError, with: :return_unauthorized
    rescue_from ExceptionHandler::MissingToken, with: :return_422
    rescue_from ExceptionHandler::InvalidToken, with: :return_422
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end
  end

  private
    #returns json response with 422 message
    def return_422(e)
      json_response({ message: e.message }, :unprocessable_entity)
    end

    # returns json response with 401 message
    def return_unauthorized(e)
      json_response({ message: e.message }, :unauthorized)
    end
end