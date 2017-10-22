class ApplicationRecord < ActiveRecord::Base
  
  self.abstract_class = true

  def self.csv_headers
  end

  def self.csv_column_syms
  end

  def self.to_csv(options = {})
    CSV.generate(headers: true, force_quotes: true) do |csv|
      csv << csv_headers
      all.each do |record|
        csv << csv_column_syms.map{ |attr| "#{record.send(attr).to_s}" }
      end
    end
  end

end
