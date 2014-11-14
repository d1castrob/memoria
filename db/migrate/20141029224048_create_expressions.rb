class CreateExpressions < ActiveRecord::Migration
  def change
    create_table :expressions do |t|
      t.string :symbol
      t.integer :count, :default => 0
      t.string :raw_text
      t.string :processed_text
    end
  end
end
