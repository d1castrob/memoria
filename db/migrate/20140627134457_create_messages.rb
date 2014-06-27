class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :from
      t.string :id_at_site
      t.string :text
      t.datetime :time
      t.string :location
      t.string :media
      t.integer :comments
      t.integer :likes

      t.timestamps
    end
  end
end
