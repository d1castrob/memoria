class EdgesController < ApplicationController

def index
  @edges = Edge.all	
  respond_to do |format|
  	format.html
    format.csv { send_data @edges.to_csv }
    #format.csv { render text:  @messages.to_csv }
  end
end

end
