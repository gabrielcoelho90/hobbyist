class PrivateChatroomsController < ApplicationController

  def index
    @private_chatrooms = PrivateChatroom.where(sender: current_user).or(PrivateChatroom.where(receiver: current_user))
    policy_scope @private_chatrooms
  end

  def show
    @private_chatroom = PrivateChatroom.find(params[:id])
    @message = Message.new
    authorize @private_chatroom
  end

  def create
    @sender = current_user
    @receiver = User.find(receiver_params[:receiver_id])
    name = "Chat for #{@sender.username} and #{@receiver.username}"



    @chat = PrivateChatroom.new name:, sender: @sender, receiver: @receiver

    authorize @chat

    @chat = PrivateChatroom.find_by(sender: @sender, receiver: @receiver) unless @chat.save



    redirect_to @chat
  end

  private

  def receiver_params
    params.permit(:receiver_id)
  end
end
