---
title: '#24 Spring Boot - Hystrix Dashboard'
tags:
  - circuit breaker
  - hystrix
  - hystrix dashboard
  - spring boot
id: '2388'
categories:
  - - Spring Boot
date: 2017-12-08 12:12:44
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)

Kolejny wpis na temat **Hystrix'a**, czyli biblioteki realizującej wzorzec **CircuitBreaker**. [W poprzednim wpisie](http://codecouple.pl/2017/11/24/23-spring-boot-hystrix/) opisałem jak zaimplementować funkcjonalność **Hystrix'a** w naszej aplikacji. Dziś przedstawię wam projekt **Hystrix Dashboard**, na którym prezentowane są wyniki z naszych metod opakowanych w **commandy Hystrix'owe**.
<!-- more -->
Działanie **Hystrix Dashboard** pokażę wam na przykładzie aplikacji [napisanej w poprzednim wpisie](http://codecouple.pl/2017/11/24/23-spring-boot-hystrix/).

### Maven

Musimy dodać kolejną zależność **Mavenową**:

<dependency>
   <groupId>org.springframework.cloud</groupId>
   <artifactId>spring-cloud-starter-hystrix-dashboard</artifactId>
</dependency>

### Dashboard

Po uruchomieniu naszej aplikacji pod adresem `http://localhost:8080/hystrix.stream` mamy dostępny strumień danych generowany przez **Hystrixa**. Pod adresem `http://localhost:8080/hystrix` znajduje się pole, w którym musimy wskazać źródło, dla którego ma być stworzony **dashboard**.

![](http://codecouple.pl/wp-content/uploads/2017/12/hystrix.png)

### Wykres

Wskazujemy nasz `hystrix.stream`, następnie powinien ukazać się nam nasz **dashboard**. Teraz najlepiej jest uruchomić stres testy i obserwować wyniki:

![](http://codecouple.pl/wp-content/uploads/2017/12/hystrixDashboard.png)

### GitHub

Jeśli chcielibyśmy na jednej stronie mieć kilka wykresów, potrzebujemy w jakiś sposób złączyć nasze strumienie. Aby rozwiązać ten problem możemy wykorzystać narzędzie **Turbine**, ale o tym następnym razem. Całość jak zawsze na [GitHubie](https://github.com/kchrusciel/Spring-Boot-Examples/tree/master/spring-boot-hystrix-dashboard-example).