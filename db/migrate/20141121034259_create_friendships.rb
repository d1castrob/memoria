class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :user_id
      t.integer :friend_id
      t.float :weight, :default => 0

      t.timestamps
    end
  end
end
