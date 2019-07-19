@user_story#9 @selenium_headless
Feature: User Story #275: Configure Firefox profile properties
  As a Web tester,
  In order to  have better debugging,
  I want to add have a profile which exports Firefox's NetPanel


  @test#74
  Scenario: Configure Firefox profile with net exporter plugin
    When I have a "browsers" YAML file with content:
    """
    firefox_profile_netexport:
      browser: firefox
      properties:
        browser.download.folderList: 2
        browser.helperApps.neverAsk.saveToDisk: "application/pdf,application/x-tar-gz"

        extensions.netmonitor.har.contentAPIToken: <%= QAT::Web::Drivers::Firefox::HarExporter::TOKEN %>
        extensions.netmonitor.har.enableAutomation: true
        extensions.netmonitor.har.autoConnect: true

        devtools.netmonitor.har.defaultLogDir: <%= File.join(Dir.pwd, 'public') %>
        devtools.netmonitor.har.includeResponseBodies: true

        webdriver.log.driver: DEBUG
        webdriver.log.file: <%= File.join(Dir.pwd, 'public', 'firefox.log') %>
        plugin.state.java: 0
      addons:
        - har_exporter
      hooks:
        - har_exporter
    """
    And I load drivers from the "browsers.yml" file
    And no exception is raised
    And I ask for a "firefox_profile_netexport" driver
    Then the "Firefox" browser profile properties are:
      | property                                      | type    | value                                                 |
      | browser.download.folderList                   | Integer | 2                                                     |
      | browser.helperApps.neverAsk.saveToDisk        | String  | application/pdf,application/x-tar-gz                  |
      | extensions.netmonitor.har.contentAPIToken     | String  | <%= QAT::Web::Drivers::Firefox::HarExporter::TOKEN %> |
      | extensions.netmonitor.har.enableAutomation    | Boolean | true                                                  |
      | extensions.netmonitor.har.autoConnect         | Boolean | true                                                  |
      | devtools.netmonitor.har.defaultLogDir         | String  | <%= File.join(Dir.pwd, 'public') %>                   |
      | devtools.netmonitor.har.includeResponseBodies | Boolean | true                                                  |
      | webdriver.log.driver                          | String  | DEBUG                                                 |
      | webdriver.log.file                            | String  | <%= File.join(Dir.pwd, 'public', 'firefox.log') %>    |
      | plugin.state.java                             | Integer | 0                                                     |