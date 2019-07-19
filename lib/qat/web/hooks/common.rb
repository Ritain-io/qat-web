module QAT
  module Web
    module Hooks
      module Common
        def scenario_tag(scenario)
          tag = QAT[:current_test_run_id] if QAT.respond_to?(:[])

          tag ||= Time.now.strftime("%H%M%S%L")

          "#{scenario.name.parameterize}_#{tag}"
        end

        module_function :scenario_tag
      end
    end
  end
end