class PrivateChatroomsController < ApplicationController

  def index
  end

  def show
    @private_chatroom = PrivateChatroom.find(params[:id])
    @message = Message.new
    authorize @private_chatroom
  end
end
