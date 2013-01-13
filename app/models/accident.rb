class Accident < ActiveRecord::Base
  attr_accessible :atmospherique, :codeinsee, :ville, :collision, :gravite,
                  :hospitalises, :indemnes, :intersection, :latitude,
                  :leger, :longitude, :lumiere, :numac, :route, :tues,
                  :ville, :vehicule_1, :vehicule_2, :vehicule_3, :vehicule_4,
                  :vehicule_5, :vehicule_6

  def as_json(options={})
    if not options[:detailed]
      result = super({ :only => [:numac, :latitude, :longitude, :gravite] }.merge(options))
    else
      result = super({ :except => [:created_at, :updated_at, :id] }.merge(options))
    end
    result[:gravite] = self.gravite.to_f
    result
  end
end
