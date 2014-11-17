class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :expression_id
      t.integer :coocurrance_id
      t.integer :count

      t.timestamps
    end
  end
end
