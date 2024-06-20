class FriendshipsController < ApplicationController
  def new
  end

  def create
    @friendship = Friendship.new
    @friendship.asker = current_user
    @friendship.receiver = User.find(params[:receiver_id])
    @existed_friendship = Friendship.where(asker_id: current_user.id, receiver_id: params[:receiver_id]).any?
    @friendship.save unless @existed_friendship
    authorize @friendship
  end

  def update
    @friendship = Friendship.find(params[:id])
    if params[:friendship][:status] == 'active'
      @friendship.status = 1
    elsif params[:friendship][:status] == 'archived'
      @friendship.status = 2
    else
      @friendship.status
    end
    authorize @friendship

    @friendship.update(friendship_params)
    redirect_to profile_path
  end

  private

  def friendship_params
    params.require(:friendship).permit(:status)
  end
end
