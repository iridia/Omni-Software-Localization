Feature: The OSL application shall allow a localizer to edit localizable resources.
  In order to edit a localization into a new language
  As a localizer
  I want to be able to edit individual line items

  Scenario: Does the edit save?
    Given the application is loaded
    When I select "Time Machine.app" in the sidebar
    And I select "Time Machine.app/Contents/Resources/English.lproj/Menu.strings" from the selected project
    And I select "Back Up Now" from the selected resource
    And I edit the selected resource to be "Back Up Ahora"
    Then "Time Machine.app/Contents/Resources/English.lproj/Menu.strings" should have the line items:
      |name|
      |Open Time Machine Preferences...|
      |Back Up Ahora|
      |Stop Backing Up|
      |Browse Other Time Machine Disks...|
