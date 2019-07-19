@javascript
Feature: Web reports

  Scenario: Will fail
    When I visit "http://localhost:8090/example"
    Then the web page has text "this text does not exist"