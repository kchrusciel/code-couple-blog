---
title: '#31 Spring Boot - Zuul - API Gateway'
tags:
  - proxy
  - ribbon
  - spring
  - spring boot
  - spring cloud
  - zuul
id: '2495'
categories:
  - - Spring Boot
date: 2018-03-16 12:01:35
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)

**API Gateway** to wzorzec integracyjny. W wzorcu tym, tylko jeden serwis (może być oczywiście replikowany) udostępniony jest publicznie. Klientami naszego API mogą być aplikacje mobilne, strony web lub inne urządzenia. Musimy zapewnić im możliwość korzystania z naszego **API** w sposób **zunifikowany**. Aby to osiągnąć udostępniamy jeden publiczny serwis zwany **API Gateway,** który odpytywany przez różnych klientów zajmuje się kierowaniem ruchu na podstawie **filtrów** i określonych **routingów**.
<!-- more -->
Zastosowanie wzorca **API Gateway** ma wiele zalet, które mogą rozwiązać sporo problemów w środowisku rozproszonym:

*   **security** - decyduje, czy zapytanie może być "wpuszczone" do systemu
*   **zarządzanie ruchem** - routing na podstawie URI
*   **testowanie** - możemy kierować ruchem na nowe usługi w celu przetestowania (na przykład canary release)
*   **eksperymenty** - daje nam możliwość eskperymetowania z przekierowywaniem ruchu
*   **wstrzykiwanie danych** - możemy dodawać dane do żądań (na przykład do nagłówków)
*   **monitoring** - na podstawie tego serwisu mamy wgląd do tego jak ruch jest rozdzielany oraz co dzieję się w systemie
*   **wstrzykiwanie błędów** - możemy na przykład wstrzykiwać złe nagłówki i obserwować jak odpowie na to system
*   **odporność** - jeśli któryś z serwisów będzie niedostępny, gateway może przekierować ruch na działające instancje.

### First service

Stwórzmy prosty serwis z jednym endpointem `/codecouple`:

@RestController
public class FirstController {

    @GetMapping("/codecouple")
    public String showCodeCouple() {
        return "CodeCouple first service!";
    }
}

Natomiast w pliku `application.properties` ustawiamy:

#Random server port
server.port=0
#Application name
spring.application.name=first-service
#Default zone
eureka.client.serviceUrl.defaultZone=http://localhost:8761/eureka/

Więcej o wzorcu Service Discovery z wykorzystaniem biblioteki **Eurek'a** [można przeczytać tutaj](https://codecouple.pl/2017/09/29/19-spring-boot-microservice-registration-and-discovery-eureka/).

### Second service

Drugi serwis wygląda jak tak samo jak pierwszy, ale zwraca napis `CodeCouple second service!`. Musimy pamiętać także o zmianie nazwy `spring.application.name` w `application.properties`.

### Gateway

Dodajemy serwis odpowiedzialny za routing. Aby zrealizować wzorzec **API Gateway** wykorzystamy bibliotekę **Zuul** ze stajni **Netflixa**:

<dependency>
   <groupId>org.springframework.cloud</groupId>
   <artifactId>spring-cloud-starter-zuul</artifactId>
</dependency>

Uruchomienie biblioteki odbywa się poprzez adnotację `@EnableZuulProxy`:

@SpringBootApplication
@EnableEurekaClient
@EnableZuulProxy
public class ZuulServiceApplication {

   public static void main(String\[\] args) {
      SpringApplication.run(ZuulServiceApplication.class, args);
   }
}

Dodatkowo musimy skonfigurować nasz **routing**, czyli wskazanie adresów do przekierowania:

#Server port
server.port=8080
#Application name
spring.application.name=zuul-service
#Default zone
eureka.client.serviceUrl.defaultZone=http://localhost:8761/eureka/

#Zuul prefix
zuul.prefix=/api
#First service
zuul.routes.first-service.path=/first/\*\*
zuul.routes.first-service.serviceId=first-service
#Second service
zuul.routes.second-service.path=/second/\*\*
zuul.routes.second-service.serviceId=second-service

Property `zuul.prefix` określa **prefix** pod jakim będziemy "odpytywać" **zuul-service**. Następnie w `zuul.routes` podajemy nazwę serwisu, w naszym przypadku **first-service** oraz **second-service**. Kolejno dla każdego serwisu określamy `path`, czyli ścieżkę pod jaką ma być dostępny nasz serwis poprzez **proxy** oraz określamy `serviceId`, czyli nazwę serwisu zarejestrowanego w **Eurece**. Jeśli nie korzystamy z **service discovery** możemy ustawić property `url`, w którym wskazujemy **URL** do konkretnej usługi. Jeśli nie ustawimy żadnych `zuul.routes` to domyślnym adresem usługi jest nazwa ustawiona w `spring.application.name`.

### Testujemy

Aby przetestować **API Gateway** w działaniu należy udać się pod adres `http://localhost:8080/api/first/codecouple`. Powinien pojawić się napis `CodeCouple first service!` teraz zmieniamy adres na `http://localhost:8080/api/second/codecouple` i dostajemy `CodeCouple second service!`. Udało nam się zrealizować **routing**!

### Filtry

Biblioteka **Zuul** operuje na filtrach, które pisane są w **Groovym** oraz **Javie**. W Groovym, ponieważ mogą być podmieniane w runtime. Filtry są dostępne w czterech stanach:

*   **Pre** \- wywoływany w momencie **przyjścia żądania** - można wykorzystać do sprawdzania, czy żądanie jest poprawne
*   **Route** \- zaraz po `pre` filtrze wywoływany jest `route` filter - zawiera logikę odpowiedzialną za **przekierowanie**
*   **Post** \- służy do operowania na **odpowiedzi**
*   **Error** - typ służący do obsługi **niepoprawnych** zdarzeń

Dla przykładu możemy dodać nowy filtr dla typu **PRE**, który będzie dodawał nagłówek `Code-Couple-Header` z wartością `CodeCouple.pl!` :

@Component
class CustomFilter extends ZuulFilter {

    @Override
    public String filterType() {
        return PRE\_TYPE;
    }

    @Override
    public int filterOrder() {
        return PRE\_DECORATION\_FILTER\_ORDER - 1 ;
    }

    @Override
    public boolean shouldFilter() {
        return true;
    }

    @Override
    public Object run() {
        RequestContext context = RequestContext.getCurrentContext();
        context.addZuulRequestHeader("Code-Couple-Header", "CodeCouple!");
        return null;
    }
}

### GitHub

Całość jak zawsze na [GitHubie](https://github.com/kchrusciel/Spring-Boot-Examples).