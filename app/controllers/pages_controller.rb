class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
  end

  def search
    respond_to do |format|
      format.html {
        @users = User.all
        if params[:query].present?
          @subcommunity = Subcommunity.find_by(name: params[:query])
          @users = User.joins(:interests).where(interests: { interestable: @subcommunity })
        end
        @markers = @users.geocoded.map do |user|
          {
            lat: user.latitude,
            lng: user.longitude,
            info_window_html: render_to_string(partial: "info_window", locals: { user: })
          }
        end
      }

      format.json {
        @map_json = map_params
        @near_users = User.near([@map_json['lat'], @map_json['lng']], 5)
      }
    end
  end

  private

  def map_params
    params.permit(:lat, :lng)
  end

  def profile
    @user_subcommunities = current_user.subcommunities
  end
end
