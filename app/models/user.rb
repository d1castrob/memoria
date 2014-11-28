class User < ActiveRecord::Base

  # friendships es usado para crear el grafo de distancia entre usuarios
  # mientras que followers es usado en conjunto con la API para
  # calcular la distancia entre usuarios. 
  has_many :followers
  has_many :friendships
  has_many :friends, :through => :firendships
  
  #para la autenticacion
  def self.from_omniauth(auth)
    find_by_provider_and_uid(auth["provider"], auth["uid"]) || create_with_omniauth(auth)
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
    end
  end

  # de utilidad
  # def build_followers(array)
  #   array.each do |a|
  #     self.followers.create(id_at_twitter: a.to_s)
  #   end
  # end

end
