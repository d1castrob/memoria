require 'twitter'
require 'matrix'
require 'tf-idf-similarity'
require 'lingua/stemmer'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  @@stemmer = Lingua::Stemmer.new(:language => "spanish", :encoding => 'UTF-8')

  protected

#################################### MANEJO DE REDES SOCIALES ##########################################


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


#################################### DISTANCIA DE TEXTO ###############################################


  # #
  # # construye un TfIdf entre todos los distintos mensajes
  # # usando https://github.com/opennorth/tf-idf-similarity
  # #
  # def tf_idf
  #   #build corpus
  #   corpus = []
  #   Message.all.each do |m|
  #     corpus << TfIdfSimilarity::Document.new(m.text)
  #   end

  #   model = TfIdfSimilarity::TfIdfModel.new(corpus)
  # end

  #
  # recibe una palabra y la devuelve stemisada
  # retorna un arreglo con las mismas palabras stemeadas
  #
  def stem(text)
    output = []
    text.split(' ').each do |word|
      output << @@stemmer.stem(word)
    end
    output.join(' ')
  end



  #
  #  pesca muchos objetos tipo Message
  #  los stemmea y luego crea un modelo de tfidf en base a ellos
  #  retorna el modelo, que puede tiene una matriz de similaridad model.similarity_matrix
  #
  def process_data()
    corpus = []

    # para cada mensaje (o documento)
    documents.each do |m|
      
      # pre procesamos el texto
      @message = m.text.split(' ')
      output []
      @message.each do |word|
        output << @@stemmer.stem(word)
      end

      #lo agregamos al corpues
      corpus << TfIdfSimilarity::Document.new(output.join(' '))
    
    end

    #construimos el modelo
    model = TfIdfSimilarity::TfIdfModel.new(corpus)      

  end

end