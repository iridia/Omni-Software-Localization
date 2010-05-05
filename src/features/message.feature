Feature: The OSL application shall allow a developer to report bugs as fixed.
  In order to report fixed bugs and updates
  As a developer
  I want to send messages to everyone that cares

  Scenario: Does the message persist?
    Given the application is loaded
    When I create a new message
    And I fill in the message form with subject "Test" and body "Test Message" to "derekhammer"
    And I submit the message
    Then "derekhammer" should receive a new message
  