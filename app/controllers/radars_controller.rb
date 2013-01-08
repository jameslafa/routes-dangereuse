class RadarsController < ApplicationController
  # GET /radars
  # GET /radars.json
  def index
    if params[:categorie] and ["1", "2", "3", "4"].include?(params[:categorie])
      @radars = Radar.where(:categorie => params[:categorie])
    else
      @radars = Radar.all
    end

    @result = {
      :count => @radars.size,
      :data => @radars
    }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @result }
    end
  end
end
