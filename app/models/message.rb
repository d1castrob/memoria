class Message < ActiveRecord::Base

  has_one_ad_belong_to_many :expressions

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |message|
        csv << message.attributes.values_at(*column_names)
      end
    end
  end


  def calculate_location
    unless !self.location.nil?

    begin
      # primero buscamos is el texto hace referencia a un lugar
      self.location = mention(m)          
      # sino, buscamos si el contenido fue posteado desde algun lugar
      if self.location.blank?    
        self.location = location(m)
        # sino, buscamos donde vive el usuario
        if self.location.nil?
          self.location = user_location(m)
          #sino encontramos nada guardamos sin ubicacion  
          if self.location.blank?
            self.location = 'sin ubicacion'
            puts 'guardando sin ubicacion'
          end
        end
      end

    rescue Twitter::Error::Forbidden
      self.location = 'sin ubicacion'
      puts 'user forbidden, guardando sin ubicacion'

    rescue Twitter::Error::NotFound
      self.location = 'sin ubicacion'
      puts 'not found, guardando sin ubicacion'

    rescue Twitter::Error::TooManyRequests
      puts 'rate exceeded'
      return 0

    end

    self.save
    
    end  	
  end

end
