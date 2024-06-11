class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
  end

  def search
    @users = User.all

    @markers = @users.geocoded.map do |user|
      {
        lat: user.latitude,
        lng: user.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { user: })
      }
    end
  end
end
