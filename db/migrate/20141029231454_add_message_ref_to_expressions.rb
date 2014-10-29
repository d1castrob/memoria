class AddMessageRefToExpressions < ActiveRecord::Migration
  def change
    add_reference :expressions, :message, index: true
  end
end
