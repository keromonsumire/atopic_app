class CreateItches < ActiveRecord::Migration[6.1]
  def change
    create_table :itches do |t|
      t.references :region, foreign_key: true
      t.date :date
      t.timestamps
    end
  end
end
