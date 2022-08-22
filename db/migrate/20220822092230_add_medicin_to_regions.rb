class AddMedicinToRegions < ActiveRecord::Migration[6.1]
  def change
    add_column :regions, :medicin, :string
  end
end
