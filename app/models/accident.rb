class Accident < ActiveRecord::Base
  attr_accessible :atmospherique, :codeinsee, :collision, :gravite,
                  :hospitalises, :indemnes, :intersection, :latitude,
                  :leger, :longitude, :lumiere, :numac, :route, :tues,
                  :ville, :vehicule_1, :vehicule_2, :vehicule_3, :vehicule_4,
                  :vehicule_5, :vehicule_6
end
