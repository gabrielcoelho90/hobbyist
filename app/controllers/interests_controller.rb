class InterestsController < ApplicationController
  def new
    @interest = Interest.new
    authorize @interest
    @communities = Community.all
    authorize @communities
  end

  def create
    respond_to do |format|
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

            authorize interest
            interest.save
          end

          redirect_to profile_path, notice: 'Interests succesfully saved!'
        end
      }

      # format.json {
      #   @interests_arr = interest_params[:interestable_id]
      #   @interests_arr.shift

      #   @creation = ["Created interests for #{current_user.name}"]
      #   @interestable_id_array = @interests_arr

      #   @interests_arr.each do |interestable_id|
      #     @interestable_id_array << interestable_id
      #     subcommunity = Subcommunity.find(interestable_id)
      #     interest = Interest.new user: current_user
      #     interest.interestable = subcommunity
      #     authorize interest
      #     interest.save
      #     @creation << subcommunity.name

      #   end
      # }
    end
  end

  def destroy
    respond_to do |format|
      format.html {
        set_interest
        authorize @interest
        @interest.destroy
      }

      format.json {
        set_interest
        authorize @interest
        @interest.destroy
      }
    end
  end

  private

  def set_interest
    @interest = Interest.find(params[:id])
  end

  def interest_params
    params.require(:interest).permit(interestable_id: [])
  end
end
