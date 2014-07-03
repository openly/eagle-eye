@adminLogin
Feature: Create project for the clients
  As a logged in user of API I want to CRUD the projects of the API
  So that I can do the projects API operations

  Scenario: List Project
    When I request the url '/projects?access_token=<validToken>'
    Then I should get the "project" response with status "success"
    And I should get the "project"s and total number of "projects"

  Scenario: Invalid Project creation
    When I post request the url '/projects/create?access_token=<validToken>' with the invalid data
    """
    {
    "project_name": "",
    "description": "",
    "client_id": ""
    "users":""
    "Notification_mail":""
    }
    """
    Then I should get the "project" response with status "failure"
    And I should get the error messages for "project"

  Scenario: Invalid client
    When I post request the url '/projects/create?access_token=<validToken>' with the invalid client data
    """
    {
    "project_name": "",
    "description": "",
    "client_id": "invalid"# client not associated with the project
    "users":""
    "Notification_mail":""
    }
    """  
    Then I should get the "project" response with status "failure"
    And I should get the error messages for "project"

  @createClient
  Scenario: Create project with valid data
    When I post request the url '/projects/create?access_token=<validToken>' with the valid data
    """
    {
    "project_name": "Project1",
    "description": "",
    "client_id": "Client1",
    "users":"user1,user2,user3",
    "Notification_mail":"user1@gmail.com",
    "project_handle":"project1"
    }
    """
    Then I should get the "project" response with status "success"
    And I should get the new project ID

  Scenario: Duplicate project
    When I post request the url '/projects/create?access_token=<validToken>' with the already existing project handle
    """
    {
    "project_name": "Project2",
    "description": "",
    "client_id": "Client1"
    "users":"user1,user2,user3"
    "Notification_mail":"user1@gmail.com"
    "project_handle":"project1"
    }
    """
    Then I should get the "project" response with status "failure"
    And I should get the error messages for "project"

  Scenario: View Project details	
    When I request the url '/projects/<projectID>?access_token=<validToken>'
    Then I should get the "project" response with status "success"
    And I should get the "project" as result

  Scenario: Update project with invalid data
    When I post request the url '/projects/update/<projectID>?access_token=<validToken>' with the invalid data
      """
      {
      "project_name": "",
      "description": "",
      "client_id": ""
      "users":""
      "Notification_mail":""
      }
      """
    Then I should get the "project" response with status "failure"
    And I should get the error messages for "project"


  @createClient
  Scenario:  Update project
    When I post request the url '/projects/update/<projectID>?access_token=<validToken>' with the valid data
      """
      {
      "project_name": "Project2",
      "description": "",
      "client_id": "Client2"
      "users":"user1,user2,user3"
      "Notification_mail":"user2@gmail.com"
      }
      """
    Then I should get the "project" response with status "success"

  Scenario: Delete project
    When I request the url '/projects/delete/<projectID>?access_token=<validToken>'
    Then I should get the "project" response with status "success"