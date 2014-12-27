# See http://kyle.conarro.com/importing-from-csv-in-rails

class AwesomeImporter
  include ActiveModel::Model

  def initialize(file)
    @file = file
  end

  # Since this model isn't ever persisted, just return false
  def persisted?
    false
  end

  # Logic to determine if import is valid
  def valid?
    return false if csv_empty?

    record_attributes = read_stuff_from_csv
    import_records = record_attributes.map {|attrs| Vlan.new(attrs)}
    import_records.map(&:valid?).all?
  end 

  def read_stuff_from_csv
    CSV.new(@file, headers: :first_row).each do |row|
      # do stuff with the row data
    end
    # return some useful data for making records
  end

  def csv_empty?
    if CSV.new(File.open(file2), headers: :first_row).to_a.empty?
      # add a helpful error message for the user
      errors.add :base, "CSV is empty"
      true
    end
  end
end

