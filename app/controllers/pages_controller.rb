class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
  end

  def profile
    respond_to do |format|
      format.html {
        @user = current_user
        @user_subcommunities = current_user.subcommunities
      }

      format.json {
        @from_json = true
        @interest_pills_html = render_to_string(
          partial: "pages/profile_interests",
          formats: :html,
          locals: { from_json: @from_json }
        )
      }
    end
  end

  def search
    respond_to do |format|
      format.html {
        @form_interest = Interest.new
        @communities = Community.all

        filter_users
        create_markers
        @near_users = @near_users.uniq.reject { |user| user == current_user }
      }

      format.json {
        @map_json = map_params

        filter_users
        create_markers
        @near_users = @near_users.uniq.reject { |user| user == current_user }
      }
    end
  end

  private

  def map_params
    params.permit(:lat, :lng, :range)
  end

  def interest_params
    params.require(:interest).permit(interestable_id: [])
  end

  def filter_users
    @users = User.all
    filter_users_by_interests
    filter_users_by_distance
  end

  def filter_users_by_interests
    @interest_id_arr = interest_params[:interestable_id].compact_blank if params[:interest].present?

    unless @interest_id_arr.nil? || @interest_id_arr.empty?
      @array_of_interestables =  @interest_id_arr.map { |interest_id| Subcommunity.find(interest_id) }
      @users = User.joins(:interests).where(interests: { interestable: @array_of_interestables })
    end
  end

  def filter_users_by_distance
    if @map_json.nil?
      @near_users = @users.near([current_user.latitude, current_user.longitude], 5)
    else
      @near_users = @users.near([@map_json['lat'], @map_json['lng']], @map_json['range'])
    end
  end

  def create_markers
    @markers = @near_users.geocoded.uniq.map do |user|
      {
        lat: user.latitude,
        lng: user.longitude,
        info_window_html: render_to_string(partial: "pages/info_window", formats: :html, locals: { user: })
      }
    end
  end
end
