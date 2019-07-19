@feature#370 @user_story#511 @selenium_headless @sinatra_mock
Feature: User Story #511: Configure Chrome profile properties
  In order to use different Chrome configurations
  As a web tester
  I want to configure the profile properties in YAML


  @chrome_pdf @test#76
  Scenario: Configure Chrome profile properties
    When I have a "browsers" YAML file with content:
    """
    chrome_with_profile:
      browser: chrome
      properties:
        intl.accept_languages: en
        download.default_directory: /tmp/chrome
        download.prompt_for_download: false
        plugins.plugins_disabled: ['Chrome PDF Viewer']
    """
    And I load drivers from the "browsers.yml" file
    And I ask for a "chrome_with_profile" driver
    Then download file to new default directory:
      | host                   | file_name           | directory   |
      | http://localhost:8090/ | pdf_for_testing.pdf | /tmp/chrome |