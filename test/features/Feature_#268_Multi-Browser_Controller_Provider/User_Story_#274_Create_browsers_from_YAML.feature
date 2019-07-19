@epic#199 @feature#268 @user_story#274 @sinatra_mock
Feature: User Story #274: Create browsers from YAML
  In order to test different browser
  As a web tester
  I want to configure different drivers for different browsers


  @test#18 @selenium_headless
  Scenario: Create a driver from YAML
    Given I ask for a "my_firefox" driver
    And an "ArgumentError" exception is raised
    And I have a "browsers" YAML file with content:
    """
    my_firefox:
      browser: firefox
    """
    And I load drivers from the "browsers.yml" file
    When I ask for a "my_firefox" driver
    Then no exception is raised
    And I visit "http://localhost:8090/example"
    And the web page has text "Example Domain"


  @test#19
  Scenario: Create a driver from YAML without browser key
    Given I have a "browsers" YAML file with content:
    """
    invalid_browser:
      foo: bar
    """
    When I load drivers from the "browsers.yml" file
    Then an "QAT::Web::Browser::Loader::InvalidConfigurationError" exception is raised
    And I ask for a "invalid_browser" driver
    And an "ArgumentError" exception is raised

  @selenium_headless @test#67
  Scenario: Create a driver from YAML using ERB tags
    Given I ask for a "my_firefox" driver
    And an "ArgumentError" exception is raised
    And I have a "browsers" YAML file with content:
    """
    my_dynamic_driver:
      browser: <%= ['firefox','chrome'].sample %>
    """
    And I load drivers from the "browsers.yml" file
    When I ask for a "my_dynamic_driver" driver
    Then no exception is raised
    And I visit "http://localhost:8090/example"
    And the web page has text "Example Domain"
