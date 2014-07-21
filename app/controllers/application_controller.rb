require 'twitter'
require 'tf_idf'

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
  # a.tf, a.idf y a.tf_idf son metodos validos
  #
  def tf_idf
    #build data
    data = []
    Message.all.each do |m|
      data << m.text.split(' ')
    end
    
    tiffany = TfIdf.new(data)
  end

  #
  # calcula la distancia de coseno entre dos vectores
  # necesita el diccionario tfidf
  #
  def cosine_distance
    
  end

end