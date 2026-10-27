Feature: Posts

  Background:
    * def Faker = Java.type('com.github.javafaker.Faker')
    * def faker = new Faker()
    * url 'https://gorest.co.in/public/v2'
    * configure headers = { Accept: 'application/json', 'Content-Type': 'application/json', Authorization: 'Bearer 700d0c7a86eb84028bf5cd204b11587f812f9d7cd880dc4edbdbd1d407ae9954' }
    * def nombreUsuario = faker.name().fullName()
    * def email = faker.internet().emailAddress()

    Given path 'users'
    And request { name: '#(nombreUsuario)', gender: 'male', email: '#(email)', status: 'active' }
    When method post
    Then status 201
    * def userId = response.id

  Scenario: Crear un post y validar que es del usuario creado
    * def tituloPost = faker.book().title()
    Given path 'users', userId, 'posts'
    And request { title: '#(tituloPost)', body: '#(faker.lorem().sentence())' }
    When method post
    Then status 201
    And match response.id == '#number'
    And match response.user_id == userId
    And match response.title == tituloPost

  Scenario: Obtener un post
    * def tituloPost = faker.book().title()
    Given path 'users', userId, 'posts'
    And request { title: '#(tituloPost)', body: '#(faker.lorem().sentence())' }
    When method post
    Then status 201
    * def postId = response.id

    Given path 'posts', postId
    When method get
    Then status 200
    And match response.id == postId
    And match response.title == tituloPost
    And match response.user_id == userId

  Scenario: Listar posts
    Given path 'posts'
    And param page = 1
    And param per_page = 10
    When method get
    Then status 200
    And match response == '#array'
    And match response[0] contains { id: '#number', user_id: '#number', title: '#string', body: '#string' }
