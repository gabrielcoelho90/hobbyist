class PrivateChatroomChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    private_chatroom = PrivateChatroom.find(params[:id])
    stream_for private_chatroom
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
