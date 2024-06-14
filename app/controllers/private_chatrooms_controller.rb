class PrivateChatroomsController < ApplicationController

  def index
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
    @chat = PrivateChatroom.find_by(sender: @sender, receiver: @receiver) unless @chat.save

    authorize @chat
    redirect_to @chat
  end

  private

  def receiver_params
    params.permit(:receiver_id)
  end
end
