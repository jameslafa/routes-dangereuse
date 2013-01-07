class AddIndexesAccidentsDetails < ActiveRecord::Migration
  def up
    add_index :accidents, :numac, :name => "index_accidents_on_numac", :unique => true
    add_index :details, :numac, :name => "index_details_on_numac"
  end

  def down
    remove_index :accidents, :name => "index_accidents_on_numac"
    remove_index :details, :name => "index_details_on_numac"
  end
end
