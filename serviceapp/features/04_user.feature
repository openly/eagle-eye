@adminLogin
Feature: Users
  As a logged in user of API I want to CRUD the users of the API
  So that I can do the users API operations

  Scenario: Create user with invalid data
    When I post request the url '/users/create?access_token=<validToken>' with the invalid data
    """
    {
      "username": "",
      "password": "",
      "confirm_password": "",
      "first_name": "",
      "last_name": "",
      "email": "first.last",
      "phone_number": "",
      "client_id": ""
    }
    """
    Then I should get the "user" response with status "failure"
    And I should get the error messages for "user"

  #User ID will be like this '539068ec66e84fc743a00398'
  Scenario: Create user with valid data
    When I post request the url '/users/create?access_token=<validToken>' with the valid data
    """
    {
      "username": "User1",
      "password": "123456",
      "confirm_password": "123456",
      "first_name": "First",
      "last_name": "Last",
      "email": "first.last@123456.com",
      "phone_number": "+911236498797",
      "client_id": "12345678978979"
    }
    """
    Then I should get the "user" response with status "success"
    And I should get the new user ID

  Scenario: Do not create duplicate user
     When I post request the url '/users/create?access_token=<validToken>' with the already existing user handle
    """
    {
      "username": "User1",
      "password": "123456",
      "confirm_password": "123456",
      "first_name": "First",
      "last_name": "Last",
      "email": "first.last@123456.com",
      "phone_number": "+911236498797",
      "client_id": "12345678978979"
    }
    """
    Then I should get the "user" response with status "failure"
    And I should get the error messages for "user"

  Scenario: List all users
    When I request the url '/users?access_token=<validToken>'
    Then I should get the "user" response with status "success"
    And I should get the "user"s and total number of "users"

  Scenario: Get a single user
    When I request the url '/users/<userId>?access_token=<validToken>'
    Then I should get the "user" response with status "success"
    And I should get the "user" as result

  Scenario:  Update user
    When I post request the url '/users/update/<userId>?access_token=<validToken>' with the valid data
    """
      "username": "User2",
      "password": "1234561",
      "confirm_password": "1234561",
      "first_name": "Second",
      "last_name": "Last",
      "email": "updated.last@123456.com",
      "phone_number": "+91123654987",
      "client_id": "12345678978979"
    """
    Then I should get the "user" response with status "success"

  Scenario: Delete user
    When I request the url '/users/delete/<userId>?access_token=<validToken>'
    Then I should get the "user" response with status "success"