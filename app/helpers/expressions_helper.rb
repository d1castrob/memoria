module ExpressionsHelper

def semantic_graph_data

	@node_rows = []
	@link_rows = []

	Expression.all.each_with_index do |u1, i1|
		node_row = {:name => u1.raw_text , :group => 1, :mentions => 2*Math.sqrt(u1.count) }
		@node_rows << node_row

		Expression.all.each_with_index do |u2, i2|
			e = Relationship.where(expression_id: u1.id, coocurrance_id: u2.id)

			if !e.blank?
				link_row = {:source => i1, :target => i2, :value => e.count}
				@link_rows << link_row
			end
		end
	end

	@data = { :nodes => @node_rows, :links => @link_rows }
end

end