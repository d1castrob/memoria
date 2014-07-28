class CreateEdges < ActiveRecord::Migration
  def change
    create_table :edges do |t|
      t.string :source
      t.string :target
      t.string :location
      t.float :social_distance
      t.float :text_distance
      t.float :time_distance

      t.timestamps
    end
  end
end
