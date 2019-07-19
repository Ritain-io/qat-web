@web_elements @elements_definition @elements_single_definition
Feature: Definition of single web elements
  In order to easily use web elements
  As a web test developer
  I want to define web element through a name and a configuration

  Background: No basic page implementation exists
    Given no page object class is defined


  @test#95
  Scenario: Single web element definition with referenced configuration
    When I define a page object class named "BasicPageObject" with code:
    """
    elements_config QAT.configuration[:app][:login]

    web_element :username, elements[:locators][:username]
    """
    Then no exception is raised
    And the following methods are defined for the "BasicPageObject" instance
      | username                    |
      | selector_username           |
      | config_username             |
      | wait_until_username_visible |
      | wait_until_username_present |
      | wait_while_username_visible |
      | wait_while_username_present |


  @test#96
  Scenario: Single web element definition with explicit configuration
    When I define a page object class named "BasicPageObject" with code:
    """
    elements_config QAT.configuration[:app][:login]

    web_element :username, { xpath: "//*[@id='username']" }
    """
    Then no exception is raised
    And the following methods are defined for the "BasicPageObject" instance
      | username                    |
      | selector_username           |
      | config_username             |
      | wait_until_username_visible |
      | wait_until_username_present |
      | wait_while_username_visible |
      | wait_while_username_present |


  @test#97
  Scenario: Single web element definition without configuration
    When I define a page object class named "BasicPageObject" with code:
    """
    elements_config QAT.configuration[:app][:login]

    web_element :password
    """
    Then no exception is raised
    And the following methods are defined for the "BasicPageObject" instance
      | password                    |
      | selector_password           |
      | config_password             |
      | wait_until_password_visible |
      | wait_until_password_present |
      | wait_while_password_visible |
      | wait_while_password_present |


  @test#98
  Scenario: Single web element definition with non existing configuration returns the correct configuration
    When I define a page object class named "BasicPageObject" with code:
    """
    elements_config QAT.configuration[:app][:login]

    web_element :username, elements[:nothing_here]
    """
    Then an "ArgumentError" exception is raised
    And the exception message is "Configuration given for element 'username' is nil!"


  @test#99
  Scenario: Single web element definition for non existing element configuration
    When I define a page object class named "BasicPageObject" with code:
    """
    elements_config QAT.configuration[:app][:login]

    web_element :this_is_a_fake_element
    """
    Then an "ArgumentError" exception is raised
    And the exception message is "No configuration found for web element 'this_is_a_fake_element', please check definition"


  @test#100
  Scenario: Single web element definition with invalid selector type configuration
    When I define a page object class named "BasicPageObject" with code:
    """
    elements_config QAT.configuration[:app][:bad_type]

    web_element :username, elements[:locators][:username]
    """
    Then an "QAT::Web::Elements::Selector::InvalidConfigurationError" exception is raised
    And the exception message contains "Invalid configuration found:"
