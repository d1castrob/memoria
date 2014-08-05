class AddTimeToMessages < ActiveRecord::Migration
  def change
  	remove_column :messages, :time
  	add_column :messages, :time, :integer
  end
end
