require 'csv'

# constants

RECYCLING_INFO_HASH = {
  material:    [],
  accepted:    [],
  alternative_outlet: [],
  action:      [],
  address:     [],
  phone:       [],
  website:     [],
  please_note: []
}

def setup
  set_recycling_info_hash
  @material = 'plastc'
  puts query_results
end

private

  def acceptable_material_response
    "Yes, #{@material} can be recycled with the City of Chicago. #{additional_notes}"
  end

  def additional_notes
    note = RECYCLING_INFO_HASH[:please_note][@index]
    note ? "Please note that #{note.downcase}#{note.split('').last == '.' ? '' : '.'}" : ""
  end

  def fuzzy_match
    matches = []
    RECYCLING_INFO_HASH[:material].each { |m| matches << m if fuzzy_match_score(@material, m) > 0.4 }
    return suggested_material(matches) if matches.length > 0
  end

  def fuzzy_match_score(str1, str2)
    str1.downcase!
    pairs1 = (0..str1.length-2).collect {|i| str1[i,2]}.reject { |pair| pair.include? " " }
    str2.downcase!
    pairs2 = (0..str2.length-2).collect {|i| str2[i,2]}.reject { |pair| pair.include? " " }
    union = pairs1.size + pairs2.size
    intersection = 0
    pairs1.each do |p1|
      0.upto(pairs2.size-1) do |i|
        if p1 == pairs2[i]
          intersection += 1
          pairs2.slice!(i)
          break
        end
      end
    end
    (2.0 * intersection) / union
  end

  def material_index
    @index ||= RECYCLING_INFO_HASH[:material].find_index(@material)
  end

  def material_is_accepted
    RECYCLING_INFO_HASH[:accepted][@index].downcase == 'yes'
  end

  def query_results
    return unknown_material_response unless material_index
    material_is_accepted ? acceptable_material_response : unacceptable_material_response
  end

  def set_recycling_info_hash
    csv_rows = []
    CSV.foreach("./public/chicago-recycling-information.csv") { |row| csv_rows << row }

    csv_rows.each_with_index do |row, idx|
      if idx > 0
        RECYCLING_INFO_HASH[:material]    << row[0]
        RECYCLING_INFO_HASH[:accepted]    << row[1]
        RECYCLING_INFO_HASH[:alternative_outlet] << row[2]
        RECYCLING_INFO_HASH[:action]      << row[3]
        RECYCLING_INFO_HASH[:address]     << row[4]
        RECYCLING_INFO_HASH[:phone]       << row[5]
        RECYCLING_INFO_HASH[:website]     << row[6]
        RECYCLING_INFO_HASH[:please_note] << row[7]
      end
    end
  end

  def suggested_material(materials)
    "I'm not sure if #{@material} can be recycled. You can try searching for any of these materials, though: #{materials.join(', ')}."
  end

  def unacceptable_material_response
    alternative_outlet = RECYCLING_INFO_HASH[:alternative_outlet][@index]
    return "No, #{@material} cannot be recycled." unless alternative_outlet
    action = RECYCLING_INFO_HASH[:action][@index]
    "#{@material.capitalize} can't be recycled with the City of Chicago, but you can #{action} material with #{alternative_outlet}. #{website_information} #{additional_notes}"
  end

  def unknown_material_response
    unknown_response = "I'm not sure if #{@material} can be recycled with the City of Chicago. You can use this link to find a better answer: https://www.earth911.org/search?&material=#{@material}&location=60614."
    return fuzzy_match || unknown_response
  end

  def website_information
    websites = RECYCLING_INFO_HASH[:website][@index].split(',')
    websites.length > 1 ? "Their websites are #{websites.join(',')}." : "Their website is #{websites[0]}"
  end

setup
