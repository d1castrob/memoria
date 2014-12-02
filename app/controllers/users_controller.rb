class UsersController < ApplicationController
include UsersHelper

def index
    if session['access_token'] && session['access_token_secret']
      @user = client.user(include_entities: true)
    else
      redirect_to failure_path
    end
end


def cleanup
  User.all.each do |u|
    begin
      if u.info_available.nil?
        @a = twitter_client.user(u.twitter_name)
        u.info_available = true
        u.save
        puts 'user_available'
      else
        puts 'skipped'
      end
    rescue Twitter::Error::Forbidden, Twitter::Error::NotFound, Twitter::Error::Unauthorized
      u.delete
      puts 'user_unavailable'
    rescue Twitter::Error::TooManyRequests
      puts 'too many requests'
    end
  end
end


def social_graph
end

def data
  respond_to do |format|
    format.any { render :json => social_graph_data.to_json }
  end
end


end
