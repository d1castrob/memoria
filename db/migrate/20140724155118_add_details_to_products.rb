class AddDetailsToProducts < ActiveRecord::Migration
  def change
  	add_column :messages, :to, :string
  	add_column :messages, :text_distance, :float
  	add_column :messages, :user_distance, :float
  	add_column :messages, :site, :string
  end
end
