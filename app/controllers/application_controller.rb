require 'twitter'
require 'matrix'
require 'tf-idf-similarity'
require 'lingua/stemmer'

class ApplicationController < ActionController::Base

  include ApplicationHelper
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


  #
  # calcula la posicion geografica del contenido publicado y lo agrega a su informacion
  #
  def calculate_geo
    Message.all.each do |m|
      
      #si todavia no tiene ubicacion
      unless m.location != '  sin ubicacion '
        
        # primero buscamos is el texto hace referencia a un lugar
        m.location = mention(m)
        if mention(m).nil?          
          
          # sino buscamos si el contenido fue posteado desde algun lugar
          m.location = location(m)
          if location(m).nil?
            
            # sino buscamos donde vive el usuario
            m.location = user_location?
          else
            m.location = 'sin ubicacion'
          end
        end
      end

    end
  end


  #
  # asumo que se obtiene la distancia temporal apenas se mina el contenido.
  #
  def calculate_temporal_distance
    Message.all.each do |m1|
      Message.all.each do |m2|

        temporal_distance(m1,m2)

        #agregar a BD

      end
    end
  end

  #
  # necesita dos id de usuarios 
  #
  def calculate_soocial_distance
    Message.all.each do |m1|
      @user1 = m1.from
      Message.all.each do |m2|
        @user2 = m2.from

        # si los sitios son el mismo la calculo segun el sitio, sino no retorno nada
        if m1.site == m2.site

          if m1.site == 'twitter'
            dist = twitter_social_distance(@user1,@user2)
          else
            dist = facebook_social_distance(@user1,@user2)
          end
        end

      end
    end
  end

  #
  # en base al texto de dos mensajes, calcula cuanto difiere uno de otro
  #
  def calculate_text_distance
    Message.all.each do |m1|
      Message.all.each do |m2|

        model = process_data(:documents => Message.all)

        # agregar a la bd

      end
    end
  end



end