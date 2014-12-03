class ExpressionsController < ApplicationController
include ExpressionsHelper

def semantic_graph
end

def semantic
	respond_to do |format|
		format.any { render :json => semantic_graph_data.to_json }
	end
end

end