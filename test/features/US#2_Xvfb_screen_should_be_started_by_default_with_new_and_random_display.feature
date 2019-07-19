@us#2
Feature: Xvfb screen should be started by default with new and random display
  In order to use different browser conditions
  As a web tester
  I want to never reuse a virtual screen by default

  Background: Check environment variables
    Given I unset the "QAT_DISPLAY" environment variable
    And I reset the screen definition list

  @test#117
  Scenario: Start two default screens and they don't have the same number
    Given I request a virtual screen
    When a virtual screen is created
    Then I record the virtual screen number
    Given I close the current virtual screen
    And I request a virtual screen
    And a virtual screen is created
    When I record the virtual screen number
    Then the virtual screen number is not the same as the old one

  @test#118
  Scenario: Start default screen after another default screen started and there is no reuse
    Given I request a virtual screen
    When a virtual screen is created
    Then I record the virtual screen number
    Given I request a virtual screen
    And a virtual screen is created
    When I record the virtual screen number
    Then the virtual screen number is not the same as the old one
    And the virtual screen has the reuse option disabled