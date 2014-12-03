class MessagesController < ApplicationController

#exportaccion de la BD a csv
def index
  @messages = Message.all	
  respond_to do |format|
  	format.html
    format.csv { send_data @messages.to_csv }
  end
end

#para la visualizacion en la app misma

def text_distance_graph
end

def text_distance
	respond_to do |format|
		format.any { render :json => text_distance_data.to_json }
	end
end


def time_distance_graph
end

def time_distance
	respond_to do |format|
		format.any { render :json => time_distance_data.to_json }
	end
end



end
