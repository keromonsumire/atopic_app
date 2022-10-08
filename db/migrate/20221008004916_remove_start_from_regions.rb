class RemoveStartFromRegions < ActiveRecord::Migration[6.1]
  def change
    remove_column :regions, :start, :date
  end
end
