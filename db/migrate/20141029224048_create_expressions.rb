class CreateExpressions < ActiveRecord::Migration
  def change
    create_table :expressions do |t|
      t.string :type
      t.string :count
      t.string :raw_text
      t.string :processed_text
    end
  end
end
