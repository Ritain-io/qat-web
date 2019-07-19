@web_elements @config_timeouts
Feature: Load configuration for element locators from file
  In order to easily handle web waiting timeouts
  As a web test developer
  I want to load configurations from a file

  Background: No basic page implementation exists
    Given no page object class is defined

  @test#111
  Scenario: Loading timeout configuration from file
    When I define a page object class named "BasicPageObject" with code:
    """
    timeouts_file 'resources/config_files/timeouts.yml'
    """
    Then no exception is raised
    And the timeouts defined for "BasicPageObject" are
      | small | medium | big | huge | go_grab_a_coffee | bathroom_break | om_style |
      | 5     | 15     | 30  | 60   | 120              | 360            | 600      |


  @test#112
  Scenario: Loading a non existing timeout configuration file
    When I define a page object class named "BasicPageObject" with code:
    """
    timeouts_file 'resources/config_files/no_file_here.yml'
    """
    Then an "ArgumentError" exception is raised
    And the exception message is "File 'resources/config_files/no_file_here.yml' does not exist!"


  @test#113
  Scenario: Loading timeout configuration from hash
    When I define a page object class named "BasicPageObject" with code:
    """
    timeouts_config small: 5,
                    medium: 15,
                    big: 30,
                    huge: 60,
                    go_grab_a_coffee: 120,
                    bathroom_break: 360,
                    om_style: 600
    """
    Then no exception is raised
    And the timeouts defined for "BasicPageObject" are
      | small | medium | big | huge | go_grab_a_coffee | bathroom_break | om_style |
      | 5     | 15     | 30  | 60   | 120              | 360            | 600      |


  @test#114
  Scenario: Loading timeout configuration from nil
    When I define a page object class named "BasicPageObject" with code:
    """
    timeouts_config nil
    """
    Then an "ArgumentError" exception is raised
    And the exception message is "Empty or invalid configuration was given for Timeouts! A hash like configuration is expected!"


  @test#115
  Scenario: Loading timeout configuration from Array
    When I define a page object class named "BasicPageObject" with code:
    """
    timeouts_config [:small, 5, :medium, 15]
    """
    Then an "ArgumentError" exception is raised
    And the exception message is "Empty or invalid configuration was given for Timeouts! A hash like configuration is expected!"


  @test#116
  Scenario: Loading timeout configuration from String
    When I define a page object class named "BasicPageObject" with code:
    """
    timeouts_config "small, 5, medium, 15"
    """
    Then an "ArgumentError" exception is raised
    And the exception message is "Empty or invalid configuration was given for Timeouts! A hash like configuration is expected!"

