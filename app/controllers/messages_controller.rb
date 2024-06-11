class MessagesController < ApplicationController
  def create
    @private_chatroom = PrivateChatroom.find(params[:private_chatroom_id])
    @message = Message.new(message_params)
    @message.messageable = @private_chatroom
    # @message.messageable_id = @privateChatroom.id
    @message.user = current_user
    # raise
    if @message.save
      PrivateChatroomChannel.broadcast_to(
        @private_chatroom,
        render_to_string(partial: "message", locals: {message: @message})
      )
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
