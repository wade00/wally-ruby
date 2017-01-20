module WallyApp

  module FuzzyMatch

    def fuzzy_match
      matches = []
      @RECYCLING_INFO_HASH[:material].each { |m| matches << m if fuzzy_match_score(@material, m) > 0.4 }
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

  end

end
