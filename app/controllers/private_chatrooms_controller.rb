class PrivateChatroomsController < ApplicationController

  def index
    @private_chatrooms = PrivateChatroom.where(sender: current_user).or(PrivateChatroom.where(receiver: current_user))
    policy_scope @private_chatrooms
  end

  def show
    @private_chatroom = PrivateChatroom.find(params[:id])
    @message = Message.new
    authorize @private_chatroom
    @private_chatrooms = PrivateChatroom.where(sender: current_user).or(PrivateChatroom.where(receiver: current_user))
  end

  def create
    @sender = current_user
    @receiver = User.find(receiver_params[:receiver_id])
    name = "Chat for #{@sender.username} and #{@receiver.username}" # update to show profile image and name of receiver

    @chat = PrivateChatroom.new name:, sender: @sender, receiver: @receiver
    @chat = PrivateChatroom.find_by(sender: @sender, receiver: @receiver) unless @chat.save
    authorize @chat
    # redirect_to @chat
  end

  def update
    @private_chatroom = PrivateChatroom.find(params[:id])

    if params[:private_chatroom][:status] == 'active'
      @private_chatroom.status = 1
    elsif params[:private_chatroom][:status] == 'archived'
      @private_chatroom.status = 2
    else
      @private_chatroom.status
    end

    authorize @private_chatroom

    @private_chatroom.update(private_chatroom_params)
    redirect_to profile_path
  end

  private

  def receiver_params
    params.permit(:receiver_id)
  end

  def private_chatroom_params
    params.require(:private_chatroom).permit(:status)
  end
end
