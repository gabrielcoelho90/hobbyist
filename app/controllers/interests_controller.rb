class InterestsController < ApplicationController
  def new
    @interest = Interest.new
    @interest.user = current_user
  end
end
