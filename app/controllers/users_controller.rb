class UsersController < ApplicationController


def index
    if session['access_token'] && session['access_token_secret']
      @user = client.user(include_entities: true)
    else
      redirect_to failure_path
    end
end



end
