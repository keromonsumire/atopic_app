class AddColumnToRegions < ActiveRecord::Migration[6.1]
  def change
    add_column :regions, :morning, :boolean, default: false, null: false
    add_column :regions, :noon, :boolean, default: false, null: false
    add_column :regions, :night, :boolean, default: false, null: false
  end
end
