# encoding: utf-8
include ApplicationHelper



#archivo proporcionado por MQ con tweets
file = File.open('C:\Users\VAIO\Desktop\tweets.csv')
# primera linea del archivo (headers)
l1 = file.readline.split(/\t/)[15]
# aqui esta el id del evento
ActiveRecord::Base.logger = nil


#
# PASO 1
#
# preprocesamiento de los datos proveidos por MQ
# se incluyen en el modelo de datos de la aplicacion
# y se limpian redundancias obvias
#

total = 0
skipped = 0 

file.each_line do |line|

  if line.split(/\t/)[15].remove(/\n/) == '26900'
    total += 1
    puts 'found'
    # likes = rt, comments = favs
    l = line.split(/\t/)
   	m = Message.find_by_text(l[1])


    #crear los mensajes
   	if m.nil?
      m = Message.create(from: l[12], text: l[1], id_at_site:l[0], likes:l[3], comments: l[9], created_at: l[14].to_datetime)
    else
      #add favorites and retweets
      m.likes = m.likes + l[3].to_i
      m.comments = m.likes + l[9].to_i
      m.repetitions += 1
    end
    m.save

    #crear las expresiones
    expressions = m.get_expressions
    aux = []
    expressions.each_with_index do |e, index|
      
      aux << [Expression.find_or_create_by(raw_text: e[0], symbol: e[1]), index]
      aux[index][0].count += 1
      aux[index][0].save

      #si existen coocurrencias
      if index > 1
        #para toda tupla de aux con indice menor al actual
        for i in 0..index-1
          #crear relacion con aux actual
          @eje = aux[index][0].relationships.find_or_initialize_by(coocurrance_id: aux[i][0].id)
          @eje.count += 1
          @eje.save
        end
      end

    end

  end
end


#
# PASO 2: post procesamiento de los datos
#
# calcular distancias entre distintos nodos.
# en este caso dist social
#
Expression.where(symbol: 'at').each do |e|
  User.create(twitter_name: e.raw_text)
end

User.all.each do |u1|
  User.all.each do |u2|


    a = Edge.where(source: u1.twitter_name, target: u2.twitter_name)
    #holi.holi
    dist = twitter_social_distance(u1.twitter_name, u2.twitter_name)
    
    if a.blank? || !a.social_distance.nil?
      Edge.create(sourc: u1.twitter_name, target: u2.twitter_name, social_distance: dist)
    else
      a.each do |edg|
        edg.social_distance = dist
      end
    end

  end
end