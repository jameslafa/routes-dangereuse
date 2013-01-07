class RadarsController < ApplicationController
  # GET /radars
  # GET /radars.json
  def index
    @radars = Radar.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @radars }
    end
  end

  # GET /radars/1
  # GET /radars/1.json
  def show
    @radar = Radar.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @radar }
    end
  end

  # GET /radars/new
  # GET /radars/new.json
  def new
    @radar = Radar.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @radar }
    end
  end

  # GET /radars/1/edit
  def edit
    @radar = Radar.find(params[:id])
  end

  # POST /radars
  # POST /radars.json
  def create
    @radar = Radar.new(params[:radar])

    respond_to do |format|
      if @radar.save
        format.html { redirect_to @radar, notice: 'Radar was successfully created.' }
        format.json { render json: @radar, status: :created, location: @radar }
      else
        format.html { render action: "new" }
        format.json { render json: @radar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /radars/1
  # PUT /radars/1.json
  def update
    @radar = Radar.find(params[:id])

    respond_to do |format|
      if @radar.update_attributes(params[:radar])
        format.html { redirect_to @radar, notice: 'Radar was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @radar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /radars/1
  # DELETE /radars/1.json
  def destroy
    @radar = Radar.find(params[:id])
    @radar.destroy

    respond_to do |format|
      format.html { redirect_to radars_url }
      format.json { head :no_content }
    end
  end
end
