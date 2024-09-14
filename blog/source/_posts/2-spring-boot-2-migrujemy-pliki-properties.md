---
title: '#2 Spring Boot 2 – Migrujemy pliki properties'
tags:
  - spring
  - spring boot 2
id: '2815'
categories:
  - - Spring
  - - Spring Boot
date: 2018-07-27 12:01:51
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/12/springBoot2Art.png)

Podczas migracji moich aplikacji do **Spring Boot'a** w wersji **2.0** okazało się, że kilka wykorzystywanych przeze mnie **wpisów** w pliku **properties** jest nieaktualnych. Dzięki wykorzystaniu **IDE**, udało mi się w łatwy sposób wykryć, które **wpisy** są nieaktualne, a co jeśli moje **IDE** nie wspierałoby takiego sprawdzania? Zapraszam do wpisu!
<!-- more -->
### Spring Boot Properties Migrator

Autorzy **Spring Boot'a 2.0** przewidzieli taką sytuację i dostarczyli oficjalne **narzędzie**, które wspomaga proces migracji plików **properties**. Aby móc wykorzystać to rozwiązanie wystarczy dodać nową **zależność**:

<dependency>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-properties-migrator</artifactId>
</dependency>

Jeśli mieliśmy nieaktualne wpisy jak `security.user.password` lub `server.context-path` powinniśmy otrzymać informację w **konsoli**:

2018-03-30 17:04:57.708 WARN 5956 --- \[ main\] o.s.b.c.p.m.PropertiesMigrationListener :
The use of configuration keys that have been renamed was found in the environment:

Property source 'applicationConfig: \[classpath:/application.properties\]':
Key: security.user.password
Line: 2
Replacement: spring.security.user.password
Key: server.context-path
Line: 1
Replacement: server.servlet.context-path
Each configuration key has been temporarily mapped to its replacement for your convenience. To silence this warning, please update your configuration to use the new keys.

Ponadto **spring-boot-properties-migrator** stara się podczas runtime'u podmienić w bezpieczny sposób nieaktualne wpisy.

### Więcej

Jeśli chcielibyście dowiedzieć się więcej na temat procesu migracji zaprszam [TUTAJ](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.0-Migration-Guide).

### GitHub

Całość jak zawsze na [GitHub'ie](https://github.com/kchrusciel/Spring-Boot-2-Examples).