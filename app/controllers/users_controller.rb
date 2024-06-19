class UsersController < ApplicationController
  def show
    raise
  end

  def update
    # user_params
    description = user_params[:description]
    current_user.description = description
    authorize current_user

    current_user.photo.attach(photo_params[:photo]) if photo_params[:photo].present?

    current_user.save
    redirect_to profile_path #, status: :see_other
  end

  private

  def photo_params
    params.require(:user).permit(:photo)
  end

  def user_params
    params.require(:user).permit(:description)
  end
end
