class Message < ActiveRecord::Base

  has_and_belongs_to_many :expressions


  has_many :edges
  has_many :targets, :through => :edges


  def to_hash
    node_row = {:name => self.text , :group => 1, :mentions => Math.sqrt(self.repetitions + self.comments + self.likes)}
  end

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

  def get_expressions
    words = self.text.split
    output = []

    words.each do |w|
      expression = get_type(w)
      if !expression.nil?
        if expression == 'at'
          output << [w.remove(':'), expression]
        else
          output << [w, expression]
      end
    end
    output
  end

  def get_type(word)
    if word.include?'#'
      'hashtag'
    elsif word.include?'@'
      'at'
    elsif word.include?'://'
      'link'
    else
      nil
    end
  end

end
