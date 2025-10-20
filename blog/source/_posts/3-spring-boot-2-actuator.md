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
author: 'Krzysztof Chruściel'
---

![](https://raw.githubusercontent.com/kchrusciel/code-couple-blog-assets/main/2017/12/springBoot2Art.png)

Autorzy rozwiązania **Spring Boot** bardzo mocno stawiają na to, że aplikacja napisana z wykorzystaniem ich frameworku powinna być _**production-ready**_. Zgodnie z **12 factor manifesto**, aplikacja sama w sobie powinna dostarczać informacji na temat swojej **telemetrii**. Projekt **Actuator** jest mechanizmem, który przybliża nas do tego celu, dostarczając podstawowe metryki oraz informacje o stanie aplikacji.
<!-- more -->
### Zależności

Standardowo zaczniemy od dodania nowej **zależności** do naszego projektu. Tym razem będzie to `spring-boot-starter-actuator`:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

### Domyślna Konfiguracja

Dodanie powyższej **zależności** wprowadza do projektu nowe **funkcjonalności**. Wszystkie dodatkowe informacje o aplikacji są dostępne pod adresem `/actuator`. Domyślnie **włączonymi** adresami (endpointami) są `/info` oraz `/health`.

### Health (Stan)

Endpoint `/health` zwraca informacje na temat statusu **aplikacji** w postaci:

```json
{
   "status": "UP" // jeśli aplikacja działa poprawnie
}

{
   "status": "DOWN" // jeśli aplikacja działa niepoprawnie
}
```

### Info (Informacje)

Endpoint `/info` zwraca **informacje** o aplikacji skonfigurowane przez nas (domyślnie zwraca pusty **JSON**). Aby ustawić wartości dla tego endpointu, wystarczy w pliku `application.properties` dodać wpis:

```properties
# Zawartość endpointu /info
info.app.name=Code Couple Application
info.app.description=This is my first code couple application
info.app.version=1.0.0
# Wszystko co jest po kluczu info zostanie dodane
info.dowolny.klucz=wartosc
```

Wszystkie właściwości pod kluczem `info` są dodawane do endpointu `/info`. W wyniku wywołania adresu `/actuator/info` otrzymamy:

```json
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
```

Jest to bardzo przydatny **endpoint**, jeśli chcemy poinformować innych o aktualnej **wersji** aplikacji lub gdy przygotowujemy **dashboard** zbierający **informacje** o różnych aplikacjach.

### Pozostałe Endpointy Actuatora

Projekt **Actuator** to nie tylko `/info` oraz `/health`. Oferuje on dużą ilość **metryk** i **informacji** na temat aplikacji. Dostępne **endpointy** to (poniżej znajduje się lista tylko kilku **najważniejszych**):

* `/beans` – zwraca wszystkie dostępne **Bean’y** w naszej aplikacji.
* `/conditions` – zwraca wszystkie **autokonfiguracje**.
* `/flyway` - zwraca informacje o **migracjach** bazy danych z wykorzystaniem technologii **Flyway**.
* `/liquibase` - zwraca informacje o **migracjach** bazy danych z wykorzystaniem technologii **Liquibase**.
* `/env` – zwraca wszystkie **zmienne środowiskowe**.
* `/heapdump` – zwraca zrzut **pamięci** naszej aplikacji **JVM**.
* `/threaddump` – zwraca zrzut **wątków** naszej aplikacji **JVM**.
* `/scheduledtasks` – zwraca informacje o **zadaniach** wykonywanych w tle.
* `/sessions` – zwraca informacje o **sesjach** HTTP z wykorzystaniem **Spring Session**.
* `/metrics` – zwraca **metryki** aplikacji.
* `/prometheus` - zwraca **metryki** aplikacji dostosowane do aplikacji **Prometheus**.
* `/shutdown` – wyłącza aplikację poprzez żądanie **POST** (domyślnie jest **wyłączony**).

### Dostępność Endpointów

Jak wspomniano wcześniej, domyślnie **włączonymi** adresami są `/health` oraz `/info`. Jeśli chcemy **włączyć** wszystkie lub kilka wybranych adresów, musimy użyć właściwości `management.endpoints.web.exposure.include`:

```properties
# Włącza wszystkie adresy
management.endpoints.web.exposure.include=\*
# Włącza tylko wybrane adresy
management.endpoints.web.exposure.include=info, metrics
# Wyłącza adres shutdown
management.endpoints.web.exposure.exclude=shutdown
```

**Dodatkowo**, poprzez plik `application.properties` możemy ustawić:

```properties
# Zmiana ścieżki bazowej /actuator
management.endpoints.web.base-path=/
# Włącza wszystkie usługi domyślnie
management.endpoints.enabled-by-default=true
# Wyłączenie endpointu metrics
management.endpoint.metrics.enabled=false
# Akceptowane nagłówki CORS
management.endpoints.web.cors.allowed-headers=\*
```

Całą listę dostępnych **właściwości** znajdziecie pod [https://docs.spring.io/spring-boot/docs/current/reference/html/common-application-properties.html](https://docs.spring.io/spring-boot/docs/current/reference/html/common-application-properties.html).

### Github

Całość jak zawsze na [Githubie](https://github.com/kchrusciel/Spring-Boot-2-Examples/tree/master/spring-boot-actuator-example).