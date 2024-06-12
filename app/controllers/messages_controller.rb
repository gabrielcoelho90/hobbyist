class MessagesController < ApplicationController
  def create
    if params[:private_chatroom_id]
      @chatroom = PrivateChatroom.find(params[:private_chatroom_id])
    else
      @chatroom = Groupchat.find(params[:groupchat_id])
    end
    @message = Message.new(message_params)
    @message.messageable = @chatroom
    # @message.messageable_id = @privateChatroom.id
    @message.user = current_user
    # raise
    authorize @message
    if @message.save
      if params[:private_chatroom_id]
        PrivateChatroomChannel.broadcast_to(
          @chatroom,
          render_to_string(partial: "message", locals: { message: @message })
        )
      else
        GroupchatChannel.broadcast_to(
          @chatroom,
          render_to_string(partial: "message", locals: { message: @message })
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
