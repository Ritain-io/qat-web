@issue#4 @github
Feature: Issue #4: CLI for project control: Project stub generation
  In order to easily start a new test project
  As a test developer
  I want to create a new qat-web project stub using the CLI utility


  @test#135
  Scenario Outline: Create a new qat web project
    Given I run `qat <command> new_project -a web`
    And the exit status should be 0
    Then a directory named "new_project" should exist
    Examples:
      | command |
      | -n      |
      | --new   |

  @test#136
  Scenario: Create a new project without project name
    Given I run `qat -n -a web`
    And the exit status should be 1
    Then the stderr should contain exactly "Error: No project name given"

  @test#137
  Scenario: Create a new project that already exists
    Given a directory named "my_project"
    When I run `qat -n my_project -a web`
    Then the exit status should be 1
    And the stderr should contain exactly "Error: The project 'my_project' already exists"


  @test#138
  Scenario: Create a new qat web project and validate test runs
    Given I run `qat -n new_project -a web`
    And the exit status should be 0
    And a directory named "new_project" should exist
    When I cd to "new_project"
    And I set the environment variables to:
      | variable                | value                     |
      | CUCUMBER_FORMAT         |                           |
      | CUCUMBER_OPTS           |                           |
      | QAT_WEB_BROWSER_PROFILE | firefox_profile_netexport |
    And I run `rake qat:test:feature[web_example]`
    Then the output should contain "Loaded home page with URL:"
    And the exit status should be 0