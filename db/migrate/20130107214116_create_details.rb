class CreateDetails < ActiveRecord::Migration
  def change
    create_table :details do |t|
      t.integer :numac
      t.integer :vehicule
      t.integer :misecirc
      t.integer :tues
      t.integer :hospitalises
      t.integer :legers
      t.integer :indemnes

      t.timestamps
    end
  end
end
