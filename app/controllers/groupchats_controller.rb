class GroupchatsController < ApplicationController
  def show
    @groupchat = Groupchat.find(params[:id])
    @message = Message.new
    authorize @groupchat
  end
end
