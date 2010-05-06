Feature: The OSL application shall allow a developer to up-vote specific localizations.
  In order to give feedback about a localization
  As a developer
  I want to be able to vote on a localization

  Scenario: Does the project get more votes?
    Given the application has loaded
    When I select "Time Machine.app" in the sidebar
    And I select "Time Machine.app/Contents/Resources/English.lproj/Menu.strings" from the selected project
    And I upvote the selected resource
    Then "resource1" should have a vote total of 1
  
  Scenario: Does the project get more visibility because of the upvote?
    Given the application has loaded
    When I select "Search" in the sidebar
    And I search for "C"
    Then the search results should be:
      |name|
      |Chess.app|
      |Calculator.app|
  
  
  
  
  
