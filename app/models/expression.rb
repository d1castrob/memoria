class Expression < ActiveRecord::Base
	has_one_and_belong_to_many :messages
end