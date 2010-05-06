Feature: The OSL application shall allow a developer to upload localizable resources.
  In order to give localizers access to resources
  As a developer
  I want to be able to upload my applications
  
  # Scenario: Does the project appear?
  #   Given the application is loaded
  #   And the welcome window is closed
  #   And the upload window is opened
  #   When I upload "Calculator.app"
  #   Then the sidebar should contain "Calculator.app"
  # 
  Scenario: Is the project persistent?
    Given "Time Machine.app" exists as a project
    And the application is loaded
    Then the sidebar should contain "Time Machine.app"
    
  Scenario: Can we select a project?
    Given "Time Machine.app" exists as a project
    And the application is loaded
    When I select "Time Machine.app" in the sidebar
    Then the project "Time Machine.app" should display
    
  Scenario: Are the resources defined for the project?
    When I select "Time Machine.app" in the sidebar
    Then the project "Time Machine.app" should display resources:
      |name|
      |Time Machine.app/Contents/Resources/English.lproj/Menu.strings|
  
