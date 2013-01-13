class DetailsController < ApplicationController
  # GET /details/1
  # GET /details/1.json
  def show
    @accident = Accident.where(:numac => params[:id]).first
    @vehicules = Detail.where(:numac => params[:id])

    @result = {
      :accident => @accident,
      :vehicules => @vehicules
    }

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @result.as_json(:detailed => true) }
    end
  end
end
