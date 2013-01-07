class CreateRadars < ActiveRecord::Migration
  def change
    create_table :radars do |t|
      t.integer :type
      t.float :latitude, :precision=>10, :scale=>6
      t.float :longitude, :precision=>10, :scale=>6

      t.timestamps
    end
  end
end
