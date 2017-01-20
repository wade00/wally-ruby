require_relative 'config'

module WallyApp

  class Base
    include WallyApp::Config

    def initialize(material)
      @RECYCLING_INFO_HASH = set_recycling_info_hash
      @material = material
    end

    def query_results
      return unknown_material_response unless material_index
      material_is_accepted ? acceptable_material_response : unacceptable_material_response
    end

  end

end
