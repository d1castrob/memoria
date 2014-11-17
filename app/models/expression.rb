class Expression < ActiveRecord::Base
	has_and_belongs_to_many :messages

	has_many :relationships
	has_many :coocurrances, :through => :relationships
end