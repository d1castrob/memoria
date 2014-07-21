require 'twitter'

class SessionsController < ApplicationController

  def new
  end

  # authentication via twitter or facebook
  def create
    #start local sesion
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id    
    #for later twitter configuration
    session[:access_token] = env["omniauth.auth"]["credentials"]["token"]
    session[:access_token_secret] = env["omniauth.auth"]["credentials"]["secret"]

    redirect_to algo_path, notice: "Signed in!"
  end


  # show of content
  def show

    if current_user.provider = 'twitter' # social media from twitter
      if session['access_token'] && session['access_token_secret']
        @user = twitter_client.user(include_entities: true)
        @client = twitter_client
        @timeline = @client.home_timeline()
      else
        redirect_to failure_path
      end 
    else #social media from facebook
      @graph = Koala::Facebook::API.new(session[:access_token])
      @user = @graph.get_object("me","likes")
      @feed = @graph.get_connections("me", "feed")
      @timeline = @user.home
    end

  end


  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end

  def failure
    redirect_to root_url, alert: "Authentication failed, please try again."
  end

  def auth_hash
    request.env['omniauth.auth']
  end


end
