---
title: '#1 Spring Boot 2 - Router functions'
tags:
  - spring
  - spring boot
  - spring boot 2
id: '2798'
categories:
  - - Spring
  - - Spring Boot
date: 2018-07-20 12:01:13
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/12/springBoot2Art.png)

[Poprzedni wpis](http://codecouple.pl/2018/07/13/0-spring-boot-2-introduction/) był jedynie wprowadzeniem do **Spring Boot'a 2.0**. Pojawiło się tam pojęcie **WebFlux**. Jest to element, który w sposób reaktywny pozwala współpracować z warstwą **webową**. Ponadto, funkcjonalość ta dostarcza nam nowy sposób tworzenia endpointów poprzez użycie **Router Functions**. Zapraszam do wpisu!
<!-- more -->
### Router Functions

Jak pisałem we wstępie, w nowym **Spring Boot'cie** możemy tworzyć naszą część serwerową na dwa sposoby (aktualnie nie można ich mieszać w jednej aplikacji):

*   **"Po staremu"** - korzystając z adnotacji `@Controller` i innych związanych z **Web'em**
*   **"Po nowemu"** - korzystając z programowania funkcyjnego przy użyciu **Router Functions**

![](https://docs.spring.io/spring/docs/5.0.0.BUILD-SNAPSHOT/spring-framework-reference/html/images/webflux-overview.png)

Dziś przedstawię wam nowy sposób (stary wszyscy bardzo dobrze znamy). Zaczynamy od dodania zależności dla **WebFlux'a**:

<dependency>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-starter-webflux</artifactId>
</dependency>

Tworzymy konfigurację `@Configuration` dla `@Bean` typu `RouterFunction`:

@Bean
public RouterFunction<ServerResponse> routes(ReactiveHandler handler) {
    return route(GET("/code-couple"), handler::get);
}

Pod endpointem `/code-couple`, na metodzie **GET** zostanie wywołana metoda z `HandlerFunction` (u nas `ReactiveHandler`), czyli klasy, która trzyma logikę endpointów. Kolejne mapowania możemy dodawać w łatwy sposób dopisując kolejne wywołania:

@Bean
public RouterFunction<ServerResponse> routes(ReactiveHandler handler) {
    return route(GET("/code-couple"), handler::get)
            .andRoute(POST("/code-couple"), handler::post);
}

Wszystkie przydatne metody, których możemy używać przy tworzeniu `route` znajdują się w klasie `RequestPredicate`:

*   `RequestPredicate.method(HttpMethod)` - jaka metoda z **Http** nas interesuje
*   `RequestPredicate.path(String)` - ścieżka endpointu
*   `RequestPredicate.contentType` - typ treści
*   `RequestPredicate.GET(String)` - jest połączeniem `RequestPredicate.method(HttpMethod)` i `RequestPredicate.path(String)`
*   warunki logiczne - do łączenia predykatów
*   `RequestPredicate.*` - więcej

Po utworzeniu interesujących nas **Router Functions** pora na stworzenie `HandlerFunction,` czyli w naszym przypadku klasy `ReactiveHandler`:

@Component
class ReactiveHandler {

    Mono<ServerResponse> get(ServerRequest request) {
        Mono<String> slogan = Mono.just("CodeCouple roxx!");
        return ServerResponse.ok()
                .contentType(APPLICATION\_JSON)
                .body(slogan, String.class);
    }

    Mono<ServerResponse> post(ServerRequest request) {
        Mono<String> value = request.bodyToMono(String.class);
        //do something with value
        return ServerResponse.created(URI.create("/code-couple/1")).body(value, String.class);
    }

}

Każda metoda w `HandlerFunction` przyjmuje `ServerRequest`, natomiast zwraca `Mono<ServerResponse>`. Klasa `ServerRequest` dostarcza informacje o aktualnym żądaniu. Możemy z niej uzyskać takie informacje jak nagłówki czy parametry żądania. W odpowiedzi musimy natomiast zwrócić `ServerResponse`, który dostarcza przyjazne **API** do tworzenia odpowiedzi:

Mono<ServerResponse> get(ServerRequest request) {
    String path = request.path();
    return ServerResponse.ok().contentType(MediaType.APPLICATION\_JSON\_UTF8).build();
}

### Podsumowanie

Bardzo lubiłem wykorzystywać mapowanie "po staremu", jednakże ostatnio coraz częściej korzystam z **Router Functions**. Jak dla mnie krótkie mapowania sprawdzają się dużo lepiej z **Router Functions** niż z klasycznym `@RequestMapping.` Jaka jest wasza opinia na ten temat? Mieliście już przyjemność pracować z **Router Functions**?

### GitHub

Całość jak zawsze na [GitHub'ie](https://github.com/kchrusciel/Spring-Boot-2-Examples).