module MessagesHelper


def text_distance_data

	@node_rows = []
	@link_rows = []

	Message.all.each_with_index do |u1, i1|
		node_row = {:name => u1.twitter_name , :group => 1, :mentions => u1.mentions}
		@node_rows << node_row

		User.all.each_with_index do |u2, i2|
			e = Edge.where(source: u1.twitter_name, target: u2.twitter_name)

			if !e.blank?
				link_row = {:source => i1, :target => i2, :value => e.first.social_distance*10}
				@link_rows << link_row
			end
		end
	end

	@data = { :nodes => @node_rows, :links => @link_rows }
end


end
