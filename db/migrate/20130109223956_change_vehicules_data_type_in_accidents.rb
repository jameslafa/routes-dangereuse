class ChangeVehiculesDataTypeInAccidents < ActiveRecord::Migration
  class << self
    include AlterColumn
  end

  def up
    alter_column :accidents, :vehicule_1, :integer, :default=>nil
    alter_column :accidents, :vehicule_2, :integer, :default=>nil
    alter_column :accidents, :vehicule_3, :integer, :default=>nil
    alter_column :accidents, :vehicule_4, :integer, :default=>nil
    alter_column :accidents, :vehicule_5, :integer, :default=>nil
    alter_column :accidents, :vehicule_6, :integer, :default=>nil
  end

  def down
    raise ActiveRecord::IrreversibleMigration.new
  end
end
