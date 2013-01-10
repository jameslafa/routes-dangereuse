class ChangeVehiculesDataTypeInAccidents < ActiveRecord::Migration
  class << self
    include AlterColumn
  end

  def up
    alter_column :accidents, :vehicule_1, :integer, { true => 1, "else" => nil }, true
    alter_column :accidents, :vehicule_2, :integer, { true => 1, "else" => nil }, true
    alter_column :accidents, :vehicule_3, :integer, { true => 1, "else" => nil }, true
    alter_column :accidents, :vehicule_4, :integer, { true => 1, "else" => nil }, true
    alter_column :accidents, :vehicule_5, :integer, { true => 1, "else" => nil }, true
    alter_column :accidents, :vehicule_6, :integer, { true => 1, "else" => nil }, true
  end

  def down
    raise ActiveRecord::IrreversibleMigration.new
  end
end
