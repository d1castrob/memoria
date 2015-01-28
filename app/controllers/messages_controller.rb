class MessagesController < ApplicationController
include MessagesHelper


before_action :set_message, only: [:show]


#exportaccion de la BD a csv
def index
  @messages = Message.all	
  respond_to do |format|
  	format.html
    format.csv { send_data @messages.to_csv }
  end
end


def show
	
	# [ mover al modelo.... 
	@links = []
	@users = []
	@hashtags = []

	@message.get_expressions.sort_by{|e| e[1]}.each do |e|
		if e[1]=='link'
			@links << e[0]
		elsif e[1]=='at'
			@users << e[0]
		elsif e[1]=='hash'
			@users << e[0]
		end
	end	
	#             ......] #


	#def social_similars
		@specific_social_distance = []
		@users.each do |u|
			mentioned_user = User.find_by_twitter_name(u)
			mentioned_user.friendships.order(weight: :desc).take(5).each do |f|
				@specific_social_distance << [ mentioned_user, f.friend]
			end
		end
	#end


	@specific_text_distance =  @message.edges.sort_by{|e| -e[:text_distance]}.take(5)



end


#para la visualizacion en la app misma

def text_distance_graph
	@data_location = '/text_distance_graph_data'
end

def text_distance
	respond_to do |format|
		format.any { render :json => calculate_text_distance_data.to_json }
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


private
    def set_message
      @message = Message.find(params[:id])
    end




end
