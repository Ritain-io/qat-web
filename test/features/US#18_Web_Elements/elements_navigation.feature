@web_elements @sinatra_mock @announce-directory @announce-stdout @announce-stderr @announce-output @announce-command @announce-changed-environment
Feature: Web Elements Navigation Tests

  @test#109
  Scenario: Run navigation scenarios using the Web Elements features
    Given I copy the directory named "../../resources/qat_web_project" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable           | value        |
      | CUCUMBER_FORMAT    |              |
      | CUCUMBER_OPTS      |              |
    When I run `rake test FEATURE=features/web_elements_navigation.feature`
    Then the exit status should be 0

