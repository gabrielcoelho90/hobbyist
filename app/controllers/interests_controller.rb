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
          interest.save
          @creation << subcommunity.name

        end
      }

      format.html {
        @interests_arr = interest_params[:interestable_id].compact_blank

        if @interests_arr.empty?
          @interest = Interest.new
          @interest.user = current_user

          @communities = Community.all

          redirect_to new_interest_path, alert: 'Please select at least one interest!'
        else
          @interests_arr.each do |interestable_id|
            subcommunity = Subcommunity.find(interestable_id)
            interest = Interest.new user: current_user
            interest.interestable = subcommunity

            interest.save
          end
          @interest = Interest.new
          @interest.user = current_user

          @communities = Community.all

          render :new, status: :unprocessable_entity
          # redirect_to profile_path, notice: 'Interests succesfully saved!'
        end
      }
    end
  end

  private

  def interest_params
    params.require(:interest).permit(interestable_id: [])
  end
end
