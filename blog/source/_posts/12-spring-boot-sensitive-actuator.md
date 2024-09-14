---
title: '#12 Spring Boot - Sensitive Actuator'
tags:
  - Actuator
  - java
  - spring boot
id: '1506'
categories:
  - - Java
  - - Spring Boot
date: 2017-03-24 14:12:39
author: 'Krzysztof Chruściel'
---

[![springBootArt](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)

[W poprzednim wpisie](http://codecouple.pl/2017/02/24/11-spring-boot-actuator/) opisałem **endpointy**, które były **insensitive**. Oznacza to, iż nie wymagały logowania. Dziś przedstawię wam pozostałą część. Pakiet **Spring Boot Acutator** oferuje całą gamę ciekawych rozwiązań. Zapraszam do czytania.
<!-- more -->
### Autoconfig

Zwraca nam informacje o wszystkich **autokonfiguracjach**. Możemy dowiedzieć się, dlaczego akurat konkretna konfiguracja jest załadowała. W kodzie odpowiedzialnym za to mechanizmem jest `OnClassCondition` oraz `OnBeanCondition:`

AuditAutoConfiguration#authenticationAuditListener: \[
   {
      condition: "OnClassCondition",
      message: "@ConditionalOnClass found required class 'org.springframework.security.authentication.event.AbstractAuthenticationEvent'; @ConditionalOnMissingClass did not find unwanted class"
   },
   {
      condition: "OnBeanCondition",
      message: "@ConditionalOnMissingBean (types: org.springframework.boot.actuate.security.AbstractAuthenticationAuditListener; SearchStrategy: all) did not find any beans"
   }
\]

### Beans

Wyświetla listę dostępnych beanów, wraz z jego **scopem** oraz ścieżką gdzie znajduje się plik (przydatne, gdy chcemy się dowiedzieć jakie mamy dostępne **beany** w kontekście springowym):

{
 bean: "bookController",
 aliases: \[ \],
 scope: "singleton",
 type: "pl.codecouple.books.BookController",
 resource: "file \[path/spring-demo/target/classes/pl/codecouple/books/BookController.class\]",
 dependencies: \[
 "bookServiceImpl"
 \]
}

### Configprops

Wyświetla listę wszystkich klas, które oznaczone są adnotacją `@ConfigurationProperties` wraz z ich wartościami:

spring.http.multipart-org.springframework.boot.autoconfigure.web.MultipartProperties: {
prefix: "spring.http.multipart",
   properties: {
      maxRequestSize: "10MB",
      fileSizeThreshold: "0",
      location: null,
      maxFileSize: "1MB",
      enabled: true,
      resolveLazily: false
   }
}

### Dump

Gdy pojawiają się problemy z wątkami możemy zrobić "dump'a" `/dump,` czyli zrzut aktualnie używanych wątków w **JVM**:

threadName: "http-nio-8082-exec-9",
threadId: 41,
blockedTime: -1,
blockedCount: 0,
...

### Env

Wszelkie informacje na temat środowiska, na który pracuje nasza aplikacja uzyskamy dzięki `/env`:

{
   "profiles": \[\],
   "server.ports": {
   "local.server.port": 8082
},
   "servletContextInitParams": {},
   "systemProperties": {
      "java.runtime.name": "Java(TM) SE Runtime Environment",
      "spring.output.ansi.enabled": "always",
...

### Metrics

Metryki naszej aplikacji znajdziemy pod endpointem `/metrics`. Znajdują się tu informacje o pamięci, a także liczniki wywołań poszczególnych endpointów:

{
  "mem": 571552,
  "mem.free": 187079,
  "processors": 4,
  "instance.uptime": 327716,
  "uptime": 335840,
  "systemload.average": -1,
...

### Mappings

Kolejny endpoint `/mappings` zawiera informacje o udostępnionych endpointach i związanych z nimi akcjami. W przykładzie poniżej opisany mamy typ metod **HTTP**, jaki bean jest używany oraz jaka metoda zostanie wywołana:

"{\[/books\],methods=\[GET\]}": {
    "bean": "requestMappingHandlerMapping",
    "method": "public java.util.List<pl.diebold.books.Book> pl.diebold.books.BookController.getAllBooks()"
  },
  "{\[/books\],methods=\[POST\]}": {
    "bean": "requestMappingHandlerMapping",
    "method": "public void pl.diebold.books.BookController.addNewBook(pl.diebold.books.Book)"
  },

### Shutdown

Bardzo fajny, ale zarazem niebezpieczny wyłącznik. Po wywołaniu tego **endpointu** możemy wyłączyć naszą aplikację (uwaga, żeby nie poszło to na produkcję ;)). Ten adres jako jedyny jest domyślnie wyłączony. Aby go włączyć korzystamy z `application.properties`:

endpoints.shutdown.enabled\=true

Teraz po wysłaniu pustego **POST'a** wyłączymy aplikację i pojawi nam się fajny komunikat w odpowiedzi:

{ "message": "Shutting down, bye..." }

### Trace

Bardzo przydatne podczas procesu developmentu. W prosty sposób możemy podejrzeć ścieżkę wywołań w naszej aplikacji wraz z takimi informacjami jak nagłówek oraz odpowiedź jaką dostaliśmy:

{
   timestamp: 1488116131497,
   info: {
      method: "GET",
      path: "/favicon.ico",
      headers: {
         request: {
            host: "localhost:8082",
            connection: "keep-alive",
            user-agent: "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36",
            accept: "image/webp,image/\*,\*/\*;q=0.8",
            referer: "http://localhost:8082/autoconfig",
            accept-encoding: "gzip, deflate, sdch, br",
            accept-language: "pl-PL,pl;q=0.8,en-US;q=0.6,en;q=0.4",
            cookie: "jenkins-timestamper-offset=-7200000; csrftoken=kc8eP3XnleqYXHeLYuhJM6uTeSpsQzcT; Idea-7e059cda=68c638d4-7676-48ce-a117-de1bea07b1bc"
      },
      response: {
            X-Application-Context: "application:8082",
            Last-Modified: "Sun, 19 Feb 2017 10:24:09 GMT",
            Accept-Ranges: "bytes",
            Content-Type: "application/octet-stream",
            Content-Length: "946",
            Date: "Sun, 26 Feb 2017 13:35:31 GMT",
            status: "200"
            }
         }
   }
}

### Docs

Nie chcecie za każdym razem wracać do tego wpisu? Oczywiście wracajcie, ale także możecie skorzystać z `/docs,` w którym znajduje się dokumentacja wszystkich **endpointów** z pakietu **actuators**. Aby móc korzystać z `/docs` należy dodać zależność **mavenową**:

<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-actuator-docs</artifactId>
    </dependency>
</dependencies>

Od teraz można pod /docs przeczytać dokumentacje do każdego endpointu.

### Konfiguracja

Każdy z endpointów można konfigurować przy wykorzystaniu `application.properties`. Podstawowe pola, które są w każdym **acutatorze** to:

*   id - określa adres,
*   enabled - określa czy jest włączony,
*   sensitive - określa czy wymaga zalogowania.

endpoints.beans.id=mybeans #zmieniamy adres na /mybeans endpoints.beans.enabled\=true #/mybeans jest włączony
endpoints.beans.sensitive\=false #/mybeans nie wymaga zalogownia

Możemy także w łatwy sposób wyłączyć wszystkie **endpointy** i zostawić aktywny tylko `info`:

endpoints.enabled\=false
endpoints.info.enabled\=true

Podobnie możemy zrobić z ich dostępnością, wszystkie endpointy wymagąją zalogowania oprócz `info`:

endpoints.sensitive\=true
endpoints.info.sensitive\=false

Możemy także dodać własny **Endpoint**. Nasza klasa musi jedynie implementować odpowiedni interfejs. Metoda `getId()` zwraca nam adres.

@Component
public class MyCustomIndicator implements Endpoint<List<String>>{


    @Override
    public String getId() {
        return "CodeCoupleCustomEndpoint";
    }

    @Override
    public boolean isEnabled() {
        return true;
    }

    @Override
    public boolean isSensitive() {
        return false;
    }

    @Override
    public List<String> invoke() {
        return Collections.singletonList("CodeCouple!");
    }
}

Teraz po wejściu na nasz adres plus "/CodeCoupleCustomEndpoint" powinien pokazać się nam napis "CodeCouple!". Ostatnim elementem, który chce wam pokazać to zmiana portu dla wszystkich **acutatorów**. W `application.properties` należy dodać wpis:

management.port=8083

Od teraz wszystkie endpointy są dostępne pod portem **8083**.

2017-03-24 13:20:17.337 INFO 9184 --- \[ restartedMain\] s.b.c.e.t.TomcatEmbeddedServletContainer : Tomcat started on port(s): 8083 (http)
2017-03-24 13:20:17.338 INFO 9184 --- \[ restartedMain\] o.s.c.support.DefaultLifecycleProcessor : Starting beans in phase 0
2017-03-24 13:20:17.378 INFO 9184 --- \[ restartedMain\] s.b.c.e.t.TomcatEmbeddedServletContainer : Tomcat started on port(s): 8082 (http)