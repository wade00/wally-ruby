module WallyApp

  module Responses

    def acceptable_material_response
      "Yes, #{@material} can be recycled with the City of Chicago. #{additional_notes}"
    end

    def additional_notes
      note = @RECYCLING_INFO_HASH[:please_note][@index]
      note ? "Please note that #{note.downcase}#{note.split('').last == '.' ? '' : '.'}" : ""
    end

    def earth_911_link
      "http://search.earth911.com/?what=#{@material.gsub(' ', '+')}&where=60614"
    end

    def material_index
      @index ||= @RECYCLING_INFO_HASH[:material].find_index(@material)
    end

    def material_is_accepted
      @RECYCLING_INFO_HASH[:accepted][@index].downcase == 'yes'
    end

    def suggested_material(materials)
      "I'm not sure if #{@material} can be recycled. You can try searching for any of these materials, though: #{materials.join(', ')}."
    end

    def unacceptable_material_response
      alternative_outlet = @RECYCLING_INFO_HASH[:alternative_outlet][@index]
      return "No, #{@material} cannot be recycled." unless alternative_outlet
      action = @RECYCLING_INFO_HASH[:action][@index]
      "#{@material.capitalize} can't be recycled with the City of Chicago, but you can #{action} material with #{alternative_outlet}. #{website_information} #{additional_notes}"
    end

    def unknown_material_response
      unknown_response = "I'm not sure if #{@material} can be recycled with the City of Chicago. You can use this link to find a better answer: #{earth_911_link}."
      return fuzzy_match || unknown_response
    end

    def website_information
      websites = @RECYCLING_INFO_HASH[:website][@index].split(',')
      websites.length > 1 ? "Their websites are #{websites.join(',')}." : "Their website is #{websites[0]}"
    end

  end

end
