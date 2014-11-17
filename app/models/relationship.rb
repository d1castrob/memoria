class Relationship < ActiveRecord::Base
	belongs_to :expression
	belongs_to :coocurrance, :class_name => "Expression"
end
