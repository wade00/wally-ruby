require_relative 'csv-parser'
require_relative 'fuzzy-match'
require_relative 'responses'

module WallyApp

  module Config
    include WallyApp::CsvParser
    include WallyApp::FuzzyMatch
    include WallyApp::Responses
  end

end
