class AddTimeToRegions < ActiveRecord::Migration[6.1]
  def change
    add_column :regions, :last_morning, :date
    add_column :regions, :last_noon, :date
    add_column :regions, :last_night, :date
  end
end
