class Detail < ActiveRecord::Base
  attr_accessible :hospitalises, :indemnes, :legers, :misecirc, :numac, :tues, :vehicule

  def as_json(options={})
    result = super({ :except => [:created_at, :updated_at, :id] }.merge(options))
    result
  end
end
