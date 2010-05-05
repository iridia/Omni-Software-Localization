Feature: The OSL application shall allow a localizer to edit localizable resources.
  In order to edit a localization into a new language
  As a localizer
  I want to be able to edit individual line items

  Scenario: Does the edit save?
    Given "Calculator.app" exists as a project
    And "Calculator.app" has the resources:
      |name|
      |resource1|
      |resource2|
      |resource3|
    And "resource1" of "Calculator.app" has the line items:
      |name|
      |one|
      |two|
      |three|
    When I select "Calculator.app" in the sidebar
    And I select "resource1" from the selected project
    And I select "three" from the selected resource
    And I edit the selected resource to be "four"
    Then "resource1" should have the line items:
      |name|
      |one|
      |two|
      |four|
