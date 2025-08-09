class Api::AuthController < ApplicationController
  skip_before_action :verify_authenticity_token

  def login
    user = User.find_for_authentication(email: params[:email])
    if user&.valid_password?(params[:password])
      token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      render json: { user: user_payload(user), token: token }
    else
      render json: { errors: [{ field: 'base', message: 'Invalid credentials' }] }, status: :unauthorized
    end
  end

  def register
    user = User.new(user_params)
    if user.save
      token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      render json: { user: user_payload(user), token: token }, status: :created
    else
      render json: {
        errors: user.errors.map { |e| { field: e.attribute, message: e.message } }
      }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end

  def user_payload(user)
    user.as_json(only: [:id, :email, :first_name, :last_name])
  end
end
