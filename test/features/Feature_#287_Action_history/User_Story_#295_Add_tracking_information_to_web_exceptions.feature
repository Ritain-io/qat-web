@epic#199 @feature#287 @user_story#295 @selenium_headless @sinatra_mock
Feature: User Story #295: Track last configuration access
  In order to have detailed information about test failures
  as a web tester,
  I want to have information about configuration access in exceptions

  @test#35
  Scenario: Enrichment of QAT::Web::Error exceptions
    Given I have accessed configuration:
      | type  | value             |
      | xpath | /html/body/div/h1 |
    When a QAT::Web::Error exception is raised with message "this is a test exception!"
    Then the enriched exception message should have text:
  """
  this is a test exception!
  QAT::Web last access to configuration was '{"type"=>"xpath", "value"=>"/html/body/div/h1"}'
  """


  @test#36
  Scenario: Enrichment of Capybara::CapybaraError exceptions
    Given I have accessed configuration:
      | type  | value             |
      | xpath | /html/body/div/h1 |
    When a Capybara::CapybaraError exception is raised with message "this is a test exception!"
    Then the enriched exception message should have text:
    """
    this is a test exception!
    QAT::Web last access to configuration was '{"type"=>"xpath", "value"=>"/html/body/div/h1"}'
    """

  @test#37
  Scenario: Enriched Capybara::CapybaraError descendant exception while navigating
    Given I have a "selectors" YAML file with content:
    """
    example:
      title:
        type: xpath
        value: /html/body/div/h2
    """
    And I load the "selectors" YAML file with indifferent access
    And I have a "selenium" driver
    And I visit "http://localhost:8090/example"
    When I find the element from configuration "title"
    Then a "Capybara::ElementNotFound" exception is raised
    And the enriched exception message should have text:
    """
    Unable to find xpath "/html/body/div/h2"
    QAT::Web last access to configuration was '{"type"=>"xpath", "value"=>"/html/body/div/h2"}'
    """