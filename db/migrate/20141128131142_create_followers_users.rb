class CreateFollowersUsers < ActiveRecord::Migration
  def self.up
    create_table :followers_users, :id => false do |t|
        t.references :follower
        t.references :user
    end
    add_index :followers_users, [:follower_id, :user_id]
    add_index :followers_users, :user_id
  end

  def self.down
    drop_table :followers_users
  end
end