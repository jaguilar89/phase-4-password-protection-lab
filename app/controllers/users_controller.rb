class UsersController < ApplicationController
  before_action :authorize, only: [:show]

  def create
    user = User.create(user_params)
    if user.valid?
      session[:user_id] = user.id
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    user = User.find_by(id: session[:user_id]) #will find a user by matching the users id with the user_id session key, if user_id is not found, user is not logged in.
    render json: user, status: :ok
  end

  private

  def authorize
    unless session.include?(:user_id)
      render json: { error: "Not authorized" }, status: :unauthorized
    end
  end

  def user_params
    params.permit(:username, :password, :password_confirmation)
  end
end
