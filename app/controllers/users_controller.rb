class UsersController < ApplicationController
  def show
    raise
  end

  def update
    authorize current_user
    current_user.photo.attach(photo_params[:photo]) if photo_params[:photo].present?
    current_user.update(user_params)
    redirect_to profile_path
  end

  private

  def photo_params
    params.require(:user).permit(:photo)
  end

  def user_params
    params.require(:user).permit(:description)
  end
end
