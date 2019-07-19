@epic#199 @feature#351 @user_story#279 @bug#1
Feature: User Story #279: Page Manager with empty Pages
  In order to easily use a page objects pattern
  As a web test developer
  I want to track the current page automatically

  @test#72
  Scenario: No error when using a page manager with empty initial page
    Given no page object class manager is defined
    And no page object class is defined
    And I define an empty page object class named "MyPage"
    And I define a page object class as:
    """
    class StartPage < MyPage

      def dummy
        return true
      end

    end
    """
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
    When I try to use dsl method "dummy"
    Then no exception is raised