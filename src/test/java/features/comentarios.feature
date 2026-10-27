Feature: Comentarios

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

    * def tituloPost = faker.book().title()
    Given path 'users', userId, 'posts'
    And request { title: '#(tituloPost)', body: '#(faker.lorem().sentence())' }
    When method post
    Then status 201
    * def postId = response.id

  Scenario: Crear un comentario y validar que es del post creado
    * def cuerpoComentario = faker.lorem().sentence()
    * def emailComentario = faker.internet().emailAddress()
    Given path 'posts', postId, 'comments'
    And request { name: '#(nombreUsuario)', email: '#(emailComentario)', body: '#(cuerpoComentario)' }
    When method post
    Then status 201
    And match response.id == '#number'
    And match response.post_id == postId
    And match response.body == cuerpoComentario

  Scenario: Obtener un comentario
    * def cuerpoComentario = faker.lorem().sentence()
    * def emailComentario = faker.internet().emailAddress()
    Given path 'posts', postId, 'comments'
    And request { name: '#(nombreUsuario)', email: '#(emailComentario)', body: '#(cuerpoComentario)' }
    When method post
    Then status 201
    * def commentId = response.id

    Given path 'comments', commentId
    When method get
    Then status 200
    And match response.id == commentId
    And match response.body == cuerpoComentario
    And match response.post_id == postId

  Scenario: Listar comentarios de un post
    * def cuerpoComentario = faker.lorem().sentence()
    * def emailComentario = faker.internet().emailAddress()
    Given path 'posts', postId, 'comments'
    And request { name: '#(nombreUsuario)', email: '#(emailComentario)', body: '#(cuerpoComentario)' }
    When method post
    Then status 201

    Given path 'posts', postId, 'comments'
    When method get
    Then status 200
    And match response == '#array'
    And match each response contains { post_id: '#(postId)' }
