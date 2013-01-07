class CreateAccidents < ActiveRecord::Migration
  def change
    create_table :accidents do |t|
      t.integer :numac
      t.string :codeinsee
      t.string :ville
      t.integer :lumiere
      t.integer :intersection
      t.integer :atmospherique
      t.integer :collision
      t.integer :route
      t.integer :tues
      t.integer :hospitalises
      t.integer :leger
      t.integer :indemnes
      t.decimal :gravite, :precision=>5, :scale=>2
      t.float :latitude, :precision=>10, :scale=>6
      t.float :longitude, :precision=>10, :scale=>6

      t.timestamps
    end
  end
end
