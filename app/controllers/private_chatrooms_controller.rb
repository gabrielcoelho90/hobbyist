class PrivateChatroomsController < ApplicationController

  def index
    @private_chatrooms = policy_scope(PrivateChatroom)
  end

  def show
    @private_chatrooms = policy_scope(PrivateChatroom)

    @private_chatroom = PrivateChatroom.find(params[:id])
    @message = Message.new
    authorize @private_chatroom
  end
end
