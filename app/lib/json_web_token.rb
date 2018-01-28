class JsonWebToken
  HMAC_SECRET = Rails.application.secrets.secret_key_base

  # create json web token
  def self.encode(payload, exp = 24.hours.from_now)
    # set expiration
    payload[:exp] = exp.to_i
    #encode with payload and app secret
    JWT.encode(payload, HMAC_SECRET)
  end

  # check if submitted token is valid
  def self.decode(token)
    # payload is first item returned from JWT.decode, create hash with return
    body = JWT.decode(token, HMAC_SECRET)[0]
    HashWithIndifferentAccess.new body
  # handle decode error w/ custom exception
  rescue JWT::DecodeError => e
    raise ExceptionHandler::InvalidToken, e.message
  end
end