class MessagesController < ApplicationController
include MessagesHelper

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
	data_location = '/text_distance_graph_data'
end

def text_distance
	respond_to do |format|
		format.any { render :json => text_distance_data.to_json }
	end
end


def time_distance_graph
	@data_location = '/time_distance_graph_data'
end

def time_distance
	respond_to do |format|
		format.any { render :json => time_distance_data.to_json }
	end
end

def geo_distance_graph
	@data_location =  '/geo_distance_graph_data'
end

def geo_distance
	respond_to do |format|
		format.any { render :json => geo_distance_data.to_json }
	end
end

end
