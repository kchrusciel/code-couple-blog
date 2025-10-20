---
title: '#6 Spring Boot 2 – WebMvc.fn'
tags:
  - spring boot
  - spring boot 2
id: '3935'
category: Spring Boot 2
date: 2019-05-31 12:01:34
author: 'Krzysztof Chruściel'
---

![](https://raw.githubusercontent.com/kchrusciel/code-couple-blog-assets/main/2017/12/springBoot2Art.png)

Wraz ze **Spring Boot 2** w wersji **2.2.0** pojawiła się nowa funkcjonalność: **WebMvc.fn**. Jest to implementacja **funkcyjnego** podejścia do definiowania **endpointów**, podobnie jak ma to miejsce przy wykorzystaniu **Spring WebFlux**. O tym, jak to rozwiązanie działa w WebFlux, można było przeczytać w jednym z naszych artykułów: [#1 Spring Boot 2 – Router functions](https://codecouple.pl/2018/07/20/1-spring-boot-2-router-functions/). Dziś sprawdzimy, jak to **funkcyjne** podejście sprawdza się w klasycznym stosie **MVC**.
<!-- more -->
### WebMvc.fn

Jak pisałem we wstępie, w nowym **Spring Boot 2** możemy tworzyć naszą część serwerową na dwa sposoby (można je mieszać w jednej aplikacji):

* **Podejście klasyczne** – korzystając z adnotacji `@Controller` i innych związanych z **Webem**.
* **Podejście funkcyjne** – korzystając z **WebMvc.fn**.

### Zależności

Ponieważ wsparcie dla **funkcyjnego podejścia** pojawiło się w kontekście stosu **MVC**, wystarczy, że w naszym projekcie dodamy standardowy moduł **Web**:

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

### Router Function

Podobnie jak w przypadku **Spring WebFlux**, tworzymy konfigurację z wykorzystaniem klasy `RouterFunction`:

```java
package pl.codecouple.webmvc.fn.configuration;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.function.RouterFunction;
import org.springframework.web.servlet.function.ServerResponse;

import java.net.URI;
import java.util.Arrays;
import java.util.List;

import static org.springframework.web.servlet.function.RouterFunctions.route;

@Configuration
class RouterConfig {

    @Bean
    public RouterFunction<ServerResponse> routes(DataService dataService) {
        return route()
                .GET("/code-couple", serverRequest ->
                        ServerResponse.ok()
                          .body(
                            dataService.getAll()))
                .GET("/code-couple/{id}", r ->
                        ServerResponse.ok()
                          .body(
                            dataService.getById(
                              Long.parseLong(r.pathVariable("id")))))
                .POST("/code-couple", r -> {
                    dataService.save(r.body(String.class));
                    return ServerResponse
                             .created(URI.create("/location")).build();
                })
                .build();
    }

}
```

W wyniku naszej **lambdy** otrzymujemy obiekt typu `ServerRequest`, z którego możemy odczytać wiele informacji:

* `cookies()` - dostęp do **ciasteczek**.
* `headers()` - dostęp do **nagłówków**.
* `sessions()` - dostęp do **sesji**.
* `pathVariable(name)` - dostęp do **zmiennej** ze ścieżki.
* `servletRequest()` - dostęp do obiektu typu `HttpServletRequest`, z którego można pobrać wszystkie informacje.

### Handler

Jeśli chcemy oddzielić konfigurację routingu od logiki, możemy przygotować klasę zawierającą wszystkie handlery. Metody **HTTP** przyjmują obiekt typu `HandlerFunction<ServerResponse>`:

```java
@Bean
public RouterFunction<ServerResponse> routes(DataHandler dataHandler) {
  return route()
           .GET("/code-couple", dataHandler::handleGetAll)
           .GET("/code-couple/{id}", dataHandler::handleGetOne)
           .POST("/code-couple", dataHandler::handlePost)
           .build();
}

@Component
public class DataHandler {

    private final DataService dataService;

    public DataHandler(DataService dataService) {
        this.dataService = dataService;
    }

    public ServerResponse handleGetAll(ServerRequest serverRequest) {
        return ServerResponse.ok()
                .body(dataService.getAll());
    }

    public ServerResponse handleGetOne(ServerRequest serverRequest) {
        return ServerResponse.ok()
                .body(dataService.getById(
                        Long.parseLong(
                                serverRequest.pathVariable("id"))));
    }

    public ServerResponse handlePost(ServerRequest serverRequest) 
                                     throws ServletException, IOException {
        dataService.save(serverRequest.body(String.class));
        return ServerResponse.created(URI.create("/location")).build();
    }

}
```

### Github

Całość jak zawsze na [GitHubie](https://github.com/kchrusciel/Spring-Boot-2-Examples/tree/master/spring-boot-webmvcfn-example).