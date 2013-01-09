class Accident < ActiveRecord::Base
  attr_accessible :atmospherique, :codeinsee, :collision, :gravite,
                  :hospitalises, :indemnes, :intersection, :latitude,
                  :leger, :longitude, :lumiere, :numac, :route, :tues,
                  :ville, :vehicule_1, :vehicule_2, :vehicule_3, :vehicule_4,
                  :vehicule_5, :vehicule_6

  def as_json(options={})
    result = super({ :except => [:created_at, :updated_at, :id, :vehicule_1, :vehicule_2, :vehicule_3, :vehicule_4, :vehicule_5, :vehicule_6] }.merge(options))
    result
  end
end
