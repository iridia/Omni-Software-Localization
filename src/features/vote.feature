Feature: The OSL application shall allow a developer to up-vote specific localizations.
  In order to give feedback about a localization
  As a developer
  I want to be able to vote on a localization

  Scenario: Does the project get more votes?
    Given "Calculator.app" exists as a project
    And "Calculator.app" has the resources:
      |name|
      |resource1|
      |resource2|
      |resource3|
    And the application has loaded
    When I select "Time Machine.app" in the sidebar
    And I select "resource1" from the selected project
    And I upvote the selected resource
    Then "resource1" should have a vote total of 1
  
  Scenario: Does the project get more visibility because of the upvote?
    Given "Calculator.app" exists as a project
    And "Calculator.app" has the resources:
      |name|votes|
      |resource1|0|
      |resource2|1|
      |resource3|0|
    And "CaTest.app" exists as a project
    And "CaTest.app" has the resources:
      |name|votes|
      |resource1|1|
      |resource2|2|
    And "CaDashboard.app" exists as a project
    And "CaDashboard.app" has the resources:
      |name|votes|
      |resource1|2|
    When I select "Search" in the sidebar
    And I search for "C"
    Then the search results should be:
      |name|
      |Chess.app|
      |Calculator.app|
  
  
  
  
  
