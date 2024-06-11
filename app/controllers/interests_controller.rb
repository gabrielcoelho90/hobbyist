class InterestsController < ApplicationController
  def new
    @interest = Interest.new
    @interest.user = current_user

    @communities = Community.all
  end

  def create
    respond_to do |format|
      format.json {
        @interests_arr = interest_params[:interestable_id]
        @interests_arr.shift

        @creation = ["Created interests for #{current_user.name}"]
        @interestable_id_array = @interests_arr

        @interests_arr.each do |interestable_id|
          @interestable_id_array << interestable_id
          subcommunity = Subcommunity.find(interestable_id)
          interest = Interest.new user: current_user
          interest.interestable = subcommunity

          if interest.save
            @creation << subcommunity.name
            redirect_to new_interest_path
          # else
          #   render :new, status: :unprocessable_entity
          end
        end
      }

      format.html {
        redirect_to new_interest_path
      }
    end
  end

  private

  def interest_params
    params.require(:interest).permit(interestable_id: [])
  end
end
