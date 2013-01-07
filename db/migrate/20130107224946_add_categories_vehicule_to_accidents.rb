class AddCategoriesVehiculeToAccidents < ActiveRecord::Migration
  def change
    add_column :accidents, :vehicule_1, :boolean
    add_column :accidents, :vehicule_2, :boolean
    add_column :accidents, :vehicule_3, :boolean
    add_column :accidents, :vehicule_4, :boolean
    add_column :accidents, :vehicule_5, :boolean
    add_column :accidents, :vehicule_6, :boolean

    add_index :accidents, :vehicule_1, :name => "index_details_on_vehicule_1"
    add_index :accidents, :vehicule_2, :name => "index_details_on_vehicule_2"
    add_index :accidents, :vehicule_3, :name => "index_details_on_vehicule_3"
    add_index :accidents, :vehicule_4, :name => "index_details_on_vehicule_4"
    add_index :accidents, :vehicule_5, :name => "index_details_on_vehicule_5"
    add_index :accidents, :vehicule_6, :name => "index_details_on_vehicule_6"
  end
end
