class AuthorizeApiRequest
  def initialize(headers = {})
    @headers = headers
  end

  # when service called, returns valid user object from private :user method
  def call
    { user: user}
  end

  private
    attr_reader :headers

    # returns user object if found in db
    def user
      @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token

    rescue ActiveRecord::RecordNotFound => e
      raise(ExceptionHandler::InvalidToken, ("#{Message.invalid_token} #{e.message}"))
    end

    # returns suth token when called by :user
    def decoded_auth_token
      @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
    end

    # returns auth header if present, else raises exception
    def http_auth_header
      if headers['Authorization'].present?
        return headers['Authorization'].split(' ').last
      end
        raise(ExceptionHandler::MissingToken, Message.missing_token)
    end
end