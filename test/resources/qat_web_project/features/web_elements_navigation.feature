@web_elements
Feature: Web Elements navigation

  Background:
    Given I visit the Example website


  Scenario: Element access through web elements configuration
    Then the header contains text:
    """
    Example Domain
    """


  Scenario: Element in collection access through web elements configuration
    Then the first body paragraph contains text:
    """
    This domain is established to be used for illustrative examples in documents. You may use this domain in examples without prior coordination or asking for permission.
    """

  Scenario: Navigation through web elements configuration
    When I click the more information link
    Then the header contains text:
    """
    IANA-managed Reserved Domains
    """
