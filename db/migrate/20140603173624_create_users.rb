class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :uid
      t.string :provider
      t.string :twitter_name
      t.boolean :info_available
      t.timestamps
    end
  end
end
