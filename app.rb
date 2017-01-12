require 'csv'

RECYCLING_INFO_HASH = {
  material: [],
  accepted: [],
  alternative_recycling_outlet: [],
  action: [],
  address: [],
  phone: [],
  website: [],
  please_note: []
}

def set_recycling_info_hash
  csv_rows = []
  CSV.foreach("./public/chicago-recycling-information.csv") { |row| csv_rows << row }

  csv_rows.each_with_index do |row, idx|
    if idx > 0
      RECYCLING_INFO_HASH[:material] << row[0]
      RECYCLING_INFO_HASH[:accepted] << row[1]
      RECYCLING_INFO_HASH[:alternative_recycling_outlet] << row[2]
      RECYCLING_INFO_HASH[:action]   << row[3]
      RECYCLING_INFO_HASH[:address]  << row[4]
      RECYCLING_INFO_HASH[:phone]    << row[5]
      RECYCLING_INFO_HASH[:website]  << row[6]
      RECYCLING_INFO_HASH[:please_note] << row[7]
    end
  end

  # puts RECYCLING_INFO_HASH[:material].find_index('blah')
end
