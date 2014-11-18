# encoding: utf-8

#archivo proporcionado por MQ con tweets
file = File.open('C:\Users\VAIO\Desktop\tweets.csv')

# primera linea del archivo (headers)
l1 = file.readline.split(/\t/)[15]
# aqui esta el id del evento
# evento = line.remove(/\n/)
ActiveRecord::Base.logger = nil

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

# found 485 tweeets of which
# 161 where skipped because the where repeated