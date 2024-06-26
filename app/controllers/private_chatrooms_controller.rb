class PrivateChatroomsController < ApplicationController

  def index
    @private_chatrooms = current_user.all_private_chats
    policy_scope @private_chatrooms

    @active_chatrooms = current_user.active_instances(@private_chatrooms)
  end

  def show
    @private_chatroom = PrivateChatroom.find(params[:id])
    @message = Message.new
    authorize @private_chatroom
    @private_chatrooms = index
  end

  def create
    respond_to do |format|
      format.html {
        @sender = current_user
        @receiver = User.find(receiver_params[:receiver_id])
        name = "Chat for #{@sender.username} and #{@receiver.username}" # update to show profile image and name of receiver

        @chat = PrivateChatroom.new name:, sender: @sender, receiver: @receiver
        authorize @chat

        unless @chat.save
          @chat = PrivateChatroom.find_chatroom(
            user_one: @sender,
            user_two: @receiver
          )
          authorize @chat
          @chat.status = 'active'
          @chat.save
          redirect_to @chat
        end
      }

      format.json {
        @sender = current_user
        @receiver = User.find(receiver_params[:receiver_id])

        name = "Chat for #{@sender.username} and #{@receiver.username}" # update to show profile image and name of receiver

        @chat = PrivateChatroom.new name:, sender: @sender, receiver: @receiver
        authorize @chat
        @chat.save

        # @from_json = true
        @message_button_html = render_to_string(
          partial: "pages/message_button",
          formats: :html,
          locals: {
            user: @receiver,
            chat_type: 'link',
            chat_message: "Chat request sent",
            chat_flag: 'disabled'
          }
        )
      }
    end
  end

  def update
    @private_chatroom = PrivateChatroom.find(params[:id])

    if params[:private_chatroom][:status] == 'active'
      @private_chatroom.status = 1
    elsif params[:private_chatroom][:status] == 'archived'
      @private_chatroom.status = 2
    else
      @private_chatroom.status
    end

    authorize @private_chatroom

    @private_chatroom.update(private_chatroom_params)
    redirect_to profile_path
  end

  private

  def receiver_params
    params.permit(:receiver_id)
  end

  def private_chatroom_params
    params.require(:private_chatroom).permit(:status)
  end
end
