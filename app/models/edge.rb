class Edge < ActiveRecord::Base

	belongs_to :message
	belongs_to :target, :class_name => "Message"

  def to_hash
    link_row = {:source => self.message_id, :target => self.target_id, :value => self.text_distance}
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |message|
        csv << message.attributes.values_at(*column_names)
      end
    end
  end

end
