@adminLogin
Feature: Clients
  As a logged in user of API I want to CRUD the clients of the API
  So that I can do the clients API operations

  Scenario: Create client with invalid data
    When I post request the url '/clients/create?access_token=<validToken>' with the invalid data
    """
    {
      "client_name": "",
      "description": "",
      "client_handle": ""
    }
    """
    Then I should get the "client" response with status "failure"
    And I should get the error messages for "client"

  #Client ID will be like this '539068ec66e84fc743a00398'
  Scenario: Create client with valid data
    When I post request the url '/clients/create?access_token=<validToken>' with the valid data
    """
    {
      "client_name": "Client1",
      "description": "New Client",
      "client_handle": "client1"
    }
    """
    Then I should get the "client" response with status "success"
    And I should get the new client ID

  Scenario: Do not create duplicate client
     When I post request the url '/clients/create?access_token=<validToken>' with the already existing client handle
    """
    {
      "client_name": "Client2",
      "description": "Duplicate Client Handle",
      "client_handle": "client1"
    }
    """
    Then I should get the "client" response with status "failure"
    And I should get the error messages for "client"

  Scenario: List all clients
    When I request the url '/clients?access_token=<validToken>'
    Then I should get the "client" response with status "success"
    And I should get the "client"s and total number of "clients"

  Scenario: Get a single client
    When I request the url '/clients/<clientId>?access_token=<validToken>'
    Then I should get the "client" response with status "success"
    And I should get the "client" as result

  Scenario:  Update client
    When I post request the url '/clients/update/<clientId>?access_token=<validToken>' with the valid data
    """
    {
      "client_name": "Client3",
      "description": "Update Client Handle",
      "client_handle": "client1"
    }
    """
    Then I should get the "client" response with status "success"

  Scenario: Delete client
    When I request the url '/clients/delete/<clientId>?access_token=<validToken>'
    Then I should get the "client" response with status "success"