@us#5 @sinatra_mock @announce-directory @announce-stdout @announce-stderr @announce-output @announce-command @announce-changed-environment
Feature: URL should be printed when there is a web error
  In order to have better debugging
  As a web tester
  I want to know the browser URL when there is a web error

  @test#64
  Scenario: Print URL when web error occurs
    Given I copy the directory named "../../resources/cucumber_project" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake test FEATURE=features/web_failure.feature`
    Then the exit status should be 1
    And the stdout should contain "QAT::Web::Browser: The current URL is http://localhost:8090/example"


  @test#65
  Scenario: Embedded Screenshot in HTML Report when occurs a QAT::Web::Error
    Given I copy the directory named "../../resources/cucumber_project" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake test FEATURE=features/qat_error_failure.feature`
    Then the exit status should be 1
    And the stdout should contain "QAT::Web::Browser: The current URL is http://localhost:8090/example"


  @test#63
  Scenario: Don't embed screenshot in HTML Report with normal error
    Given I copy the directory named "../../resources/cucumber_project" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake test FEATURE=features/normal_failure.feature`
    Then the exit status should be 1
    And the stdout should not contain "QAT::Web::Cucumber: The current URL is http://localhost:8090/example"