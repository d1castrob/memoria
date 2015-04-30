# En los comentarios esta el script que fue usado para pasar la base de datos local, ya procesada,
# hacia los archivos .csv de respaldo en la carpeta publica.  Estos archivos son usados como semillas
# para construir la BD de una sola vez en el servidor y ahorrar procesamiento.

# File.open('User.csv', 'w') do |f2|
# User.all.each do |u|
# a = u.twitter_name+','+u.mentions.to_s
# f2.puts a
# end
# end

CSV.foreach('User.csv') do |row|
	User.find_or_create_by(twitter_name: row[0], mentions: row[1])
end


# CSV.open('msg.csv', 'wb') do |csv|
#   Message.all.each do |m|
#     csv << [m.id, m.from, m.id_at_site, m.comments, m.likes, m.repetitions, m.created_at, m.text]
#   end
# end


CSV.foreach('Message.csv') do |row|
	Message.find_or_create_by(id: row[0].to_i, from: row[1], id_at_site: row[2], comments: row[3].to_i, likes: row[4].to_i, repetitions: row[5].to_i, created_at: row[6].to_datetime, text: row[7])
end




# File.open('Expression.csv', 'w') do |f2|
# Expression.all.each do |m|
# a = m.symbol.to_s+','+m.count.to_s+','+m.raw_text
# f2.puts a
# end
# end

CSV.foreach('Expression.csv') do |row|
	Expression.find_or_create_by(symbol: row[0], count: row[1].to_i, raw_text: row[2])
end

# File.open('Relationship.csv', 'w') do |f2|
# Relationship.all.each do |m|
# a = m.expression_id.to_s+','+m.coocurrance_id.to_s+','+m.count.to_s
# f2.puts a
# end
# end

CSV.foreach('Relationship.csv') do |row|
	Relationship.find_or_create_by(expression_id: row[0].to_i, coocurrance_id: row[1].to_i, count: row[2].to_i)
end

# File.open('Friendship.csv', 'w') do |f2|
# Friendship.all.each do |m|
# a = m.friend_id.to_s+','+m.user_id.to_s+','+m.weight.to_s
# f2.puts a
# end
# end

CSV.foreach('Friendship.csv') do |row|
	Friendship.find_or_create_by(friend_id: row[0].to_i, user_id: row[1].to_i, weight: row[2].to_i)
end

# File.open('Edge', 'w') do |f2|
# Edge.all.each do |m|
# a = m.id.to_s+','+m.message_id.to_s+','+m.target_id.to_s+','+m.location.to_s+','+m.social_distance.to_s+','+m.text_distance.to_s
# f2.puts a
# end
# end

CSV.foreach('Edge.csv') do |row|
	Edge.find_or_create_by(id: row[0].to_i, message_id: row[1].to_i, target_id: row[2].to_i, location: row[3], social_distance: row[4].to_i, text_distance: row[5].to_i)
end

# system('cls')