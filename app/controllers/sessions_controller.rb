require 'twitter'

class SessionsController < ApplicationController

  def new
  end

  def create

    #start local sesion
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    
    #for later twitter configuration
    session[:access_token] = env["omniauth.auth"]["credentials"]["token"]
    session[:access_token_secret] = env["omniauth.auth"]["credentials"]["secret"]

    redirect_to root_url, notice: "Signed in!"
  end


  def show

    @user = Twitter::REST::Client.new do |config|
      config.consumer_key = 'b1BcFmbc1ILHAcVbhNKyg'
      config.consumer_secret = 'T7JUvNcTu3RvJ12RRmRkdnaccpH8RDmrZwFR2AY'
      config.oauth_token = session[:access_token]
      config.oauth_token_secret = session[:access_token_secret]
    end

    if session['access_token'] && session['access_token_secret']
      @user = client.user(include_entities: true)
    else
      redirect_to failure_path
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
