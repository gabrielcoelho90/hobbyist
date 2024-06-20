class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
  end

  def profile
    respond_to do |format|
      format.html {
        @user = current_user
        @user_subcommunities = current_user.subcommunities

        # Get Private Chats
        user_private_chats

        # Get Friendships
        user_friendships
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
    friendship_exist?
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
        info_window_html: render_to_string(partial: "pages/info_window", formats: :html, locals: { user: }),
        user_marker_html: render_to_string(partial: "pages/user_marker", formats: :html)
      }
    end
  end

  def friendship_exist?
    @my_friends = []
    @receivers = User.all.reject { |element| element == current_user }
    @friendship = Friendship.new
    @friendship.asker = current_user
    @receivers.each do |receiver|
      @my_friends << receiver.id if Friendship.where(asker_id: current_user.id, receiver_id: receiver.id).any?
    end
  end

  def user_private_chats
    @private_chats = current_user.all_private_chats
    @active_private_chats = current_user.active_instances(@private_chats)

    @pending_private_chats_sender = current_user.pending_requests_sender(@private_chats)
    @pending_private_chats_receiver = current_user.pending_requests_receiver(@private_chats)
  end

  def user_friendships
    @friendships = current_user.all_friendships
    @active_friendships = current_user.active_instances(@friendships)
    @number_of_friends = @active_friendships.count

    @pending_friendships_sender = current_user.pending_requests_sender(@friendships)
    @pending_friendships_receiver = current_user.pending_requests_receiver(@friendships)
  end
end
