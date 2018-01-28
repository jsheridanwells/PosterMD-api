module ControllerSpecHelper
  # generate tokens when given valid user id
  def token_generator(user_id)
    JsonWebToken.encode(user_id: user_id)
  end
  # generate expired tokens when given valid user id
  def expired_token_generator(user_id)
    JsonWebToken.encode({ user_id: user_id }, (Time.now.to_i - 10))
  end
  # return  valid header
  def valid_headers
    {
      "Authorization" => token_generator(user.id),
      "Content-Type" => "Application/json"
    }
  end
  # return invalid header
  def invalid_headers
    {
      "Authorization" => nil,
      "Content-Type" => "Application/json"
    }
  end
end