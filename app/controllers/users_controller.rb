class UsersController < ApplicationController
  def show
    raise
  end

  def update
    current_user.photo.attach(photo_params[:photo])
    authorize current_user
    current_user.save
    redirect_to profile_path
  end

  private

  def photo_params
    params.require(:user).permit(:photo)
  end
end
