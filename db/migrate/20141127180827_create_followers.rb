class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followers do |t|
      t.string :id_at_twitter

      t.timestamps
    end
  end
end
