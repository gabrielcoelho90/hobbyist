class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    authorize @user
    @number_of_friends = @user.all_friendships.count
    redirect_to profile_path if @user == current_user
  end

  def update
    # user_params
    description = user_params[:description]
    bio = user_params[:bio]
    current_user.description = description
    current_user.bio = bio
    authorize current_user

    current_user.photo.attach(photo_params[:photo]) if photo_params[:photo].present?

    current_user.save
    redirect_to profile_path
  end

  private

  def photo_params
    params.require(:user).permit(:photo)
  end

  def user_params
    params.require(:user).permit(:description, :bio)
  end
end
