class AddProactiveToRegions < ActiveRecord::Migration[6.1]
  def change
    add_column :regions, :is_proactive, :boolean, default: false, null: false
    add_column :regions, :proactive_start, :date
    add_column :regions, :proactive_interval, :integer
  end
end
