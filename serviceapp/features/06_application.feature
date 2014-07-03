@adminLogin
Feature: Create applications for the projects
  As a logged in user of API I want to CRUD the aplications of the API
  So that I can do the application API operations

Scenario: List Applications
  When I request the url '/applications?access_token=<validToken>'
  Then I should get the "application" response with status "success"
  And I should get the "application"s and total number of "applications"
  
Scenario: Invalid application creation
  When I post request the url '/applications/create?access_token=<validToken>' with the invalid data
    """
    {
      "application_name": "",
      "description": "",
      "project_id": ""
      "users":""
      "Notification_mail":""
    }
    """
    Then I should get the "application" response with status "failure"
    And I should get the error messages for "application"
    
Scenario: Invalid project
  When I post request the url '/applications/create?access_token=<validToken>' with the invalid project data
    """
    {
      "application_name": "",
      "description": "",
      "project_id": "invalid"# application not associated with the project
      "users":""
      "Notification_mail":""
    }
    """  
    Then I should get the "application" response with status "failure"
    And I should get the error messages for "application"  
    
@createClient @createProject
Scenario: Create application with valid data
    When I post request the url '/applications/create?access_token=<validToken>' with the valid data
    """
    {
      "application_name": "Applicationt1",
      "description": "",
      "project_id": "Project1"
      "users":"user1,user2,user3"
      "Notification_mail":"user1@gmail.com"
    }
    """
    Then I should get the "application" response with status "success"
    And I should get the new application ID
    
Scenario: Duplicate application
     When I post request the url '/applications/create?access_token=<validToken>' with the already existing application handle
    """
    {
      "application_name": "Application1",
      "description": "",
      "projec t_id": "Project1"
      "users":"user1,user2,user3"
      "Notification_mail":"user1@gmail.com"
    }
    """
    Then I should get the "application" response with status "failure"
    And I should get the error messages for "application"
    
Scenario: View application details	
    When I request the url '/applications/<applicationID>?access_token=<validToken>'
    Then I should get the "application" response with status "success"
    And I should get the "application" as result
    
Scenario: Update application with invalid data
    When I post request the url '/applications/update/<applicationID>?access_token=<validToken>' with the invalid data
    """
    {
      "application_name": "",
      "description": "",
      "project_id": ""
      "users":""
      "Notification_mail":""
    }
    """
    Then I should get the "application" response with status "failure"
    And I should get the error messages for "application"
    
@createClient @createProject
Scenario:  Update application
    When I post request the url '/applications/update/<applicationID>?access_token=<validToken>' with the valid data
    """
    {
      "application_name": "Application2",
      "description": "",
      "project_id": "Project2"
      "users":"user1,user2,user3"
      "Notification_mail":"user2@gmail.com"
    }
    """
    Then I should get the "application" response with status "success"

  Scenario: Delete application
    When I request the url '/applications/delete/<applicationID>?access_token=<validToken>'
    Then I should get the "application" response with status "success"