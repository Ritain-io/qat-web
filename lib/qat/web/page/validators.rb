module QAT::Web
  class Page
    # Module with helper methods to validate Page return types
    # @since 2.0.1
    module Validators
      private
      # Validates the return value for the action based on the return options
      # @param return_opts [Hash] return options
      # @return [Array|Class]
      def validate_return_value(return_opts)
        raise TypeError.new "Did not find return information, the ':returns' option must be defined!" unless return_opts

        case return_opts
        when Array
          return_opts = validate_return_type_array(return_opts)
        when Class
          raise TypeError.new "Invalid return value, #{return_opts} be subclasses of QAT::Web::Page." unless return_opts.ancestors.include? QAT::Web::Page
        else
          raise TypeError.new "Invalid return value, must be either an Array or a subclass of QAT::Web::Page, but was #{return_opts}"
        end

        return_opts
      end

      # Validate an array of return options
      # @param return_opts [Array] return options
      # @return [Array|Class]
      def validate_return_type_array(return_opts)
        raise TypeError.new "Invalid return value, must be either an Array or a subclass of QAT::Web::Page, but was an empty array" if return_opts.empty?
        invalid = return_opts.reject { |klass| klass.is_a? Class and klass.ancestors.include? QAT::Web::Page }
        raise TypeError.new "Invalid return values, must all be subclasses of QAT::Web::Page. Invalid options: #{invalid.join ', '}" unless invalid.empty?

        return_opts
      end
    end
  end
end