class ExpressionsController < ApplicationController
include ExpressionsHelper

def semantic_graph
	@data_location = '/semantic_graph_data'
end

def semantic
	respond_to do |format|
		format.any { render :json => semantic_graph_data2.to_json }
	end
end

end