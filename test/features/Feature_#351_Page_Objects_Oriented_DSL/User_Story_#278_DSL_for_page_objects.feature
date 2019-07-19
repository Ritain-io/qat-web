@epic#199 @feature#351 @user_story#278
Feature: User Story #278: DSL for page objects
  In order to easily use a page objects pattern
  As a web test developer
  I want to have a DSL for defining actions

  Background: No basic page implementation exists
    Given no page object class is defined

  @test#38
  Scenario: Create empty page object imlementation
    When I define an empty page object class named "BasicPageObject"
    Then no exception is raised

  @test#39
  Scenario: Page object implementation with value accessor
    When I define a page object class named "BasicPageObject" with code:
    """
    get_value "foo" do
      :bar
    end
    """
    Then no exception is raised
    And the defined values for "BasicPageObject" are
      | foo |
    Given I have a "BasicPageObject" page instance
    When I call the instance method "foo"
    Then the method returns ":bar"
    When I redefine a page object class named "BasicPageObject" with code:
    """
    get_value "foo2" do
      nil
    end
    """
    Then no exception is raised
    And the defined values for "BasicPageObject" are
      | foo  |
      | foo2 |
    Given I have a "BasicPageObject" page instance
    When I call the instance method "foo2"
    Then the method returns "nil"

  @test#40
  Scenario: Page object implementation with action that returns one class
    Given I define an empty page object class named "AnotherPageObject"
    When I define a page object class named "BasicPageObject" with code:
    """
    action "go", returns: AnotherPageObject do
      AnotherPageObject.new
    end
    """
    Then no exception is raised
    And the defined actions for "BasicPageObject" are
      | name | returns           |
      | go   | AnotherPageObject |
    Given I have a "BasicPageObject" page instance
    When I call the instance method "go"
    Then the method returns an instance of "AnotherPageObject"

  @test#41
  Scenario: Page object implementation with action that may return one of various classes
    Given I define an empty page object class named "AnotherPageObject"
    And I define an empty page object class named "YetAnotherPageObject"
    When I define a page object class named "BasicPageObject" with code:
    """
    action "go2", returns: [AnotherPageObject, YetAnotherPageObject] do
      YetAnotherPageObject.new
    end
    """
    Then no exception is raised
    And the defined actions for "BasicPageObject" are
      | name | returns                                   |
      | go2  | [AnotherPageObject, YetAnotherPageObject] |
    Given I have a "BasicPageObject" page instance
    When I call the instance method "go2"
    Then the method returns an instance of "YetAnotherPageObject"

  @test#42
  Scenario: Page object implementation with action that returns empty array
    Given I define an empty page object class named "AnotherPageObject"
    When I define a page object class named "BasicPageObject" with code:
    """
    action "go", returns: [] do
      AnotherPageObject.new
    end
    """
    Then an "TypeError" exception is raised

  @test#43
  Scenario: Page object implementation with action that returns invalid class
    When I define a page object class named "BasicPageObject" with code:
    """
    action "go", returns: Hash do
      {}
    end
    """
    Then an "TypeError" exception is raised

  @test#44
  Scenario: Page object implementation with action with no returns definition
    When I define a page object class named "BasicPageObject" with code:
    """
    action "go", {} do
      {}
    end
    """
    Then an "TypeError" exception is raised

  @test#45
  Scenario: Page object implementation with action with returns definition as an instance of a class
    When I define a page object class named "BasicPageObject" with code:
    """
    action "go", returns: {} do
      {}
    end
    """
    Then an "TypeError" exception is raised

  @bug#6 @test#70
  Scenario: Actions are inherited
    Given I define an empty page object class named "AnotherPageObject"
    When I define a page object class named "BasicPageObject" with code:
    """
    action "go", returns: AnotherPageObject do
      AnotherPageObject.new
    end
    """
    Then no exception is raised
    When I define a page object class as:
    """
    class SubPageObject < BasicPageObject;end
    """
    Then no exception is raised
    And the defined actions for "SubPageObject" are
      | name | returns           |
      | go   | AnotherPageObject |
    Given I have a "SubPageObject" page instance
    When I call the instance method "go"
    Then the method returns an instance of "AnotherPageObject"


  @bug#6 @test#71
  Scenario: Values are inherited
    Given I define a page object class named "BasicPageObject" with code:
    """
    get_value "foo" do
      :bar
    end
    """
    And no exception is raised
    When I define a page object class as:
    """
    class SubPageObject < BasicPageObject;end
    """
    Then no exception is raised
    And the defined values for "SubPageObject" are
      | foo |
    Given I have a "SubPageObject" page instance
    When I call the instance method "foo"
    Then the method returns ":bar"
