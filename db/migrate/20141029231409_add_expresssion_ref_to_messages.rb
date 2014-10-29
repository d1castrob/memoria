class AddExpresssionRefToMessages < ActiveRecord::Migration
  def change
    add_reference :messages, :expression, index: true
  end
end
