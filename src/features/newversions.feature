Feature: The OSL application shall allow a developer to upload new versions of the localizable resources.
  In order to replace old versions with new version
  As a developer
  I want to upload new versions that replace the old versions

  Scenario: Does the imported project overwrite the existing project?
    Given "Calculator.app" exists as a project
    And "Calculator.app" has the resources:
      |name|
      |resource1|
    When I upload a new "Calculator.app" with the resources:
      |name|
      |resource1|
      |resource2|
    Then "Calculator.app" should have the resources:
      |name|
      |resource1|
      |resource2|
  
  Scenario: Does the imported file overwrite the existing file?
    Given "Calculator.app" exists as a project
    And "Calculator.app" has the resources:
      |name|
      |resource1|
    And "resource1" of "Calculator.app" has the line items:
      |name|
      |one|
      |two|
    When I upload a replacement "resource1" of "Calculator.app" with items:
      |name|
      |one|
      |two|
      |three|
    Then "resource1" of "Calculator.app" should have line items:
      |name|
      |one|
      |two|
      |three|
  