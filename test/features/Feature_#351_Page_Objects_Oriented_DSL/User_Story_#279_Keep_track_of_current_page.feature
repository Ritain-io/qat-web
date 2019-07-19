@epic#199 @feature#351 @user_story#279
Feature: User Story #279: Keep track of current page
  In order to easily use a page objects pattern
  As a web test developer
  I want to track the current page automatically

  Background: No basic page implementation exists
    Given no page object class manager is defined
    And no page object class is defined
    And I define an empty page object class named "MyPage"
    And I define a page object class as:
    """
    class StartPage < MyPage;end
    class HomePage < MyPage

      action :restart, returns: StartPage do
        StartPage.new
      end

      get_value :now do
        "I'm at the home page"
      end
    end
    """
    And I define a page object class as:
    """
    class StartPage < MyPage

      action :start, returns: HomePage do
        HomePage.new
      end

      get_value :now do
        "I'm at the start page"
      end
    end
    """

  @test#46
  Scenario: Manager initial page is as defined
    When I define a page object manager class as:
    """
    class MySite < QAT::Web::PageManager

      manages MyPage
      initial_page StartPage

    end
    """
    Then no exception is raised
    When I start the page manager "MySite"
    Then no exception is raised
    And the current page is a "StartPage"

  @test#47
  Scenario: Manager track page after an action is executed
    Given I define a page object manager class as:
    """
    class MySite < QAT::Web::PageManager

      manages MyPage
      initial_page StartPage

    end
    """
    And I start the page manager "MySite"
    And no exception is raised
    When I use dsl method "start"
    Then the current page is a "HomePage"
    When I use dsl method "restart"
    Then the current page is a "StartPage"
    When I use dsl method "start"
    Then the current page is a "HomePage"

  @test#48
  Scenario: Manager track page after a value getter is executed
    Given I define a page object manager class as:
    """
    class MySite < QAT::Web::PageManager

      manages MyPage
      initial_page StartPage

    end
    """
    And I start the page manager "MySite"
    And no exception is raised
    When I use dsl method "now"
    Then the current page is a "StartPage"

  @test#49
  Scenario: Manager with initial page not a page object
    When I define a page object manager class as:
    """
    class MySite < QAT::Web::PageManager

      manages MyPage
      initial_page Hash

    end
    """
    Then a "TypeError" exception is raised
    And the exception message is "Initial page class Hash is not a QAT::Web::Page subclass"

  @test#50
  Scenario: Manager with initial page not in managed domain
    Given I define an empty page object class named "AnotherPage"
    When I define a page object manager class as:
    """
    class MySite < QAT::Web::PageManager
      manages MyPage
      initial_page AnotherPage
    end
    """
    Then a "TypeError" exception is raised
    And the exception message is "Initial page class AnotherPage is not a MyPage subclass"

  @test#51
  Scenario: Manager with managed page domain not a page object
    When I define a page object manager class as:
    """
    class MySite < QAT::Web::PageManager

      manages Hash
      initial_page StartPage

    end
    """
    Then a "TypeError" exception is raised
    And the exception message is "Manage domain class Hash is not an QAT::Web::Page subclass"

  @test#52
  Scenario: Manager without manages and initial page key
    When I define a page object manager class as:
    """
    class MySite < QAT::Web::PageManager
    end
    """
    Then no exception is raised
    When I start the page manager "MySite"
    Then a "TypeError" exception is raised
    And the exception message is "No page type defined, use class definition 'manages' to define a QAT:Web::Page type to manage"

  @test#53
  Scenario: Manager without manages key
    When I define a page object manager class as:
    """
    class MySite < QAT::Web::PageManager
      initial_page StartPage
    end
    """
    Then no exception is raised
    When I start the page manager "MySite"
    Then a "TypeError" exception is raised
    And the exception message is "No page type defined, use class definition 'manages' to define a QAT:Web::Page type to manage"

  @test#54
  Scenario: Manager without initial page key
    When I define a page object manager class as:
    """
    class MySite < QAT::Web::PageManager
      manages MyPage
    end
    """
    Then no exception is raised
    When I start the page manager "MySite"
    Then a "TypeError" exception is raised
    And the exception message is "No initial page type defined, use class definition 'initial_page' to define a MyPage type page as initial"

