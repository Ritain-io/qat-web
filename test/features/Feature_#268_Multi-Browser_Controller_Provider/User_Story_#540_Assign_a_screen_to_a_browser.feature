@epic#199 @feature#268 @user_story#540
Feature: User Story #540: Assign a screen to a browser
  In order to reproduce different web testing conditions related to screen size
  as a web test developer,
  I want to assign a screen to a browser

  @test#27
  Scenario Outline: Open browsers with associated screen
    Given I have a "screens" YAML file with content:
    """
    my_screen:
      resolution:
        width: <width>
        height: <height>
        depth: <depth>
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
    Then the driver is loaded with screen "my_screen"
    And the current screen has dimensions:
      | width   | height   | depth   |
      | <width> | <height> | <depth> |

    Examples:
      | browser   | width | height | depth |
      | firefox   | 800   | 600    | 24    |
      | chrome    | 1200  | 800    | 24    |


  @test#68
  Scenario Outline: Open browsers with associated screen without depth
    Given I have a "browsers" YAML file with content:
    """
    my_<browser>:
      browser: <browser>
      screen: my_<browser>_screen
    """
    And I load drivers from the "browsers.yml" file
    And I have a "screens" YAML file with content:
    """
    my_<browser>_screen:
      resolution:
        width: <width>
        height: <height>
    """
    And I load virtual screen definitions
    When I ask for a "my_<browser>" driver
    Then the driver is loaded with screen "my_<browser>_screen"
    And the current screen has dimensions:
      | width   | height   | depth |
      | <width> | <height> | 24    |

    Examples:
      | browser   | width | height |
      | firefox   | 1200  | 800    |
      | chrome    | 800   | 600    |
