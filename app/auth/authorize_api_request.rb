class AuthorizeApiRequest
  def intialize(headers = {})
    @headers = headers
  end

  # on call, return valid user object
  def call
    {
      user: user
    }
  end

  private 
    attr_reader :headers

    # create the user or find the user with auth token
    def user
      @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
    rescue
      # raise custom error
      raise(
        ExceptionHandler::InvalidToken,
        ("#{Message.invalid_token} #{e.message}")
      )
    end

    def decoded_auth_token
      @decoded_auth_token ||= JsonWebToken.decode(http_auth_headers)
    end

    def http_auth_headers
      if !headers['Authorization'].nil?
        return headers['Authorization'].split(' ').last
      end
        raise(ExceptionHandler::MissingToken, Message.missing_token)
    end
end