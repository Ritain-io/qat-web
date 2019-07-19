@feature#370 @user_story#275 @selenium_headless
Feature: User Story #275: Configure Firefox profile properties
  In order to use different Firefox configurations
  As a web tester
  I want to configure the profile properties in YAML


  @test#75
  Scenario: Configure Firefox profile properties
    When I have a "browsers" YAML file with content:
    """
    firefox_with_profile:
      browser: firefox
      properties:
        browser.download.folderList: 2
        browser.helperApps.neverAsk.saveToDisk: "application/pdf,application/x-tar-gz"
    """
    And I load drivers from the "browsers.yml" file
    And I ask for a "firefox_with_profile" driver
    Then the "Firefox" browser profile properties are:
      | property                               | type    | value                                |
      | browser.download.folderList            | Integer | 2                                    |
      | browser.helperApps.neverAsk.saveToDisk | String  | application/pdf,application/x-tar-gz |

