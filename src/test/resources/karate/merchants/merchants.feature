Feature: Obtener los tokens de aceptación


  Background:
    * url api.urlBase
    * def keys = read('classpath:karate/common/keys.json')
    * def publicKey = keys.public_key
    * def merchantsPath = path.merchants

  Scenario: Obtener tokens
    Given path merchantsPath, publicKey
    When method GET
    Then status 200
    And match response.data.presigned_acceptance.acceptance_token == '#string'
    And match response.data.presigned_personal_data_auth.acceptance_token == '#string'
