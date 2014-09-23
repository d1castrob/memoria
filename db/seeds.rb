# encoding: utf-8

#archivo proporcionado por MQ con tweets
file = File.open('C:\Users\VAIO\Desktop\tweets.csv')

# primera linea del archivo (headers)
l1 = file.readline.split(/\t/)[15]
# aqui esta el id del evento
# evento = line.remove(/\n/)
ActiveRecord::Base.logger = nil
#para cada linea del archivo
file.each_line do |line|
  # para el mismo evento
  if line.split(/\t/)[15].remove(/\n/) == '26900'
    puts 'found'
    # likes = rt, comments = favs
    l = line.split(/\t/)
   	m = Message.find_by_text(l[1])
   	if m.nil?
      Message.create(from: l[12], text: l[1], id_at_site:l[0], likes:l[3], comments: l[9], created_at: l[14].to_datetime)
  	else
  	  #add favorites and retweets
  	  m.likes = m.likes + l[3].to_i
  	  m.comments = m.likes + l[9].to_i
      m.save
  	end
  end
end