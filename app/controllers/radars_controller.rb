class RadarsController < ApplicationController
  # GET /radars
  # GET /radars.json
  def index
    if params.has_key? :category
      @radars = Radar.where(:categorie => params[:category])
    else
      @radars = []
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
