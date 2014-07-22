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


#################################### DISTANCIA DE TEXTO ENTRE DOS MENSAJES ###############################################


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


#################################### DISTANCIA SOCIAL ENTRE DOS USUARIOS ###############################################


  #
  # aca yo soy user y other_user es el que posteo
  # falta manejar excepcion si es que yo posties
  #
  # nota: la gema retorna objetos del tipo Twitter::User
  #
  def twitter_social_distance(poster_id)
    #fetch a user by screen name or id
    @other_user = client.user(poster_id)
    #this is me
    #@user
    @friend_level = 0

    # following? retorna true si yo sigo al mencionado
    # osea: if i follow the user who paosted
    if @other_user.following?
      @friend_level += 1
    end

    # client.followers.to_a retorna la gente que me sigue
    # osea: if he follows me
    if @other_user.in?client.followers.to_a
      @friend_level += 1
    end
    
    # si quisiera investigar grados de separacion debiese hacer
    # de todos mis seguidores
    @client.followers.to_a.each do |follower|
      #busco los seguidores de mis seguidores
      @followers_of_my_followers = @client.followers(follwer.id).to_a
      #veo si el que posteo algo esta entre ellos
      if @other_user.in?@followers_of_my_followers
        @friend_level += 1
      end
    end
  end

  #
  # recibe el id que la persona que posteo algo
  # ante la posibilidad de contar amigos mutuos con la gente que no conozco, decidi tomar el peso como 
  # la cantidad de amigos en comun mas un peso si es que es amigo mio
  # retorna este peso social
  #
  # nota: a diferencia de twitter la gema retorna pares {"name"=>"Constanza Arcos", "id"=>"502769140"}
  #
  def facebook_social_distance(poster_id)
    # mis amigos
    friends = @graph.get_connections("me", "friends")
    # la cantidad de amigos mutuos que tenemos
    mutualfriends = @graph.get_connections("me", "mutualfriends/#{poster_id}")
    
    #veo si esta dentro de mis amigos
    friends.each do |f|
      if  poster_id == a['id']
        friends.count + mutualfriends.count
      else
        mutualfriends.count
      end
    end
  end


#################################### DISTANCIA TEMPORAL ENTRE DOS MENSAJES ###############################################

  # Los mensajes de prueba y tambien los que seran minados mediante scripts todos deben tener 
  # una fecha de creacion que sea igual a la de inclusion a la BD (al ser creados se sobreescribe este campo)
  # debido a esto la distancia temporal es solo distancia entre fechas

  def temporal_distance(message1, message2)
    (message1.created_at - message2.created_at).to_i.abs
  end

#################################### DISTANCIA GEOGRAFICA ##############################################################

  #
  # 1era prioridad: mencion en el texto a un lugar geografico
  # toma un mensaje y ve si menciona algun lugar del diccionario
  # retorna dicho lugar mencionado o bien un string vacio
  #
  # nota: necesito un diccionario
  #
  def mention(message)
    places = ['chile', 'cuiaba', 'vitacura', 'las condes']
    words = message.text.downcase.split[' ']

    @location = ''

    words.each do |w|
      places.each do |p|
        if p.include? w
          @location = w
        end
      end
    end
    @location
  end

  #
  # 2da prioridad
  # que el contenido tengo adjunto informacion de su ubicacion
  #
  def location

  end

  #
  # 3era prioridad
  # que el usuario sea de algun lado
  #
  def user_location
    @location
    #en facebook
    if current_user.provider == 'facebook'
      me = @graph.get_object("me")
      @location = me['location']['id']
    #en twitter
    else
      @location = @user.location
    end
  end




end