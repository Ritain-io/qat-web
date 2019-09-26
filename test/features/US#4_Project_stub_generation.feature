@issue#4 @github
Feature: Issue #4: CLI for project control: Project stub generation
  In order to easily start a new test project
  As a test developer
  I want to create a new qat-web project stub using the CLI utility


  @test#135
  Scenario Outline: Create a new project
    When I run `qat_web <command> new_project`
    Then the exit status should be 0
    And a directory named "new_project" should exist
    Examples:
      | command |
      | -n      |
      | --new   |

  @test#136
  Scenario: Create a new project without project name
    When I run `qat_web -n`
    Then the exit status should be 1
    And the stderr should contain exactly "Error: No project name given"

  @test#137
  Scenario: Create a new project that already exists
    Given a directory named "my_project"
    When I run `qat_web -n my_project`
    Then the exit status should be 1
    And the stderr should contain exactly "Error: The project 'my_project' already exists"