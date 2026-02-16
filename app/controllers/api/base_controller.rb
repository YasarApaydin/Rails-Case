class Api::BaseController < ActionController::API
  before_action :authenticate_user_from_token!

  private

  def authenticate_user_from_token!
    header = request.headers['Authorization']
    token = header.split(' ').last if header.present?

    if token
      begin
        decoded = JWT.decode(token, Rails.application.secret_key_base, true, { algorithm: 'HS256' })
        user_id = decoded.first['user_id']
        @current_user = User.find(user_id)
      rescue JWT::DecodeError
        render json: { errors: ["Invalid token"] }, status: :unauthorized
      end
    else
      render json: { errors: ["Missing token"] }, status: :unauthorized
    end
  end
end
