class AccidentsController < ApplicationController
  # GET /accidents
  # GET /accidents.json
  def index
    conditions = {}
    available_parameters = [:lumiere, :intersection, :atmospherique, :route, :collision, :tues]

    # Loop on every requestable parameters and add it to the request condition
    available_parameters.each do |param|
      conditions[param] = params[param] if params.has_key?(param)
    end

    # Add the tues condition

    # if params.has_key?(:tues)
    #   if params[:tues].include?("2")
    #     conditions[:tues] = 2..100
    #   else
    #     conditions[:tues] = params[:tues]
    #   end
    # end

    # Add the vehicule condition
    vehicule_condition = ""
    if params.has_key?(:vehicules)
      available_vehicule_types = [1..6]


      if params[:vehicules].kind_of?(Array)
        params[:vehicules].each do |vehicule_type|
          if !available_vehicule_types.include?(vehicule_type)
            vehicule_condition = vehicule_condition + " OR " if !vehicule_condition.empty?
            vehicule_condition = vehicule_condition + "vehicule_" + vehicule_type + " = 1"
          end
        end
      else
        vehicule_condition = "vehicule_" + params[:vehicules] + " = 1"
      end
    end

    # If parameter count is set to true, we just need to count the result
    if params[:count]
      if vehicule_condition.empty?
        count = Accident.where(conditions).count
      else
        count = Accident.where(conditions).where(vehicule_condition).count
      end

      @result = {
        :count => count
      }
    # Else, we need to return all the results to display them
    else
      if vehicule_condition.empty?
        @accidents = Accident.where(conditions)
      else
        @accidents = Accident.where(conditions).where(vehicule_condition)
      end

      @result = {
        :count => @accidents.size,
        :data => @accidents
      }
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @result }
    end
  end
end
