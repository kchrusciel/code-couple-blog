---
title: '#3 Spring Boot - application.properties - profile'
tags:
  - java
  - spring
  - spring boot
id: '643'
categories:
  - - Java
  - - Spring Boot
date: 2016-06-18 09:39:20
author: 'Krzysztof Chruściel'
---

Artykuł ten [nawiązuje do poprzedniego wpisu](http://codecouple.pl/2016/06/14/2-spring-boot-application-properties/), który dotyczy pliku właściwości **application.properties**. Dziś wpis dotyczący profili, czyli mechanizmu, który pomoże nam pracować z różnymi danymi. Możemy zdefiniować różne właściwości w zależności np. od tego na jakim środowisku chcemy pracować.
<!-- more -->
Tworzenie plików profilowych odbywa się poprzez dodanie pliku:

application-{profil}.properties

do naszego folderu z właściwościami, w moim przypadku jest to folder **resources/config**. Załóżmy, że mamy dwa środowiska:

*   **production**
*   **development**

Na środowisku **development** wykorzystujemy bazę **H2,** która idealnie nadaje się do testowania i rozwoju aplikacji. Natomiast środowisko **production** wykorzystuje bazę **MongoDB**. W takim przypadku tworzymy dwa oddzielne pliki dla każdego profilu:

application.properties
application-development.properties
application-production.properties

Wyobraźmy sobie to jako klasy: **application.properties** jest to klasa bazowa, czyli są w niej właściwości, które chcemy, aby były propagowane w dół, czyli do naszych plików z konkretnymi profilami. Następnie pliki **development** oraz **production** są naszymi specyfikowanymi klasami, czyli są to pliki, które mają unikalne wartości.

Pliki te korzystają z właściwości, która odnosi się do bazy danych. Ustawiamy odpowiednie wartości: **application.properties**

my.app.name = CodeCouple

**application-development.properties**

database.url = your\_development\_url\_here

**application-production.properties**

database.url = your\_production\_url\_here

Teraz z linii komend uruchamiamy naszą aplikację ustawiając interesujący nas profil:

\-Dspring.profiles.active=development

Uruchomimy naszą aplikację z profilem **development,** który posiada w sobie **URL** do naszej bazy testowej. Uruchomiają się również właściwości zawarte w pliku nadrzędnym, czyli **application.properties**. Możecie teraz tworzyć własne profile dla odpowiednich aplikacji uniezależniając się od innych środowisk.