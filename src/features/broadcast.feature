Feature: The OSL application shall allow a developer to report bugs as fixed.
  In order to report fixed bugs and updates
  As a developer
  I want to send messages to everyone that cares

  Scenario: Does the message get broadcast to all subscribers?
    Given "Calculator.app" exists as a project
    And I select "Calculator.app" in the sidebar
    When I select "Broadcast Message" from the menu
    And I fill in the broadcast message form with subject "Test" and body "Test Message"
    And I submit the broadcast message
    Then the subscribers of "Calculator.app" should receive a new message
  
  
  
