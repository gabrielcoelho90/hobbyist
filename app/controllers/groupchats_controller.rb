class GroupchatsController < ApplicationController

  # def index
  #   @groupchats = Groupchat.where(current_user)
  #   raise
  #   policy_scope @groupchats
  # end

  def show
    @groupchat = Groupchat.find(params[:id])
    @message = Message.new
    authorize @groupchat
  end
end
