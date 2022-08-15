class CreateRegions < ActiveRecord::Migration[6.1]
  def change
    create_table :regions do |t|
      t.string :name
      t.references :user, foreign_key: true
      t.integer :interval
      t.string :time
      t.date :start
      t.timestamps
    end
  end
end
