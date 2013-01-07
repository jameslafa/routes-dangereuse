class AddIndexTypeToRadars < ActiveRecord::Migration
  def change
    add_index :radars, :type, :name => "index_radars_on_type"
  end
end
