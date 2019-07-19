require_relative 'selector'
require_relative 'config'
require 'retriable'
require 'qat/logger'

module QAT
  module Web
    module Elements
      # Helper methods for handling timeouts and wait periods
      module Waiters
        include QAT::Logger
        include Selector
        include Config

        # Defines timeouts through a configuration file path
        # @param path [String] path to timeouts configuration file
        # @return [HashWithIndifferentAccess]
        def timeouts_file(path)
          raise(ArgumentError, "File '#{path}' does not exist!") unless File.exist?(path)
          @timeouts_file = path
          begin
            config = YAML.load(File.read(@timeouts_file)) || {}
          rescue Psych::SyntaxError
            log.error "Failed to load file '#{@timeouts_file}'."
            raise
          end
          timeouts_config(config)
        end

        # Defines timeouts through a configuration hash
        # @param timeouts [Hash] timeouts configuration
        # @return [HashWithIndifferentAccess]
        def timeouts_config(timeouts)
          valid_config?(timeouts, 'timeouts')
          @timeouts = HashWithIndifferentAccess.new(timeouts)
        end

        # Returns the timeouts configuration
        # @return [HashWithIndifferentAccess]
        def timeouts
          @timeouts
        end

        # Waits a maximum timeout time until an element is present on page
        # @param selector [Hash] element selector
        # @param timeout [Integer] maximum time to wait
        def wait_until_present(selector, timeout)
          type, value, options = build_selector(selector, { visible: false, wait: timeout })
          has_selector?(type, value, options)
        end

        # Waits a maximum timeout time until an element is visible on page
        # @param selector [Hash] element selector
        # @param timeout [Integer] maximum time to wait
        def wait_until_visible(selector, timeout)
          type, value, options = build_selector(selector, { visible: true, wait: timeout })
          has_selector?(type, value, options)
        end

        # Waits a maximum timeout time until an element is no longer present on page
        # @param selector [Hash] element selector
        # @param timeout [Integer] maximum time to wait
        def wait_until_not_present(selector, timeout)
          type, value, options = build_selector(selector, { wait: timeout })
          has_no_selector?(type, value, options)
        end

        # Waits a maximum timeout time until an element is no longer visible on page
        # @param selector [Hash] element selector
        # @param timeout [Integer] maximum time to wait
        def wait_until_not_visible(selector, timeout)
          type, value, options = build_selector(selector, { visible: false, wait: timeout })
          has_no_selector?(type, value, options)
        end

        # Generic wait method
        # @param timeout [Integer] max time to wait
        # @param klass [Class] (nil) an optional exception class to retry on error
        # @yield
        def wait_until(timeout, klass = nil, &block)
          default_time = Capybara.default_max_wait_time
          timeout      ||= default_time
          tries        = timeout / default_time
          exceptions   = [Capybara::ElementNotFound, Capybara::ExpectationNotMet]
          exceptions << klass if klass
          Retriable.retriable(on:            exceptions,
                              tries:         tries.ceil,
                              base_interval: default_time) do
            yield
          end
        end

        private

        def build_selector(selector, options)
          type, value, opts = *selector
          options           = opts.merge(options) if opts&.any?
          [type, value, options]
        end
      end
    end
  end
end