---
title: '#30 Spring Boot – Resource Server'
tags:
  - resource server
  - spring
  - spring boot
  - spring cloud
id: '2579'
categories:
  - - Spring
  - - Spring Boot
date: 2018-03-02 12:01:02
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)

W poprzednim [wpisie przygotowaliśmy](http://codecouple.pl/2018/02/16/29-spring-boot-single-sign-on/) rozwiązanie korzystające z **Single Sign-On**. Teraz korzystając z tego mechanizmu chcielibyśmy zabezpieczyć inne moduły naszej aplikacji. Aby to osiągnąć, nasze moduły muszą stać się **serwerami zasobów** (ang. _Resource Server_). Jak to zrobić wykorzystując **Spring Boot'a?** Zapraszamy do wpisu!
<!-- more -->
### Maven

Zaczynamy od dodania zależności do **Maven'a**:

<dependency>
   <groupId>org.springframework.cloud</groupId>
   <artifactId>spring-cloud-starter-oauth2</artifactId>
</dependency>

### Włączamy Resource Server

Aby ustawić nasz moduł jako **Resource Server**, musimy dodać adnotację `@EnableResourceServer`:

@SpringBootApplication
@EnableResourceServer
public class ResourceServerApplication {

   public static void main(String\[\] args) {
      SpringApplication.run(ResourceServerApplication.class, args);
   }
}

### Controller

Dodajmy teraz prosty kontroler, który będzie naszym "chronionym" zasobem:

@RestController
class CodeCoupleController {

    @GetMapping("/not-for-all")
    String showCodeCouple(){
        return "Code Couple!";
    }

}

### Properties

W pliku `application.properties` musimy wskazać **URI**, pod którym dostępne będą informacje o użytkowniku (korzystamy z API **GitHub'a**):

#User info endpoint
security.oauth2.resource.user-info-uri=https://api.github.com/user
#Prefer user info
security.oauth2.resource.prefer-token-info=false

### Testujemy

Spróbujmy udać się pod adres `/not-for-all`, w odpowiedzi dostaniemy:

<oauth>
    <error\_description>
        Full authentication is required to access this resource
    </error\_description>
    <error>unauthorized</error>
</oauth>

Od teraz każdy nasz **request** do usługi `/not-for-all` wymaga tokenu typu **Bearer**. Token ten możemy zdobyć od naszego dostawcy, czyli **GitHub'a**. Należy udać się pod adres:

https://github.com/login/oauth/authorize?client\_id=your-client\_id&response\_type=code&state=yz1Bhx

Ustawiając dane:

*   **client\_id** - wygenerowane w serwisie unikalne ID
*   **response\_type** - typ odpowiedzi, w naszym przypadku oczekujemy typu **code**
*   **state** - unikalny ciąg znaków dla bezpieczeństwa

Następnie zostaniemy przekierowani na adres strony, który ustawiliśmy w **GitHub'ie** (czyli **callback** URL) wraz z wartością `code`:

http://localhost:9191/?code=69b25b069e9e5ae21000&state=yz1Bhx

Teraz korzystając z dowolnego klienta **HTTP** (polecam **Postman'a**) wysyłamy żądanie **POST**:

https://github.com/login/oauth/access\_token?code=69b25b069e9e5ae21000&client\_id=your-client-id&state=yz1Bhx&client\_secret=your-client-secret

Ustawiając dane:

*   **client\_id** - wygenerowane w serwisie unikalne ID
*   **client\_secret** - wygenerowany w serwisie kod `secret`
*   **code** - wygenerowany kod w poprzednim kroku
*   **state** - unikalny ciąg znaków dla bezpieczeństwa (ten sam co wcześniej)

W odpowiedzi otrzymujemy **Bearer** token:

access\_token=6f80ecc3602ea730982545a6707b35ff83061000&scope=&token\_type=bearer

Możemy teraz użyć ten token korzystając po raz kolejny z klienta **HTTP**. Ustawiamy nagłówek `Authorization` wraz z wartością `Bearer 6f80ecc3602ea730982545a6707b35ff83061000`, w odpowiedzi powinien pokazać się napis "_Code Couple!_".

### Wcześniejsza aplikacja

Możemy także wykorzystać aplikację z [poprzedniego wpisu](http://codecouple.pl/2018/02/16/29-spring-boot-single-sign-on/), aby otrzymać **Bearer** token (bez potrzeby przygotowywania parametrów **URI**). Wystarczy dodać nowy **endpoint**, wraz z odczytaną wartością z `OAuth2ClientContext`:

@Autowired
private OAuth2ClientContext clientContext;

@GetMapping("/token")
String showToken() {
 return clientContext.getAccessToken().getValue();
}

Pod endpointem `/token` otrzymamy **Bearer** token, który możemy używać do odpytywania "chronionych" zasobów.

### GitHub

Całość jak zawsze na [GitHub'ie](https://github.com/kchrusciel/Spring-Boot-Examples/tree/master/spring-boot-resource-server-example).