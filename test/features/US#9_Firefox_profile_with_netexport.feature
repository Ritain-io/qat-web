@us#9 @sinatra_mock @announce-directory @announce-stdout @announce-stderr @announce-output @announce-command @announce-changed-environment
Feature: Firefox_profile_with_netexports
  As a Web tester,
  In order to have better debugging,
  I want to have a profile which exports Firefox's NetPanel

  @disabled @test#121
  Scenario: Use a firefox profile with net exports
    Given I copy the directory named "../../resources/qat_web_project" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable                | value                     |
      | CUCUMBER_FORMAT         |                           |
      | CUCUMBER_OPTS           |                           |
      | QAT_WEB_BROWSER_PROFILE | firefox_profile_netexport |
    When I run `rake test FEATURE=features/qat_error_failure.feature`
    Then the exit status should be 1
    When I cd to "public"
    Then a file matching %r<firefox.log> should exist
    Then a file matching %r<http_requests_\d{2}-\d{2}-\d{2}T\d{2}-\d{2}-\d{2}.har> should exist
