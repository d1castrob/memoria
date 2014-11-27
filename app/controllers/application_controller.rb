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
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key = 'Ze6uAgUGLBYmUerv8iHEZmK9P'
      config.consumer_secret = 'cBtKADamQzPsaLd0kXtrnkDlH6T6kIOnbK5FudZ6PkYqfWFQiu'
      config.access_token = session[:access_token]
      config.access_token_secret = session[:access_token_secret]
    end
  end
  
  # def twitter_client
  #   @client ||= Twitter::REST::Client.new do |config|
  #     config.consumer_key = 'Ze6uAgUGLBYmUerv8iHEZmK9P'
  #     config.consumer_secret = 'cBtKADamQzPsaLd0kXtrnkDlH6T6kIOnbK5FudZ6PkYqfWFQiu'
  #     config.access_token = '1452788382-D5Qo9GpSppus25RLkB4rHoBENX9a9bBai9GkCjx'
  #     config.access_token_secret = 'L8UC4ARhdEa8RHquAEEsREamP9b79LyGQjB4WXaRgIGqD'
  #   end
  # end



  #
  # inicializa un cliente de fb mediante el cual se puede pedir info privada
  # del usuario cuya que inicio sesion en la app web
  #
  def facebook_client
    @graph ||= Koala::Facebook::API.new(session[:access_token])
  end



#################################### AUMENTAR LA BD ##########################################


  def calculate_geo2
    Message.all.each do |m|
      
      #si todavia no tiene ubicacion
      unless !m.location.nil?
        
        begin


          # primero buscamos is el texto hace referencia a un lugar
          m.location = mention(m)          
          # sino, buscamos si el contenido fue posteado desde algun lugar
          if m.location.blank?    
            m.location = location(m)
            # sino, buscamos donde vive el usuario
            if m.location.nil?
              m.location = user_location(m)
              #sino encontramos nada guardamos sin ubicacion  
              if m.location.blank?
                m.location = 'sin ubicacion'
                puts 'guardando sin ubicacion'
              end
            end
          end

        rescue Twitter::Error::Forbidden
          m.location = 'sin ubicacion'
          puts 'user forbidden, guardando sin ubicacion'

        rescue Twitter::Error::NotFound
          m.location = 'sin ubicacion'
          puts 'not found, guardando sin ubicacion'

        rescue Twitter::Error::TooManyRequests
          puts 'rate exceeded'
          return 0

        end

        m.save

      end
    end
  end




  #
  # asumo que se obtiene la distancia temporal apenas se mina el contenido.
  #
  def calculate_temporal_distance
    #ahorro tiempo
    ActiveRecord::Base.logger = nil
    # itero sobre los datos donde m son objetos mensajes, mientras que i y j son indices
    Message.all.each_with_index do |m1,i|
      Message.all.each_with_index do |m2,j|
        # para ahorrar, pues la matriz es simetrica
        if j > i
          # calcular distancia
          #agregar a BD
          e = Edge.where(source: m1.id_at_site, target: m2.id_at_site).first_or_create
          unless e.nil?
            dist = temporal_distance(m1,m2)
            e.time_distance = dist
            e.save
          end
        end
      end
      # print progreso
      puts i
    end
  end

  #
  # necesita dos id de usuarios 
  #
  def calculate_social_distance
    ActiveRecord::Base.logger = nil
    User.all.each do |u1|
      @user1 = u1.twitter_name
      
      if u1.followers1.empty?
        @followers1 = twitter_client.friend_ids(@user1).to_a
        u1.build_followers(@followers1)
      end

      User.all.each do |u2|
        @user2 = u2.twitter_name

        begin

          a = Edge.where(source: @user1, target: @user2)
          b = Edge.where(source: @user2, target: @user1)

          if a.blank? && b.blank?
            
            if u2.followers.empty?
              @followers2 = twitter_client.friend_ids(@user2).to_a
              u2.build_followers(@followers2)
            end

            dist = twitter_social_distance(u1, u2)            
            @e = Edge.create(source: @user1, target: @user2, social_distance: dist)
            @e.save
            puts 'saving ' + @user1 + ', '+@user2
          
          else
            puts 'skipping'
          end

        rescue Twitter::Error::Forbidden
          @e = Edge.create(source: @user1, target: @user2, social_distance: 0)
          puts '----------------------user forbidden, guardando sin datos------'
        rescue Twitter::Error::NotFound
          @e = Edge.create(source: @user1, target: @user2, social_distance: 0)
          puts '----------------------not found, guardando sin datos-----------'
        rescue Twitter::Error::Unauthorized
          @e = Edge.create(source: @user1, target: @user2, social_distance: 0)
          puts '----------------------Unauthorized, guardando sin datos--------'
        rescue Twitter::Error::TooManyRequests
          puts '----------------------rate exceeded----------------------------'
          debug.debug
          return 0
        end

      end
    end
  end

  #
  # en base al texto de dos mensajes, calcula cuanto difiere uno de otro
  #
  def calculate_text_distance
    model = process_data(:documents => Message.all);
    ActiveRecord::Base.logger = nil
    # itera para el modelo construido
    # los mensajes parten en 1 y la matriz en cero asi que por eso estan los indices corridos
    # i.e. Messages.find(1) == model.documents[0] => true
    # nota: index (e,i,j) == (valor,fila,col)
    # es vital separar en estas dos lineas
    puts 'loading matrix'
    m = model.similarity_matrix
    puts 'printing to db'
    numeroIter = m.shape[0]-1

    for i in 0..numeroIter
      for j in 0..numeroIter
        # para ahorrar, pues la matriz es simetrica
        if j > i 
          #encontrar ids de mensajes en el sitio
          m1 = Message.find(i.to_i+1).id_at_site;
          m2 = Message.find(j.to_i+1).id_at_site;
          #encontrar distancia
          unless m[i,j] == 0
            Edge.create(:source => m1,:target => m2,:text_distance => m[i,j]);  
          end
        end
        #print para saber el progreso del proceso
      end
      puts i
    end

  end

end


#################################### LIMPIAR INFO ##########################################

# umbrales para los ejes
# 

# todo downcase
# todo strip
# la ubicacion con el mismo grado de precision, osea, tal vez mas de un campo


