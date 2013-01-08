class RenameColumnTypeToCategorieInRadars < ActiveRecord::Migration
  def up
    rename_column :radars, :type, :categorie
  end

  def down
    rename_column :radars, :categorie, :type
  end
end
