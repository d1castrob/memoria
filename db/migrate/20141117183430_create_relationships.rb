class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :expression_id
      t.integer :coocurrance_id
      t.integer :count, :default => 0

      t.timestamps
    end
  end
end
