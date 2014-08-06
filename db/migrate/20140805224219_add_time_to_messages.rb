class AddTimeToMessages < ActiveRecord::Migration
  def change
  	remove_column :messages, :time, :datetime
  	add_column :messages, :tiempoenint, :integer
  end
end
