class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: { user: current_user.as_json(only: [:id, :email, :first_name, :last_name]) }
  end

  def update
    if current_user.update(user_params)
      render json: { user: current_user.as_json(only: [:id, :email, :first_name, :last_name]) }
    else
      render json: {
        errors: current_user.errors.map { |e| { field: e.attribute, message: e.message } }
      }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name)
  end
end
