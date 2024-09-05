---
title: '#5 Spring Boot - LiveReload'
tags:
  - IDE
  - Intellij Idea
  - java
  - spring boot
id: '818'
categories:
  - - Java
  - - Spring Boot
date: 2016-08-30 22:10:19
author: 'Krzysztof Chruściel'
---

Wracamy po wakacyjnej przerwie! Dziś bardzo praktyczny wpis. Każdy kto zajmuje się **frontend'em** w **Spring Boot'cie** wykorzystując na przykład **Thymeleaf** musi za każdym razem budować projekt. Jednakże można przyśpieszyć tą operację.
<!-- more -->
Funkcja **LiveReload** działa pod przeglądarkami **Chrome**, **Firefox** oraz **Safari**. Musimy pobrać odpowiedni dodatek do przeglądarki. Link **[TUTAJ](http://livereload.com/extensions/)**.

Aby móc korzystać z **LiveReload** w **Spring** **Boot'cie** musimy zacząć od dodania zależności:

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
</dependency>

Następnie w naszym **IDE** musimy ustawić automatyczne budowanie projektu (przykład w **IntelliJ**):

[![setupAutomaticallyMake](http://codecouple.pl/wp-content/uploads/2016/08/setupAutomaticallyMake.png)](http://codecouple.pl/wp-content/uploads/2016/08/setupAutomaticallyMake.png)

Musimy także aktywować wpis w rejestrach **IDE** `compiler.automake.allow.when.app.running`.  Aby dostać się do ustawień rejestrów **IntelliJ** można użyć skrótu `Shift+CTRL+A` i wpisać `registry`:

[![compilerRegistry](http://codecouple.pl/wp-content/uploads/2016/08/compilerRegistry.png)](http://codecouple.pl/wp-content/uploads/2016/08/compilerRegistry.png)

Teraz wystarczy uruchomić aplikację. Następnie można zmienić coś w pliku stylów i wystarczy odświeżyć **przeglądarkę**.

Więcej można przeczytać [**TUTAJ**](https://patrickgrimard.io/2016/01/18/spring-boot-devtools-first-look/) oraz **[TUTAJ](http://docs.spring.io/spring-boot/docs/1.4.0.RELEASE/reference/htmlsingle/#using-boot-devtools-livereload)**.