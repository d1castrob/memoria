# En los comentarios esta el script que fue usado para pasar la base de datos local, ya procesada,
# hacia los archivos .csv de respaldo en la carpeta publica.  Estos archivos son usados como semillas
# para construir la BD de una sola vez en el servidor y ahorrar procesamiento.


# CSV.open('User.csv', 'wb') do |csv|
#   User.all.each do |m|
#     csv << [m.twitter_name, m.mentions]
#   end
# end

CSV.foreach('User.csv') do |row|
	User.find_or_create_by(twitter_name: row[0], mentions: row[1])
end

# CSV.open('Message.csv', 'wb') do |csv|
#   Message.all.each do |m|
#     csv << [m.id, m.from, m.id_at_site, m.comments, m.likes, m.repetitions, m.created_at, m.text]
#   end
# end

CSV.foreach('Message.csv') do |row|
    Message.find_or_create_by(id: row[0].to_i, from: row[1], id_at_site: row[2], comments: row[3].to_i, likes: row[4].to_i, repetitions: row[5].to_i, created_at: row[6].to_datetime, text: row[7])
end

# CSV.open('Expression.csv', 'wb') do |csv|
#   Expression.all.each do |m|
#     csv << [m.symbol, m.from, m.count, m.raw_text]
#   end
# end

CSV.foreach('Expression.csv') do |row|
	Expression.find_or_create_by(symbol: row[0], count: row[1].to_i, raw_text: row[2])
end

# CSV.open('Relationship.csv', 'wb') do |csv|
#   Relationship.all.each do |m|
#     csv << [m.expression_id, m.coocurrance_id, m.count]
#   end
# en

CSV.foreach('Relationship.csv') do |row|
	Relationship.find_or_create_by(expression_id: row[0].to_i, coocurrance_id: row[1].to_i, count: row[2].to_i)
end

# CSV.open('Friendship.csv', 'wb') do |csv|
#   Friendship.all.each do |m|
#     csv << [m.friend_id, m.user_id, m.weight]
#   end
# en

CSV.foreach('Friendship.csv') do |row|
	Friendship.find_or_create_by(friend_id: row[0].to_i, user_id: row[1].to_i, weight: row[2].to_float)
end

# CSV.open('Edge.csv', 'wb') do |csv|
#   Edge.all.each do |m|
#     csv << [m.id, m.message_id, m.target_id, m.location, m.social_distance, m.text_distance]
#   end
# end;0

CSV.foreach('Edge.csv') do |row|
	Edge.find_or_create_by(id: row[0].to_i, message_id: row[1].to_i, target_id: row[2].to_i, location: row[3], social_distance: row[4].to_float, text_distance: row[5].to_float)
end

# system('cls')