---
title: '#3 Spring Boot 2 - Actuator'
tags:
  - Actuator
  - spring
  - spring boot
  - spring boot 2
id: '3837'
categories:
  - - Java
  - - Spring Boot
date: 2019-05-03 12:01:14
---

![](https://codecouple.pl/wp-content/uploads/2017/12/springBoot2Art.png)

Autorzy rozwiązania **Spring Boot** bardzo mocno stawiają na fakt, iż aplikacja napisana z wykorzystaniem ich frameworku powinna być _production-ready_. Zgodnie z **12 factor manifesto**, apikacja sama w sobie powinna dostarczać informacji na temat swojej **telemetrii**. Projekt **actuator** jest mechanizmem zbliżającym nas do pojęcia  _production-ready_. Dostarcza on podstawowe metryki oraz informacje na temat aplikacji.
<!-- more -->
### Zależności

Standardowo zaczniemy od dodania nowej **zależności** do naszego projektu, tym razem będzie to `spring-boot-starter-actuator`:

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>

### Domyślnie

Dodanie powyższej **zależności** do naszego projektu sprawiło, iż pojawią się nowe **funkcjonalności**. Wszystkie dodatkowe informacje o aplikacji dostępne pod adresem `/actuator`. Domyślnie **włączonymi** adresami są `/info` oraz `/health`.

### Health

Adres `/health` zwraca informacje na temat statusu **aplikacji** w postaci:

{
   "status": "UP" // jeśli aplikacja działa poprawnie
}

{
   "status": "DOWN" // jeśli aplikacja działa niepoprawnie
}

### Info

Adres `/info` zwraca ustawione przez nas **informacje** o aplikacji (domyślnie zwraca pusty **JSON**).  Aby ustawić wartości pod adresem `/info` wystarczy w pliku `application.properties` dodać wpis:

#Zawartość adresu /info
info.app.name=Code Couple Application
info.app.description=This is my first code couple application
info.app.version=1.0.0
#Wszystko co jest po kluczu info
info.dowolny.klucz=wartosc

Wszystko co dostępne jest po kluczu `info` dodawane jest do adresu `/info`. W wyniku wywołania adresu `/actuator/info` otrzymamy:

{
  "app": {
    "name": "Code Couple Application",
    "description": "This is my first code couple application",
    "version": "1.0.0"
  },
  "dowolny": {
    "klucz": "wartosc"
 }
}

Jest to bardzo przydatny **adres**, jeśli chcemy poinformować innych o aktualnej **wersji** lub gdy przygotowujemy **dashboard** zbierający **informacje** o aplikacjach.

### Actuator

Jednakże, projekt **actuator** to nie tylko `/info` oraz `/health`. **Projekt** ten oferuje bardzo dużą ilość **metryk** i **informacji** na temat aplikacji. Dostępne **adresy** to (poniżej zostało wypisane tylko kilka **najważniejszych**):

*   `/beans` – zwraca wszystkie dostępne **Bean’y** w naszej aplikacji
*   `/conditions` – zwraca wszystkie **autokonfiguracje**
*   `/flyway` - zwraca informacje na temat **migracji** bazy z wykorzystaniem technologii **Flyway**
*   `/liquibase` - zwraca informacje na temat **migracji** bazy z wykorzystaniem technologii **Liquibase**
*   `/env` – zwraca wszystkie **zmienne środowiskowe**
*   `/heapdump` – zwraca zrzut **pamięci** naszej **JVM'owej** aplikacji
*   `/threaddump` – zwraca zrzut **wątków** naszej **JVM'owej** aplikacji
*   `/scheduledtasks` – zwraca informacje o **zadaniach** wykonywanych w tle w naszej aplikacji
*   `/sessions` – zwraca informacje o **sesjach** HTTP z wykorzystaniem technologii **Spring Session**
*   `/metrics` – zwraca **metryki** aplikacji
*   `/prometheus` - zwraca **metryki** aplikacji dostosowane do aplikacji **Prometheus**
*   `/shutdown` – wyłącza aplikację poprzez żądanie **POST** (domyślnie jest **wyłączony**)

### Dostępność

Jak pisałem w poprzednim akapicie, domyślnie **włączonymi** adresami są `/health` oraz `/info`. Jeśli chcemy **włączyć** wszystkie lub kilka szczególnych adresów to musimy użyć wpisu `management.endpoints.web.exposure.include`:

#Włącza wszystkie adresy
management.endpoints.web.exposure.include=\*

#Włącza tylko wybrane adresy
management.endpoints.web.exposure.include=info, metrics
#Wyłącza adres shutdown
management.endpoints.web.exposure.exclude=shutdown

**Dodatkowo** poprzez plik `application.properties` możemy ustawić:

#Zmiana ścieżki bazowej /actuator
management.endpoints.web.base-path=/
#Włącza wszystkie usługi
management.endpoints.enabled-by-default=true
#Wyłączenie adresu metrics
management.endpoint.metrics.enabled=false
#Akceptowane nagłówki
management.endpoints.web.cors.allowed-headers=\*

Całą listę dostępnych **właściwości** znajdziecie pod [https://docs.spring.io/spring-boot/docs/current/reference/html/common-application-properties.html](https://docs.spring.io/spring-boot/docs/current/reference/html/common-application-properties.html).

### Github

Całość jak zawsze na [Github'ie](https://github.com/kchrusciel/Spring-Boot-2-Examples/tree/master/spring-boot-actuator-example).