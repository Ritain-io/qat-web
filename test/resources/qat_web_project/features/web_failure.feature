Feature: Web reports

  Scenario: Will fail with Capybara Error
    When I visit "http://localhost:8090/example"
    Then the web page has text "this text does not exist"