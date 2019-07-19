Then(/^the "([^"]*)" browser profile properties are:$/) do |browser, table|
  expected = table.hashes.each_with_object({}) do |row, hash|
    name, value, type = row["property"], ERB.new(row["value"]).result, row["type"]
    hash[name]        = value.to_type(type.constantize)
  end

  current = case browser.downcase.to_sym
            when :firefox
              profile      = Capybara.current_session.driver.browser.send(:bridge).capabilities[:profile]
              prefs        = Dir.glob(File.join(profile, 'user.js'))
              content      = File.read(prefs.first)
              arr_settings = content.split(';').map do |setting|
                m             = setting.match(/user_pref\(([^,]*),(.*)\)/)
                _, key, value = m.to_a
                [key.to_s.delete('""').strip, value.to_s.delete('""').strip]
              end

              Hash[arr_settings]
            when :chrome
              Capybara.current_session.driver.browser.send(:bridge) #TODO inacabado
            else
              pending
            end

  equal_values = expected.all? do |property, expected_value|
    current[property].to_s == expected_value.to_s
  end

  log.debug 'Properties'
  log.debug current

  unmatched = expected.select { |k, v| current[k].to_s != v.to_s }

  message = unmatched.map do |k, v|
    "Property '#{k}': Expected: '#{v}' (#{v.class}), Actual: '#{current[k]}' (#{current[k].class})"
  end

  assert(equal_values, "Unmatched:\n#{message.join("\n")}")
end


Then(/^download file to new default directory:$/) do |table|
  # table is a table.hashes.keys # => [:host, :file_name, :directory]
  download_paths = table.hashes.first

  log.debug { "Downloading #{download_paths[:host]}/#{download_paths[:file_name]}" }

  Retriable.retriable intervals: Array.new(10, 1) do
    Capybara.current_session.driver.browser.get "#{download_paths[:host]}/#{download_paths[:file_name]}"
  end

  Retriable.retriable on:            Minitest::Assertion,
                      tries:         20,
                      base_interval: 3,
                      multiplier:    1,
                      rand_factor:   1,
                      on_retry:      (proc do |_, try, _, _|
                        log.debug { "Waiting for file download to finish ##{try}" }

                        if File.exist?("#{download_paths[:directory]}/#{download_paths[:file_name]}.crdownload")
                          log.debug { "Partial download file present!" }
                        else
                          files = Dir.glob("#{download_paths[:directory]}/*.pdf")
                          if files.any?
                            log.debug { "No partial download file was found in:" }
                            log.debug files
                          end
                        end
                      end) do
    assert File.exist?("#{download_paths[:directory]}/#{download_paths[:file_name]}"),
           "No file found at location #{download_paths[:directory]}/#{download_paths[:file_name]}"
  end
end