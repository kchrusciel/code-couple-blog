---
title: '#31 Spring Boot – Authorization Server'
tags: []
id: '2596'
categories:
  - - Python
---

![](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)

Kontynuacja tematyki związanej z zabezpieczeniem aplikacji korzystając z **OAuth2**. Dziś chcemy wam przedstawić w jaki sposób stworzyć serwer uwierzytelniania. W [poprzednich wpisach opisane](http://codecouple.pl/2018/02/16/29-spring-boot-single-sign-on/) było jak zabezpieczyć zasoby korzystając z **GitHub'a**, jednakże co zrobić jeśli nie chcemy korzystać z **API** stworzonego przez kogoś? Należy stworzyć własny serwer uwierzytelniania. Zapraszamy!
<!-- more -->
### Maven

Standardowo zaczynamy od dodania zależności:

<dependency>
   <groupId>org.springframework.cloud</groupId>
   <artifactId>spring-cloud-starter-oauth2</artifactId>
</dependency>

### Włączamy serwer uwierzytelniania

Czas na stworzenie serwera. Aby to zrobić należy użyć adnotacji `@EnableAuthorizationServer`:

@SpringBootApplication
@EnableAuthorizationServer
@EnableResourceServer
public class AuthorizationServerApplication {

   public static void main(String\[\] args) {
      SpringApplication.run(AuthorizationServerApplication.class, args);
   }
}

Pod dodaniu tej adnotacji będziemy mogli korzystać z dwóch dodatkowych endpointów:

*   **oauth/token**  - wykorzystywany do pobrania tokenu na podstawie przekazanych parametrów
*   **oauth/authorize** - wykorzystywany do autoryzacji

Dodatkowo należy ustawić id, hasło, typ logowania oraz poziom uprawnień:

security.oauth2.client.client-id=my-unique-client-id
security.oauth2.client.client-secret=my-unique-client-secret
security.oauth2.client.authorized-grant-types=password,authorization\_code,client\_credentials,refresh\_token
security.oauth2.client.scope=read,write

Ponadto dodajemy domyślnego user'a (tutaj mamy dowonlość):

security.user.name=code
security.user.password=couple
security.user.role=USER

### Dodajemy serwer zasobów

Możemy teraz wykorzystać serwer zasobów z poprzedniego wpisu aby skorzystać z serwera autoryzacji. Uruchamiamy teraz nasz serwer zasobów, jednakże tym razem wskazujemy jako adres **URI** dla informacji o userze, endpoint "/me" przygotowany w serwerze autoryzacji.

#User info endpoint
security.oauth2.resource.user-info-uri=http://localhost:9191/user
#Prefer user info
security.oauth2.resource.prefer-token-info=false

### Testujemy

Po uruchomieniu serwera autoryzacji powinienień w logach pojawić się wpis:

2018-02-17 12:42:50.838 INFO 5892 --- \[ main\] a.OAuth2AuthorizationServerConfiguration : Initialized OAuth2 Client

security.oauth2.client.client-id = my-unique-client-id
security.oauth2.client.client-secret = \*\*\*\*

Teraz korzystając z dowolnego klienta HTTP

### GitHub

Całość jak zawsze na GitHub'ie.