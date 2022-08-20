class AddIsYesterdayToHistories < ActiveRecord::Migration[6.1]
  def change
    add_column :histories, :is_yesterday, :boolean, default: false, null: false
  end
end
