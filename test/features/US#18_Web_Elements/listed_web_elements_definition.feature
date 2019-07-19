@web_elements @elements_definition @elements_list_definition
Feature: Definition of single web elements
  In order to easily define multiple web elements
  As a web test developer
  I want to define web element through a list of names referencing configuration

  Background: No basic page implementation exists
    Given no page object class is defined


  @test#110
  Scenario: Web element list definition
    When I define a page object class named "BasicPageObject" with code:
    """
    elements_config QAT.configuration[:app][:login]

    web_elements :username, :password, :login_button
    """
    Then no exception is raised
    And the following methods are defined for the "BasicPageObject" instance
      | username                        |
      | selector_username               |
      | config_username                 |
      | wait_until_username_visible     |
      | wait_until_username_present     |
      | wait_while_username_visible     |
      | wait_while_username_present     |
      | password                        |
      | selector_password               |
      | config_password                 |
      | wait_until_password_visible     |
      | wait_until_password_present     |
      | wait_while_password_visible     |
      | wait_while_password_present     |
      | login_button                    |
      | selector_login_button           |
      | config_login_button             |
      | wait_until_login_button_visible |
      | wait_until_login_button_present |
      | wait_while_login_button_visible |
      | wait_while_login_button_present |
