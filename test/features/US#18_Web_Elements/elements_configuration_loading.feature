@web_elements @config_elements
Feature: Load configuration for element locators from file
  In order to easily define web elements
  As a web test developer
  I want to load configurations from a file

  Background: No basic page implementation exists
    Given no page object class is defined

  @test#101
  Scenario: Loading web elements configuration from file
    When I define a page object class named "BasicPageObject" with code:
    """
    elements_file 'resources/config_files/app/login.yml'
    """
    Then no exception is raised
    And the locators defined for "BasicPageObject" are
      | username                         | password                         | login_button                                     |
      | { xpath: "//*[@id='username']" } | { xpath: "//*[@id='password']" } | { xpath: "//button[contains(text(), 'Login')]" } |


  @test#102
  Scenario: Loading web elements configuration from non existing file
    When I define a page object class named "BasicPageObject" with code:
    """
    elements_file 'resources/config_files/app/no_file_here.yml'
    """
    Then an "ArgumentError" exception is raised
    And the exception message is "File 'resources/config_files/app/no_file_here.yml' does not exist!"


  @test#103
  Scenario: Loading web elements configuration from hash
    When I define a page object class named "BasicPageObject" with code:
    """
    elements_config locators: {
                      username: {
                        xpath: "//*[@id='username']"
                      },
                      password: {
                        xpath: "//*[@id='password']"
                      },
                      login_button: {
                        xpath: "//button[contains(text(), 'Login')]"
                      }
                    }
    """
    Then no exception is raised
    And the locators defined for "BasicPageObject" are
      | username                         | password                         | login_button                                     |
      | { xpath: "//*[@id='username']" } | { xpath: "//*[@id='password']" } | { xpath: "//button[contains(text(), 'Login')]" } |


  @test#104
  Scenario: Loading web elements configuration from empty hash
    When I define a page object class named "BasicPageObject" with code:
    """
    elements_config Hash.new
    """
    Then an "ArgumentError" exception is raised
    And the exception message is "Empty or invalid configuration was given for Elements! A hash like configuration is expected!"


  @test#105
  Scenario: Loading web elements configuration from nil
    When I define a page object class named "BasicPageObject" with code:
    """
    elements_config nil
    """
    Then an "ArgumentError" exception is raised
    And the exception message is "Empty or invalid configuration was given for Elements! A hash like configuration is expected!"


  @test#106
  Scenario: Loading web elements configuration from Array
    When I define a page object class named "BasicPageObject" with code:
    """
    elements_config [:username, { xpath: "//*[@id='username']" }]
    """
    Then an "ArgumentError" exception is raised
    And the exception message is "Empty or invalid configuration was given for Elements! A hash like configuration is expected!"


  @test#107
  Scenario: Loading web elements configuration from String
    When I define a page object class named "BasicPageObject" with code:
    """
    elements_config "username, { xpath: '//*[@id='username']' }"
    """
    Then an "ArgumentError" exception is raised
    And the exception message is "Empty or invalid configuration was given for Elements! A hash like configuration is expected!"


  @test#108
  Scenario: Loading web elements configuration from cache
    When I define a page object class named "BasicPageObject" with code:
    """
    elements_config QAT.configuration[:app][:login]
    """
    Then no exception is raised
    And the locators defined for "BasicPageObject" are
      | username                         | password                         | login_button                                     |
      | { xpath: "//*[@id='username']" } | { xpath: "//*[@id='password']" } | { xpath: "//button[contains(text(), 'Login')]" } |
