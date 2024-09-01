---
title: '#6 Spring Boot - internacjonalizacja czyli locale w akcji'
tags:
  - java
  - spring
  - spring boot
id: '671'
categories:
  - - Java
  - - Spring Boot
date: 2016-09-06 12:00:11
---

![](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)

Dzięki wykorzystaniu [internacjonalizacji](https://en.wikipedia.org/wiki/Internationalization_and_localization) tworzenie aplikacji w różnych językach (nie programowania ;) ) stało się bardzo proste. Możemy przygotować jeden plik **wzorcowy,** a następnie przekazać go do odpowiednich tłumaczy, którzy przygotują nam przetłumaczone teksty w narzuconym przez nas **formacie**. Skrótem używanym naprzemiennie z internacjonalizacją jest **i18n.** Jest to ilość znaków pomiędzy "i" oraz "n" w słowie "_internationalization_".
<!-- more -->
### Autokonfiguracja

Aby skorzystać z internacjonalizacji w **Spring Boot'cie** mamy do tego utworzoną odpowiednią auto-konfigurację [MessageSourceAutoConfiguration](http://docs.spring.io/spring-boot/docs/current/api/org/springframework/boot/autoconfigure/MessageSourceAutoConfiguration.html). Dzięki temu nie musimy tworzyć ekstra **beanów** konfiguracyjnych tylko możemy wykorzystać plik **application.properties**:

\# INTERNATIONALIZATION (MessageSourceAutoConfiguration)

# Comma-separated list of basenames, each following the ResourceBundle convention.
spring.messages.basename=messages

# Loaded resource bundle files cache expiration, in seconds. When set to -1, bundles are cached forever. 
spring.messages.cache-seconds=-1

# Message bundles encoding.
spring.messages.encoding=UTF-8

# Set whether to fall back to the system Locale if no files for a specific Locale have been found.
spring.messages.fallback-to-system-locale=true

### Messages

Pliki z językami mają odpowiednie nazwy. Głównym plikiem domyślnym jest:

messages.properties

Jeśli chcemy utworzyć specyfikowany plik, dodajemy do niego **postfix** oznaczający język:

messages\_pl.properties # polski
messages\_de.properties # niemiecki

[![resourcesMessages](http://codecouple.pl/wp-content/uploads/2016/08/resourcesMessages.png)](http://codecouple.pl/wp-content/uploads/2016/08/resourcesMessages.png) Pliki domyślnie są wyszukiwane na **classpath'ie**:

Static resources can be moved to /public (or /static or /resources or /META-INF/resources)
in the classpath root. Same for messages.properties (Spring Boot detects this automatically 
in the root of the classpath).

Jeśli natomiast chcemy zmienić lokalizację plików **messages**, należy wykorzystać plik **application.properties**:

spring.messages.basename=locale/messages

Gdy dodaliśmy już interesujące nas pliki, możemy sprawdzić działanie w Tymianku (**Thymleafie**, ale ostatnio przeczytałem tłumaczenie i zostało mi w głowie ;)). W momencie wywołania sprawdzana jest lokalizacja. Jeśli nie ma żadnego pliku **messages.properties**, zostanie załadowana wartość domyślna, czyli "**Default**".

### Korzystamy

Dodajmy sobie teraz kod:

<h1 th:text="#{CompanyName}">CodeCouple</h1>

A w plikach **messages**, **messages\_pl**, **messages\_de** dodajmy wartość z odpowiednimi końcówkami:

CompanyName=CodeCouple.tutaj\_koncowka

Aby przetestować poprawność działania, wystarczy ustawić w przeglądarce domyślny język.