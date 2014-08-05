class AddCityToEdges < ActiveRecord::Migration
  def change
  	add_column :edges, :city, :string
  end
end
