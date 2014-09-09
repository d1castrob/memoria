require 'twitter'

class SessionsController < ApplicationController

include ApplicationHelper

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

  #
  # callback para la auth se con fb o twitter
  # instanciacion de usuario y cliente (gema) que se comunica con la api
  #
  def show

    if current_user.provider = 'twitter' # social media from twitter
      if session['access_token'] && session['access_token_secret']
        @user = twitter_client.user(include_entities: true)
        @client = twitter_client
        @timeline = @client.home_timeline()
        @site = 'twitter'
      else
        redirect_to failure_path
      end 
      


      #debug here


      #calculate_geo2
      @user.asdgasdg
    else #social media from facebook
      @graph = facebook_client(include_entities: true)
      # @graph = Koala::Facebook::API.new(session[:access_token])
      # a = 'CAACEdEose0cBAM6YqcNHcTZCiD7EZCySjXuTao3AdX3vR5OjcDdropHraCqm3xRcMF0VbGKxo6bZAeEbMZA86YB9iMlrqH1BJetdWrY2uUu48Jz7dPmOHGxsSfV7UvWTZCgT2F6xYbpzdDztMZCORmMTHFXSiYZBuZBXtrDyNo0AZCMQ5YvwReJObS4pWKlr8cBoqhx9UX2rbNZAZCK5nKQXu9WaVyWeeqbIxcZD'
      @user = @graph.get_object("me","likes")
      @feed = @graph.get_connections("me", "feed")
      @timeline = @user.home
      @site = 'facebook'
    end

  end



  def run

    #text similarity
    calculate_text_distance
    #model = process_data(:documents => Message.all)


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
