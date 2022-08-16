class CreateHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :histories do |t|
      t.references :region, foreign_key: true
      t.date :date
      t.string :time
      t.timestamps
    end
  end
end
