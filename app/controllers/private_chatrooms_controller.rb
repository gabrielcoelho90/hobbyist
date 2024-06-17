class PrivateChatroomsController < ApplicationController
  before_action :authenticate_user!

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

    redirect_to @chat
  end

  private

  def receiver_params
    params.permit(:receiver_id)
  end
end
