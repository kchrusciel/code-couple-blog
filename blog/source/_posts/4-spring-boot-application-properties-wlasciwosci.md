---
title: '#4 Spring Boot - application.properties - właściwości'
tags:
  - java
  - spring
  - spring boot
id: '645'
categories:
  - - Java
  - - Spring Boot
date: 2016-06-21 12:43:07
author: 'Krzysztof Chruściel'
---

Kolejny wpis o pliku właściwości. Chcę zamknąć temat, bo już trochę tych wpisów się zrobiło (tylko na temat **application.properties**). Jednakże z drugiej strony nie chciałem zrobić jednego dużego wpisu, bo moim zdaniem lepiej czyta się krótkie. No dobrze, więc o czym dziś? Tematem będą wbudowane **właściwości**.
<!-- more -->
W poprzednich [artykułach](http://codecouple.pl/2016/06/14/2-spring-boot-application-properties/) pisałem jak działa i gdzie znajduje się plik oraz jak wykorzystać go do pracy z **profilami**. Plik ten służy także do ustawiania **właściwości** wbudowanych. Całą kompletną listę znajdziecie [TUTAJ](http://docs.spring.io/spring-boot/docs/current/reference/html/common-application-properties.html). Aby nie przepisywać całego **manuala** wypiszę wartości najczęściej ustawiane przeze mnie:

banner.location=classpath:banner.txt # Zmiana lokalizacji pliku banneru

spring.profiles.active= # Ustawienie aktywnego profilu

server.port=8080 # Port serwera HTTP

spring.data.rest.base-path= # Gdy chce, aby moje endpointy REST'owe był poprzedzone api

spring.datasource.data= # Wskazuje pliki \*.sql w projekcie, które wypełniają bazę przykładowymi danymi

spring.datasource.username= # Ustawienie loginu

spring.datasource.password= # Ustawienie hasła

spring.h2.console.enabled=true # Włączam konsolę  

spring.h2.console.path=/h2 # Ścieżka do konsoli

spring.jpa.show-sql=true # Przydaje się na środowisku developerskim