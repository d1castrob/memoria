class CreateEdges < ActiveRecord::Migration
  def change
    create_table :edges do |t|
      t.integer :message_id
      t.integer :target_id
      t.string :location
      t.float :social_distance
      t.float :text_distance
      t.float :time_distance
      t.string :city

      t.timestamps
    end
  end
end
