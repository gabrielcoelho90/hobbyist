class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
  end

  def profile
    @user_subcommunities = current_user.subcommunities
  end

  def search
    respond_to do |format|
      format.html {
        @blank_interest = Interest.new
        @communities = Community.all
        @users = User.all
        if params[:query].present?
          # @subcommunity = Subcommunity.find_by(name: params[:query])
          @array_of_interests = ["Tennis"]
          @array_of_interestables = []
          @array_of_interests.each do |array_of_interest|
            if Subcommunity.find_by(name: array_of_interest).nil?
              @community = Community.find_by(name: array_of_interest)
              @array_of_interestables << @community
            else
              @subcommunity = Subcommunity.find_by(name: array_of_interest)
              @array_of_interestables << @subcommunity
            end
          end
          @users = User.joins(:interests).where(interests: { interestable: @array_of_interestables })
        end
        @near_users = @users.near([current_user.latitude, current_user.longitude], 5)
        @markers = @users.geocoded.uniq.map do |user|
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
end
