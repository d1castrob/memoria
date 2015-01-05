module MessagesHelper



def calculate_text_distance_data
    ActiveRecord::Base.logger = nil

	@node_rows = []
	@link_rows = []

	Message.all.each_with_index do |u1, i1|
		node_row = {:name => u1.text , :group => 1, :mentions => u1.repetitions + u1.comments + u1.likes}
		@node_rows << node_row
		
		#esta iteracion burda funciona xq no hay ejes de sobra.
		Message.all.each_with_index do |u2, i2|

			if i1 > i2

				e = u1.edges.find_by(target_id: u2.id)

				if !e.blank?
					link_row = {:source => i1, :target => i2, :value => e.text_distance}
					@link_rows << link_row
				end

			end

		end

		puts i1
	end

	@data = { :nodes => @node_rows, :links => @link_rows }

end


def time_distance_data
	@node_rows = []
	@link_rows = []

	Message.all.each_with_index do |u1, i1|
		node_row = {:name => u1.text , :group => 1, :mentions => 5 + Math.sqrt(u1.repetitions + u1.comments + u1.likes)}
		@node_rows << node_row
		
		#esta iteracion burda funciona xq no hay ejes de sobra.
		Message.all.each_with_index do |u2, i2|
			e = Edge.where(source: u1.id_at_site, target: u2.id_at_site)

			if !e.blank?
				link_row = {:source => i1, :target => i2, :value => e.first.time_distance}
				@link_rows << link_row
			end
		end
	end

	@data = { :nodes => @node_rows, :links => @link_rows }
end

def geo_distance_data
	# @node_rows = []
	# @link_rows = []

	# Message.all.each_with_index do |u1, i1|
	# 	node_row = {:name => u1.text , :group => 1, :mentions => 5 + Math.sqrt(u1.repetitions + u1.comments + u1.likes)}
	# 	@node_rows << node_row
		
	# 	#esta iteracion burda funciona xq no hay ejes de sobra.
	# 	Message.all.each_with_index do |u2, i2|
	# 		e = Edge.where(source: u1.id_at_site, target: u2.id_at_site)

	# 		if !e.blank?
	# 			link_row = {:source => i1, :target => i2, :value => e.first.text_distance}
	# 			@link_rows << link_row
	# 		end
	# 	end
	# end

	# @data = { :nodes => @node_rows, :links => @link_rows }
end


end
