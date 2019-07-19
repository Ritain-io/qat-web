@epic#199 @feature#252 @user_story#281
Feature: User Story #281: Configure virtual screen
  In order to use different browser conditions
  As a web tester
  I want to configure a virtual screen

  Background: Check environment variables
    Given I unset the "QAT_DISPLAY" environment variable

  @test#55
  Scenario: Headless configuration only with mandatory options
    Given I have a "screens" YAML file with content:
    """
    default:
      resolution:
        width: 800
        height: 600
    """
    When I load virtual screen definitions
    Then no exception is raised
    And I request a virtual screen
    And a virtual screen is created


  @test#56
  Scenario: Screen configuration with all options
    Given I have a "screens" YAML file with content:
    """
    default:
      resolution:
        width: 800
        height: 600
        depth: 24
    """
    When I load virtual screen definitions
    And I request a virtual screen
    Then a virtual screen is created

  @test#57
  Scenario: Disable virtual screen usage
    Given I set the "QAT_DISPLAY" environment variable with value "none"
    When I request a virtual screen
    Then a virtual screen is not created


  @test#58
  Scenario: Invalid virtual screen configuration: no height
    Given I have a "screens" YAML file with content:
    """
    default:
      resolution:
        width: 800
    """
    When I load virtual screen definitions
    Then an "QAT::Web::Screen::Loader::InvalidConfigurationError" exception is raised
    When I request a virtual screen
    Then a virtual screen is created


  @test#59
  Scenario: Invalid virtual screen configuration: no width
    Given I have a "screens" YAML file with content:
    """
    default:
      resolution:
        height: 600
    """
    When I load virtual screen definitions
    Then an "QAT::Web::Screen::Loader::InvalidConfigurationError" exception is raised
    When I request a virtual screen
    Then a virtual screen is created


  @test#60
  Scenario: Invalid virtual screen configuration: no height nor width
    Given I have a "screens" YAML file with content:
    """
    default:
      resolution:
    """
    When I load virtual screen definitions
    Then an "QAT::Web::Screen::Loader::InvalidConfigurationError" exception is raised
    When I request a virtual screen
    Then a virtual screen is created


  @test#61
  Scenario: Invalid virtual screen configuration: no resolution group
    Given I have a "screens" YAML file with content:
    """
    default:
    """
    When I load virtual screen definitions
    Then an "QAT::Web::Screen::Loader::InvalidConfigurationError" exception is raised
    When I request a virtual screen
    Then a virtual screen is created


  @test#62
  Scenario: Invalid virtual screen configuration: no default group
    Given I have a "screens" YAML file with content:
    """
    """
    When I load virtual screen definitions
    Then no exception is raised
    When I request a virtual screen
    Then a virtual screen is created

  @test#73
  Scenario: Headless configuration using ERB tags
    Given I have a "screens" YAML file with content:
    """
    default:
      resolution:
        width: <%= [1200, 1000, 800].sample %>
        height: 600
    """
    When I load virtual screen definitions
    Then no exception is raised
    And I request a virtual screen
    And a virtual screen is created
