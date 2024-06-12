class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
  end

  def profile
    @user_subcommunities = current_user.subcommunities
  end
end
