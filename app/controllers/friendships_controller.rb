class FriendshipsController < ApplicationController
  def new
  end

  def create
    # @friendship = Friendship.new
    # @friendship.asker = current_user
    # @friendship.receiver = User.find(params[:receiver_id])
    # @existed_friendship = Friendship.where(asker_id: current_user.id, receiver_id: params[:receiver_id]).any?
    # @friendship.save unless @existed_friendship
    # authorize @friendship

    respond_to do |format|
      format.html {
        @asker = current_user
        @receiver = User.find(receiver_params[:receiver_id])

        @friendship = Friendship.new asker: @asker, receiver: @receiver
        authorize @friendship

        unless @friendship.save
          @friendship = Friendship.find_chatroom(
            user_one: @asker,
            user_two: @receiver
          )
          authorize @friendship
          # @friendship.status = 'active'
          # @friendship.save
        end
      }

      format.json {
        @asker = current_user
        @receiver = User.find(receiver_params[:receiver_id])

        @friendship = Friendship.new asker: @asker, receiver: @receiver
        authorize @friendship
        @friendship.save

        # @from_json = true
        @friendship_button_html = render_to_string(
          partial: "pages/friendship_button",
          formats: :html,
          locals: {
            user: @receiver,
            friend_type: 'link',
            friend_message: "Friend request sent",
            friend_flag: 'disabled'
          }
        )
      }
    end
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

  def receiver_params
    params.permit(:receiver_id)
  end

  def friendship_params
    params.require(:friendship).permit(:status)
  end
end
