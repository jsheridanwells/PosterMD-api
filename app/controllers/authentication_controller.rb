class AuthenticationController < ApplicationController
  def authenticate
    auth_token = AuthenticateUser.new(
      authentication_params[:email], authentication_params[:password]
    ).call
    json_response(auth_token: auth_token)
  end

  private
    def authentication_params
      params.permit(:email, :password)
    end
end