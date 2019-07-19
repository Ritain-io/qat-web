@epic#199 @feature#268 @user_story#492
Feature: User Story #492: Maximize browser window
  In order to use all the available screen
  as a web test developer,
  I want to have a fully maximized browser window

  @test#26
  Scenario Outline: Screen is maximized
    Given I have a "screens" YAML file with content:
    """
    my_screen:
      resolution:
        width: <width>
        height: <height>
        depth: 24
    """
    And I load virtual screen definitions
    And I have a "browsers" YAML file with content:
    """
    my_<browser>:
      browser: <browser>
      screen: my_screen
    """
    And I load drivers from the "browsers.yml" file
    When I ask for a "my_<browser>" driver
    And the current browser window has dimensions:
      | width   | height   |
      | <width> | <height> |

  @selenium_headless
    Examples:
      | browser   | width | height |
      | firefox   | 800   | 600    |
      | chrome    | 1200  | 800    |