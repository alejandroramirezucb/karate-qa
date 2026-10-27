Feature: Usuarios

  Background:
    * def Faker = Java.type('com.github.javafaker.Faker')
    * def faker = new Faker()
    * url 'https://gorest.co.in/public/v2'
    * configure headers = { Accept: 'application/json', 'Content-Type': 'application/json', Authorization: 'Bearer 700d0c7a86eb84028bf5cd204b11587f812f9d7cd880dc4edbdbd1d407ae9954' }

  Scenario: Crear un usuario
    * def nombreUsuario = faker.name().fullName()
    * def email = faker.internet().emailAddress()
    Given path 'users'
    And request { name: '#(nombreUsuario)', gender: 'male', email: '#(email)', status: 'active' }
    When method post
    Then status 201
    And match response.id == '#number'
    And match response.name == nombreUsuario
    And match response.email == email
    And match response.status == 'active'
    And assert responseTime < 3000

  Scenario: Obtener un usuario
    * def nombreUsuario = faker.name().fullName()
    * def email = faker.internet().emailAddress()
    Given path 'users'
    And request { name: '#(nombreUsuario)', gender: 'male', email: '#(email)', status: 'active' }
    When method post
    Then status 201
    * def userId = response.id

    Given path 'users', userId
    When method get
    Then status 200
    And match response.id == userId
    And match response.name == nombreUsuario
    And match response.email == email

  Scenario: Actualizar el estado de un usuario a inactivo
    * def nombreUsuario = faker.name().fullName()
    * def email = faker.internet().emailAddress()
    Given path 'users'
    And request { name: '#(nombreUsuario)', gender: 'male', email: '#(email)', status: 'active' }
    When method post
    Then status 201
    * def userId = response.id

    Given path 'users', userId
    And request { status: 'inactive' }
    When method patch
    Then status 200
    And match response.id == userId
    And match response.status == 'inactive'

  Scenario: Listar usuarios
    Given path 'users'
    And param page = 1
    And param per_page = 10
    When method get
    Then status 200
    And match response == '#array'
    And match response[0] contains { id: '#number', name: '#string', email: '#string', status: '#string' }

  Scenario: Eliminar un usuario y verificar que ya no existe
    * def nombreUsuario = faker.name().fullName()
    * def email = faker.internet().emailAddress()
    Given path 'users'
    And request { name: '#(nombreUsuario)', gender: 'male', email: '#(email)', status: 'active' }
    When method post
    Then status 201
    * def userId = response.id

    Given path 'users', userId
    When method delete
    Then status 204

    Given path 'users', userId
    When method get
    Then status 404
