Feature: The OSL application shall allow a developer to report bugs as fixed.
  In order to report fixed bugs and updates
  As a developer
  I want to send messages to everyone that cares

  Scenario: Does the message get broadcast to all subscribers?
    Given "Calculator.app" exists as a project
    And 
    When event
    Then outcome
  
  
  
