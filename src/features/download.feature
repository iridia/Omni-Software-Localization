Feature: The OSL application shall allow a developer to select and download localizable resources.
  In order to apply new resources to projects
  As a developer
  I want to download a project

  Scenario: Does the downloaded project contain all of the correct data?
    When I select "Search" in the sidebar
    And I search for "T"
    Then "Time Machine.app" exists in the search results
  
  Scenario: Does the downloaded project output an appropriate format?
    When I select "Search" in the sidebar
    And I search for "T"
    And I double-click "Time Machine.app" in the search results
    And I download the selected project
    Then the downloaded project is a zip file
  