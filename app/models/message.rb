class Message < ActiveRecord::Base

  has_one_ad_belong_to_many :expressions

  after_create :create_expressions

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

  def create_expressions
    words = self.texto.strip
    words.each do |w|
      e = Expression.find_or_create_by(raw_text: w, type: get_type(w))
      self.expressions.build(e)
    end
    self.save()
  end

  def get_type(word)
    if word.contains?'#'
      'hashtag'
    elsif word.contains?'@'
      'at'
    elsif word.contains?'://'
      'link'
    else
      nil
    end
  end

end
