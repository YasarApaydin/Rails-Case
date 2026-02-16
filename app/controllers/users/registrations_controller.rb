class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token, only: [:create]
  respond_to :json

  def create
    build_resource(sign_up_params)

    if resource.save
      token = generate_token(resource)

      render json: {
        success: true,
        message: "User created successfully",
        token: token
      }, status: :ok
    else
      # 🔥 KAYDETME YOK ama 200 dönüyor
      render json: {
        success: false,
        errors: resource.errors.full_messages
      }, status: :ok
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def generate_token(user)
    payload = { user_id: user.id, email: user.email }
    JWT.encode(payload, Rails.application.secret_key_base, "HS256")
  end
end
