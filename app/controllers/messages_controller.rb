class MessagesController < ApplicationController
  def create
    if params[:private_chatroom_id]
      @chatroom = PrivateChatroom.find(params[:private_chatroom_id])
    else
      @chatroom = Groupchat.find(params[:groupchat_id])
    end
    @message = Message.new(message_params)
    @message.messageable = @chatroom
    @message.user = current_user
    authorize @message
    if @message.save
      message_data = {
        id: @message.id,
        content: @message.content,
        created_at: @message.created_at.strftime("%a %b %e at %l:%M %p"),
        username: @message.user.username,
        user_id: @message.user.id
      }
      if params[:private_chatroom_id]
        PrivateChatroomChannel.broadcast_to(
          @chatroom,
          message_data
        )
      else
        GroupchatChannel.broadcast_to(
          @chatroom,
          message_data
        )
      end
      head :ok
    else
      render "private_chatrooms/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
