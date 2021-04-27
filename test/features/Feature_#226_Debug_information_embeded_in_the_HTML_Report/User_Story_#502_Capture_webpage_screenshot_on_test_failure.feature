@epic#199 @feature#226 @user_story#502 @sinatra_mock @announce-directory @announce-stdout @announce-stderr @announce-output @announce-command @announce-changed-environment
Feature: User Story #502: Capture webpage screenshot on test failure
  In order to debug a failing web test
  as a web tester,
  I want to have a screenshot of the webpage's last screen

  @test#1
  Scenario Outline: Save a webpage screenshot on demand
    Given I have a "<browser>" driver
    And I visit "http://localhost:8090/example"
    When I save a browser screenshot
    Then I have a browser screenshot file

  @selenium_headless
    Examples:
      | browser |
      | chrome  |
      | firefox |

  @selenium_headless @test#2
  Scenario: Save a webpage screenshot with same name
    Given I have a "selenium" driver
    And I visit "http://localhost:8090/example"
    And I set screenshot default name to "public/will_be_repeated.png"
    When I save a browser screenshot
    Then no exception is raised
    Then I have a browser screenshot file with name "public/will_be_repeated.png"
    When I save a browser screenshot
    Then an "ArgumentError" exception is raised

### Deprecated exception not raised
#  @test#3
#  Scenario: Try to save a webpage screenshot using an unsupported driver
#    Given I have a "rack_test" driver
#    And I visit "/"
#    When I save a browser screenshot
#    Then no exception is raised
#    But no screenshot was saved

  @test#4
  Scenario: Attached saved screenshot in HTML Report when web error occurs
    Given I copy the directory named "../../resources/cucumber_project" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake test FEATURE=features/web_failure.feature`
    Then the exit status should be 1
    And the stdout should contain "QAT::Web::Browser::Screenshot: Saving screenshot"
    And the stdout should contain "QAT::Web::Browser::Screenshot: Screenshot available"
    And there is a "png" file attached to the HTML report with label "Screenshot"
    ## link is not generated new attach
   # And the "png" link with label "Screenshot" is valid


  @test#5
  Scenario: Attached Screenshot in HTML Report when occurs a QAT::Web::Error
    Given I copy the directory named "../../resources/cucumber_project" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake test FEATURE=features/qat_error_failure.feature`
    Then the exit status should be 1
    And the stdout should contain "QAT::Web::Browser::Screenshot: Saving screenshot"
    And the stdout should contain "QAT::Web::Browser::Screenshot: Screenshot available"
    And there is a "png" file attached to the HTML report with label "Screenshot"
    ## link is not generated new attach
    #And the "png" link with label "Screenshot" is valid


  @test#122
  Scenario: Don't attach screenshot in HTML Report with normal error
    Given I copy the directory named "../../resources/cucumber_project" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake test FEATURE=features/normal_failure.feature`
    Then the exit status should be 1
    And the stdout should not contain "QAT::Web::Browser::Screenshot: Saving screenshot"
    And the stdout should not contain "QAT::Web::Browser::Screenshot: Screenshot available"
    And there is not a "png" file attached to the HTML report with label "Screenshot"
