class ChangeVehiculesDataTypeInAccidents < ActiveRecord::Migration
  def up
    execute "ALTER TABLE accidents ALTER COLUMN vehicule_1 TYPE integer
              USING CASE vehicule_1
              WHEN true THEN 1
              ELSE 0 END;"

    execute "ALTER TABLE accidents ALTER COLUMN vehicule_2 TYPE integer
              USING CASE vehicule_2
              WHEN true THEN 1
              ELSE 0 END;"

    execute "ALTER TABLE accidents ALTER COLUMN vehicule_3 TYPE integer
              USING CASE vehicule_3
              WHEN true THEN 1
              ELSE 0 END;"

    execute "ALTER TABLE accidents ALTER COLUMN vehicule_4 TYPE integer
              USING CASE vehicule_4
              WHEN true THEN 1
              ELSE 0 END;"

    execute "ALTER TABLE accidents ALTER COLUMN vehicule_5 TYPE integer
              USING CASE vehicule_5
              WHEN true THEN 1
              ELSE 0 END;"

    execute "ALTER TABLE accidents ALTER COLUMN vehicule_6 TYPE integer
              USING CASE vehicule_6
              WHEN true THEN 1
              ELSE 0 END;"
  end

  def down
    raise ActiveRecord::IrreversibleMigration.new
  end
end
