Feature: Login Logout
  As a user of API I want to login to the API 
  So that I can do the API operations

  Scenario: Invalid Login
    When I post request the url '/login' with the invalid user
    """
    {"username":"inValidUser", "password":"*****"}
    """
    Then I should get the "login" response with status "failure"

  # Access Token will be like this '77e9aef80694bfe0cb62709a682128a6'
  Scenario: Valid Login
     When I post request the url '/login' with the valid user
    """
    {"username":"validUser", "password":"*****"}
    """
    Then I should get the "login" response with status "success"
    And I should get the access token

  Scenario: Logout without token
    When I request the url '/logout' without the token
    Then I should get the "logout" response with status "failure"

  Scenario: Logout with invalid token
    When I request the url '/logout?access_token=<invalidToken>' with the invalid token
    Then I should get the "logout" response with status "failure"

  Scenario: Logout with valid token
    When I request the url '/logout?access_token=<validToken>' with the valid token
    Then I should get the "logout" response with status "success"