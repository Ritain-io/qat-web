module QAT
  module Web
    module Elements
      # Configuration handling helper
      module Config
        # Validates that the given config is in the correct format
        # @param config [Hash] configuration hash
        # @param collection [String] collection name
        # @return [Boolean]
        def valid_config?(config, collection)
          unless config.kind_of?(Hash) && config.any?
            raise(ArgumentError, "Empty or invalid configuration was given for #{collection.capitalize}! A hash like configuration is expected!")
          end
          true
        end
      end
    end
  end
end