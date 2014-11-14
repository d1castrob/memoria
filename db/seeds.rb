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


   	if m.nil?
      m = Message.create(from: l[12], text: l[1], id_at_site:l[0], likes:l[3], comments: l[9], created_at: l[14].to_datetime)
    else
      #add favorites and retweets
      m.likes = m.likes + l[3].to_i
      m.comments = m.likes + l[9].to_i
      m.repetitions += 1
    end
    m.save

    expressions = m.get_expressions
    expressions.each do |e|
      aux = Expression.find_or_create_by(raw_text: e[0], symbol: e[1])
      aux.count += 1
      aux.save
    end

  end
end

# found 485 tweeets of which
# 161 where skipped because the where repeated