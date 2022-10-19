class AddMetaToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :meta, :string
  end
end
