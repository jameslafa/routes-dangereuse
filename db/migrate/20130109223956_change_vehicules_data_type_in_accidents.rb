class ChangeVehiculesDataTypeInAccidents < ActiveRecord::Migration
  def up
    change_column :accidents, :vehicule_1, :integer
    change_column :accidents, :vehicule_2, :integer
    change_column :accidents, :vehicule_3, :integer
    change_column :accidents, :vehicule_4, :integer
    change_column :accidents, :vehicule_5, :integer
    change_column :accidents, :vehicule_6, :integer
  end

  def down
    change_column :accidents, :vehicule_1, :boolean
    change_column :accidents, :vehicule_2, :boolean
    change_column :accidents, :vehicule_3, :boolean
    change_column :accidents, :vehicule_4, :boolean
    change_column :accidents, :vehicule_5, :boolean
    change_column :accidents, :vehicule_6, :boolean
  end
end
