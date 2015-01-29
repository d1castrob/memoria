class CreateJoinTableExpressionsMessages < ActiveRecord::Migration
  def change
    create_join_table :expressions, :messages do |t|
      # t.index [:expression_id, :message_id]
      # t.index [:message_id, :expression_id]
    end
  end
end
