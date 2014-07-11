class WelcomeController < ApplicationController


# def index
	
# end

def index
  respond_to do |format|
  	format.html
    format.csv { send_data @messages.to_csv }
    #format.csv { render text:  @messages.to_csv }
  end
end


end
