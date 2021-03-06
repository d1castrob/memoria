module ApplicationHelper



  @@places = ['spain','germany','brazil','portugal','argentina','switzerland','uruguay','colombia','italy','england','belgium','greece','united states','chile','netherlands','france','croatia','russia','mexico','bosnia and herzegovina','algeria','ivory coast','ecuador','costa rica','honduras','ghana','iran','nigeria','japan','cameroon','south korea','australia']

# aqui va todo lo que se ocupa para calcular distancia entre mensajes o usuarios
# de modo que es un modulo que ayuda en el procesamiento de datos internos para pasar
# desde la recoleccion de datos (externa o desde la BD) a la visualizacion misma


######################### DISTANCIA DE TEXTO ENTRE DOS MENSAJES #########################


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
  def process_data(options={})


    @@stemmer = Lingua::Stemmer.new(:language => "en", :encoding => 'UTF-8')

    corpus = []
    puts 'loading docs'
    # para cada mensaje (o documento)
    options[:documents].each do |m|
      
      # pre procesamos el texto
      @message = m.text.split(' ')
      output = []
      @message.each do |word|
        output << @@stemmer.stem(word);0
      end

      #lo agregamos al corpues
      for i in 0..m.repetitions do 
        corpus << TfIdfSimilarity::Document.new(output.join(' '));0
      end
    
    end
    puts 'building model'
    #construimos el modelo
    model = TfIdfSimilarity::TfIdfModel.new(corpus, :library => :narray)      

  end


#################################### DISTANCIA SOCIAL ENTRE DOS USUARIOS ###############################################


  def twitter_social_distance(user1, user2)

    # DESCARTADO POR LIMITE LLAMADAS TWITTER
    #
    # followers1 = twitter_client.followers(u1).to_a
    # user2 = twitter_client.user(u2)
    # dist = 0
    # followers1.each do |f1|
    #   if user2.following?f1
    #     dist += 1
    #   end
    # end
    # dist
   

    # si viene como arreglo
    if user1.is_a?(Array) && user2.is_a?(Array) 
      f1 = user1
      f2 = user2
      puts 'array'
    elsif user1.is_a?(User) && user2.is_a?(User)
      f1 = user1.followers
      f2 = user2.followers
    # si viene como numero o username
    else   
      u1 = user1.to_i == 0 ? user1 : user1.to_i
      u2 = user2.to_i == 0 ? user2 : user2.to_i

      f1 = twitter_client.friend_ids(u1).to_a
      f2 = twitter_client.friend_ids(u2).to_a
    end

    common = f1 & f2

    #normalized by popularity
    common.count/Math.sqrt(f1.count*f1.count + f2.count*f2.count)

  end








  #
  # recibe el id que la persona que posteo algo
  # ante la posibilidad de contar amigos mutuos con la gente que no conozco, decidi tomar el peso como 
  # la cantidad de amigos en comun mas un peso si es que es amigo mio
  # retorna este peso social
  #
  # nota: a diferencia de twitter la gema retorna pares {"name"=>"Constanza Arcos", "id"=>"502769140"}
  # nota: la operacion get_connections("other user", "friends") no esta soportada por la API: https://developers.facebook.com/docs/graph-api/reference/v2.0/user/
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
  	# si esta en la BD
    (message1.created_at - message2.created_at).to_i.abs
    # si no esta
    # if current_user.provider == twitter
    #   status = @client.status(options[:message].id_at_site.to_i)
    #   status['created_at']
    # else
    #   object
    # end
  end

#################################### DISTANCIA GEOGRAFICA ##############################################################

  #
  # 1era prioridad: mencion en el texto a un lugar geografico
  # toma un mensaje y ve si menciona algun lugar del diccionario
  # retorna dicho lugar mencionado o bien un string vacio
  #
  # nota: necesito un diccionario
  #
  def mention(mensaje)
    words = mensaje.text.downcase.split

    @location = ''

    # esto puede que sea mas rapido
    # Message.where('text LIKE ?', '%chile%').all
    
    words.each do |w|
      @@places.each do |p|
        if w.include? p
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
  def location(options={})


    @client = options[:client]

    if !@client.nil?
      if current_user.provider == 'twitter'
        # # si me entregan el id de un usuario que posteo
        # if options[:user_id].present?
        #   timeline = @client.user_timeline('biobio')
        #   timeline.first['geo']
        # # si me entregan el id de un mensaje
        # else
          status = @client.status(options[:message].id_at_site.to_i)
          status['geo']
        # end

      elsif current_user.provider == 'facebook'
        # aqui podemos buscar 
        # if options[:user_id].present?

          # NOTA: 

          # # buscando un post en especifico, i.e si hicimos
          # a = [ options[:user_id], options[:post_id] ].join('_')
          # me = @graph.get_object("me").id
          
          # mi newsfeed (lo que yo posteo) es lo siguiente 
          # to = Time.now.to_i
          # yest = 1.day.ago.to_i
          # @graph.fql_query("SELECT post_id, actor_id, target_id, message, likes FROM stream WHERE source_id = me() AND created_time > #{yest} AND created_time < #{to} AND type = 80 AND strpos(attachment.href, 'youtu') >= 0")

          # feed de otro usuario
          # @graph.get_connections("username", "feed")


          object = @graph.get_object("582203474_10153322204548475")
          # object['place']
          # {"id"=>"305286842892108", "name"=>"Complejo Deportivo Terra Soccer", "location"=>{"city"=>"Santiago", "country"=>"Chile", "latitude"=>-33.4721340873, "longitude"=>-70.6194303291}}
          object['place']['location']['city']

        # else
          # # buscando por un tema un post publico i.e. si hicimos
          # @graph.search("topic")        
        # end
      end
    end

  end

  #
  # 3era prioridad
  # que el usuario sea de algun lado
  #
  def user_location(mensaje)
    @location
    #en facebook
    if current_user.provider == 'facebook'
      me = @graph.get_object("me")
      @location = me['location']['id']
    #en twitter
    else
      @location = twitter_client.user(mensaje.from.to_i).location
    end
  end

  def build_user_followers(user)
    if user.followers.empty?
      @followers_array = twitter_client.friend_ids(user.twitter_name).to_a
      @followers_array.each do |follower|
        f = Follower.find_or_create_by(id_at_twitter: follower.to_s)
        user.followers << f
      end  
      user.save
    end
    user.followers
  end


end

