class GroupchatsController < ApplicationController
  def index
    @group_chats_arr = current_user.all_interestables.map do |interestable|
      interestable.groupchat
    end
    @all_groupchats = policy_scope(Groupchat) # <--- DO NOT TOUCH THIS LINE!
  end

  def show
    @groupchat = Groupchat.find(params[:id])
    @message = Message.new
    authorize @groupchat
    @groupchats = current_user.all_interestables.map do |interestable|
      interestable.groupchat
    end
  end
end
