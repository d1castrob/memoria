require 'twitter'
require 'matrix'
require 'tf-idf-similarity'

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

  #
  # inicializa un cliente de twitter mediante el cual se puede pedir info privada
  # del usuario cuya que inicio sesion en la app web
  #
  def twitter_client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = 'b1BcFmbc1ILHAcVbhNKyg'
      config.consumer_secret = 'T7JUvNcTu3RvJ12RRmRkdnaccpH8RDmrZwFR2AY'
      config.access_token = session[:access_token]
      config.access_token_secret = session[:access_token_secret]
    end
  end

  #
  # construye un TfIdf entre todos los distintos mensajes
  # usando https://github.com/opennorth/tf-idf-similarity
  #
  def tf_idf
    #build corpus
    corpus = []
    Message.all.each do |m|
      corpus << TfIdfSimilarity::Document.new(m.text.split(' '))
    end

    model = TfIdfSimilarity::TfIdfModel.new(corpus)
  end

end