class GroupchatChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    groupchat = Groupchat.find(params[:id])
    stream_for groupchat
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
