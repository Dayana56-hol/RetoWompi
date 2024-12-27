Feature: Realizar una transaccion

  Background:
    * url api.urlBase
    * def keys = read('classpath:karate/common/keys.json')
    * def bodyRequest = read('classpath:karate/transactions/data/transactions_body.json')
    * def paymentMethod = read('classpath:karate/transactions/data/payment_method.json')
    * def customerData = read('classpath:karate/transactions/data/customer_data.json')
    * def publicKey = keys.public_key
    * def integrityKey = keys.integrity_key
    * def authToken = 'Bearer ' + publicKey
    * def transactionPath = path.transaction
    * def tokens = call read('classpath:karate/merchants/merchants.feature')
    * def createSignature = Java.type('karate.utils.Generate')

  @SuccessTransaction
  Scenario Outline: Transaccion exitosa por Bancolombia QR
    * def reference = createSignature.generarCodigo()
    * def signature = createSignature.generateSHA256Hash(<reference>,<amount>,<currency>,<integrity>)
    * set bodyRequest.amount_in_cents = <amount>
    * set bodyRequest.currency = <currency>
    * set bodyRequest.reference = <reference>
    * set bodyRequest.signature = signature
    * set bodyRequest.customer_data = customerData.customer_data
    * set bodyRequest.payment_method = paymentMethod.<paymentMethod>
    * set bodyRequest.acceptance_token = tokens.response.data.presigned_acceptance.acceptance_token
    * set bodyRequest.accept_personal_auth = tokens.response.data.presigned_personal_data_auth.acceptance_token
    Given path transactionPath
    And header Authorization = authToken
    And request bodyRequest
    When method POST
    Then status 201
    And match response.data.payment_method_type == '<paymentMethod>'
    And match response.data.amount_in_cents == <amount>
    And match response.data.currency == <currency>
    And match response.data.payment_method.sandbox_status == '<status>'
    And match response.data.reference == <reference>
    Examples:
      | amount | currency | reference | integrity    | paymentMethod  | status   |
      | 150000 | 'COP'    | reference | integrityKey | BANCOLOMBIA_QR | APPROVED |
      | 160000 | 'COP'    | reference | integrityKey | BANCOLOMBIA_QR | APPROVED |

  @FailedTransactionToken
  Scenario Outline: Transaccion fallida por que el token de aceptación ya fue usado
    * def reference = createSignature.generarCodigo()
    * def signature = createSignature.generateSHA256Hash(<reference>,<amount>,<currency>,<integrity>)
    * set bodyRequest.amount_in_cents = <amount>
    * set bodyRequest.currency = <currency>
    * set bodyRequest.reference = <reference>
    * set bodyRequest.signature = signature
    * set bodyRequest.customer_data = customerData.customer_data
    * set bodyRequest.payment_method = paymentMethod.<paymentMethod>
    Given path transactionPath
    And header Authorization = authToken
    And request bodyRequest
    When method POST
    Then status 422
    And match response.error.type == <typeError>
    And match response.error.messages.<messagesError>[0] == <description>
    Examples:
      | amount | currency | reference | integrity    | paymentMethod  | typeError                | messagesError    | description                           |
      | 150000 | 'COP'    | reference | integrityKey | BANCOLOMBIA_QR | 'INPUT_VALIDATION_ERROR' | acceptance_token | 'El token de aceptación ya fue usado' |

  @FailedTransactionReference
  Scenario Outline: Transaccion fallida por que la referencia ya ha sido usada
    * set bodyRequest.amount_in_cents = <amount>
    * set bodyRequest.currency = <currency>
    * set bodyRequest.customer_data = customerData.customer_data
    * set bodyRequest.payment_method = paymentMethod.<paymentMethod>
    * set bodyRequest.acceptance_token = tokens.response.data.presigned_acceptance.acceptance_token
    * set bodyRequest.accept_personal_auth = tokens.response.data.presigned_personal_data_auth.acceptance_token
    Given path transactionPath
    And header Authorization = authToken
    And request bodyRequest
    When method POST
    Then status 422
    And match response.error.type == <typeError>
    And match response.error.messages.<messagesError>[0] == <description>
    Examples:
      | amount | currency | paymentMethod  | typeError                | messagesError | description                      |
      | 150000 | 'COP'    | BANCOLOMBIA_QR | 'INPUT_VALIDATION_ERROR' | reference     | 'La referencia ya ha sido usada' |

  @FailedTransactionReference
  Scenario Outline: Transaccion fallida por que la llave publica no se envio
    * set bodyRequest.amount_in_cents = <amount>
    * set bodyRequest.currency = <currency>
    * set bodyRequest.customer_data = customerData.customer_data
    * set bodyRequest.payment_method = paymentMethod.<paymentMethod>
    * set bodyRequest.acceptance_token = tokens.response.data.presigned_acceptance.acceptance_token
    * set bodyRequest.accept_personal_auth = tokens.response.data.presigned_personal_data_auth.acceptance_token
    Given path transactionPath
    And request bodyRequest
    When method POST
    Then status 401
    And match response.error.type == <typeError>
    And match response.error.<messagesError> == <description>
    Examples:
      | amount | currency | paymentMethod  | typeError              | messagesError | description                                                          |
      | 150000 | 'COP'    | BANCOLOMBIA_QR | 'INVALID_ACCESS_TOKEN' | reason        | 'Se esperaba una llave pública o privada pero no se recibió ninguna' |

  @FailedTransactionReference
  Scenario Outline: Transaccion fallida por que la firma no es valida
    * def reference = createSignature.generarCodigo()
    * set bodyRequest.amount_in_cents = <amount>
    * set bodyRequest.currency = <currency>
    * set bodyRequest.reference = <reference>
    * set bodyRequest.customer_data = customerData.customer_data
    * set bodyRequest.payment_method = paymentMethod.<paymentMethod>
    * set bodyRequest.acceptance_token = tokens.response.data.presigned_acceptance.acceptance_token
    * set bodyRequest.accept_personal_auth = tokens.response.data.presigned_personal_data_auth.acceptance_token
    Given path transactionPath
    And header Authorization = authToken
    And request bodyRequest
    When method POST
    Then status 422
    And match response.error.type == <typeError>
    And match response.error.messages.<messagesError>[0] == <description>
    Examples:
      | amount | currency | reference | paymentMethod  | typeError                | messagesError | description            |
      | 150000 | 'COP'    | reference | BANCOLOMBIA_QR | 'INPUT_VALIDATION_ERROR' | signature     | 'La firma es inválida' |