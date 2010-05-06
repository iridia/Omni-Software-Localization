Feature: The OSL application shall allow a developer to upload preferred glossaries.
  In order to have easily localization for parts of my application
  As a developer
  I want to upload preferred glossaries
  
  # Scenario: Does the glossary appear?
  #   Given the application is loaded
  #   And the welcome window is closed
  #   And the upload window is opened
  #   When I upload "Glossary.strings"
  #   Then the sidebar should contain "Glossary.strings"
  
  Scenario: Can we select a glossary?
    Given the application is loaded
    When I select "Localizable.strings" in the sidebar
    Then the glossary "Localizable.strings" should display
  
  

  
