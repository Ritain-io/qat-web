@javascript
Feature: HTML Dump tests

  Scenario: Failure with a QAT::Web::Error exception
    When I visit "http://localhost:8090/example"
    Then a QAT::Web::Error exception is raised with message "this is a test exception!"
