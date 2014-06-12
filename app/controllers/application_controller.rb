require 'twitter'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def signed_in?
    !!current_user
  end
  helper_method :current_user, :signed_in?

  def client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = 'b1BcFmbc1ILHAcVbhNKyg'
      config.consumer_secret = 'T7JUvNcTu3RvJ12RRmRkdnaccpH8RDmrZwFR2AY'
      config.oauth_token = session[:access_token]
      config.oauth_token_secret = session[:access_token_secret]
    end
  end


end