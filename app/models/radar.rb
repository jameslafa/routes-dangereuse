class Radar < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :categorie

  def as_json(options={})
    result = super({ :except => [:created_at, :updated_at, :id] }.merge(options))
    result
  end
end
