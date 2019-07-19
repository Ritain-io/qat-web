@web_elements @collection_definition @elements_single_definition
Feature: Definition of collection of web elements
  In order to easily use web elements
  As a web test developer
  I want to define web element through a name and a configuration

  Background: No basic page implementation exists
    Given no page object class is defined


  @test#124
  Scenario: Single web element definition with referenced configuration
    When I define a page object class named "BasicPageObject" with code:
    """
    elements_config QAT.configuration[:app][:page]

    web_collection :table_rows, elements[:locators][:table_rows]
    """
    Then no exception is raised
    And the following methods are defined for the "BasicPageObject" instance
      | table_rows                    |
      | selector_table_rows           |
      | config_table_rows             |
      | wait_until_table_rows_visible |
      | wait_until_table_rows_present |
      | wait_while_table_rows_visible |
      | wait_while_table_rows_present |


  @test#125
  Scenario: Single web element definition with explicit configuration
    When I define a page object class named "BasicPageObject" with code:
    """
    elements_config QAT.configuration[:app][:page]

    web_collection :table_rows, { xpath: "//*[@id='table_rows']" }
    """
    Then no exception is raised
    And the following methods are defined for the "BasicPageObject" instance
      | table_rows                    |
      | selector_table_rows           |
      | config_table_rows             |
      | wait_until_table_rows_visible |
      | wait_until_table_rows_present |
      | wait_while_table_rows_visible |
      | wait_while_table_rows_present |


  @test#126
  Scenario: Single web element definition without configuration
    When I define a page object class named "BasicPageObject" with code:
    """
    elements_config QAT.configuration[:app][:page]

    web_collection :table_headers
    """
    Then no exception is raised
    And the following methods are defined for the "BasicPageObject" instance
      | table_headers                    |
      | selector_table_headers           |
      | config_table_headers             |
      | wait_until_table_headers_visible |
      | wait_until_table_headers_present |
      | wait_while_table_headers_visible |
      | wait_while_table_headers_present |


  @test#127
  Scenario: Single web element definition with non existing configuration returns the correct configuration
    When I define a page object class named "BasicPageObject" with code:
    """
    elements_config QAT.configuration[:app][:page]

    web_collection :table_rows, elements[:nothing_here]
    """
    Then an "ArgumentError" exception is raised
    And the exception message is "Configuration given for element 'table_rows' is nil!"


  @test#128
  Scenario: Single web element definition for non existing element configuration
    When I define a page object class named "BasicPageObject" with code:
    """
    elements_config QAT.configuration[:app][:page]

    web_collection :this_is_a_fake_element
    """
    Then an "ArgumentError" exception is raised
    And the exception message is "No configuration found for web element 'this_is_a_fake_element', please check definition"
