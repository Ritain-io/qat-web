@epic#199 @feature#226 @user_story#505 @sinatra_mock @announce-directory @announce-stdout @announce-stderr @announce-output @announce-command @announce-changed-environment
Feature: User Story #505: Capture HTML page dump on test failure
  In order to debug a failing web test
  as a web tester,
  I want to have a HTML page dump of the last webpage

  @test#7
  Scenario Outline: Save a webpage HTML dump on demand
    Given I have a "<browser>" driver
    And I visit "<page>"
    When I save a browser HTML dump
    Then no exception is raised
    And I have a browser HTML dump file

  @selenium_headless
    Examples:
      | browser | page                          |
      | chrome  | http://localhost:8090/example |
      | firefox | http://localhost:8090/example |

    Examples:
      | browser   | page                          |
      | rack_test | /                             |

  @selenium_headless @test#8
  Scenario: Save a webpage HTML dump with same name
    Given I have a "selenium" driver
    And I visit "http://localhost:8090/example"
    And I set HTML dump default name to "public/will_be_repeated.html"
    When I save a browser HTML dump
    Then no exception is raised
    Then I have a browser HTML dump file with name "public/will_be_repeated.html"
    When I save a browser HTML dump
    Then an "ArgumentError" exception is raised


  @test#10
  Scenario: Embedded HTML dump in HTML Report when occurs a Capybara::CapybaraError
    Given I copy the directory named "../../resources/cucumber_project" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake test FEATURE=features/web_failure.feature`
    Then the exit status should be 1
    And the stdout should contain "QAT::Web::Browser::HTMLDump: Saving HTML dump"
    And the stdout should contain "QAT::Web::Browser::HTMLDump: HTML dump available"
    And there is a "html" file attached to the HTML report with label "HTML dump"
    ## link is not generated new attach
    #And the "html" link with label "HTML dump" is valid


  @test#11
  Scenario: Embedded HTML dump in HTML Report when occurs a QAT::Web::Error
    Given I copy the directory named "../../resources/cucumber_project" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake test FEATURE=features/qat_error_failure.feature`
    Then the exit status should be 1
    And the stdout should contain "QAT::Web::Browser::HTMLDump: Saving HTML dump"
    And the stdout should contain "QAT::Web::Browser::HTMLDump: HTML dump available"
    And there is a "html" file attached to the HTML report with label "HTML dump"
     ## link is not generated new attach
    #And the "html" link with label "HTML dump" is valid


  @test#6
  Scenario: Don't embed screenshot in HTML Report with normal error
    Given I copy the directory named "../../resources/cucumber_project" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake test FEATURE=features/normal_failure.feature`
    Then the exit status should be 1
    And the stdout should not contain "QAT::Web::Browser::HTMLDump: Saving HTML dump"
    And the stdout should not contain "QAT::Web::Browser::HTMLDump: HTML dump available"
    And there is not a "html" file attached to the HTML report with label "HTML dump"
