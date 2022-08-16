class RemoveTimeFromRegions < ActiveRecord::Migration[6.1]
  def change
    remove_column :regions, :time, :string
  end
end
