---
title: '#29 Spring Boot - Single Sign-On'
tags:
  - Single Sign-On
  - spring
  - spring boot
  - spring cloud
  - SSO
id: '2558'
categories:
  - - Spring
  - - Spring Boot
date: 2018-02-16 12:01:40
---

![](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)

Podczas tworzenia aplikacji prędzej czy później pojawi się temat bezpieczeństwa. Musimy zastanowić się w jaki sposób chcemy chronić nasze zasoby oraz jaki typ uwierzytelniania wybierzemy. W dobie mikroserwisów nie jest to już takie proste jak w monolicie. Dziś wpis dotyczący podejścia **Single Sign-On**, zapraszamy!
<!-- more -->
### Single Sign-On

**Single Sign-On** jest odpowiedzią na powstające coraz to nowsze aplikacje, w których używamy danych do logowania. Powstawanie nowych aplikacji wiąże się z zapamiętaniem kolejnych haseł. Ponadto, jeśli nasza aplikacja składa się z kilku modułów, w każdym z nich musimy zaimplementować mechanizm uwierzytelniania, jednocześnie wymuszając na użytkowniku zapamiętanie kolejnych danych. Aby zredukować te niedogodności powstał **Single Sign-On**, czyli jeden centralny punkt logowania. Od teraz użytkownik logując się w jednym miejscu, ma dostęp do wszystkich usług, które korzystają z **Single Sign-On**. Ponadto daje to takie korzyści jak:

*   **lepsze bezpieczeństwo** - jedno miejsce z danymi
*   **mniejszy narzut** - nie ma potrzeby tworzenia mechanizmów uwierzytelniania we wszystkich modułach
*   **ułatwione korzystanie** - jeden punkt logowania dla użytkowników
*   **kończenie sesji** - w momencie wylogowania się użytkownika działa to dla wszystkich modułów
*   **łatwiejsza obsług** - jeden centralny punkt

### Maven

Zaczynamy od dodania zależności do **Mavena**:

<dependency>
   <groupId>org.springframework.cloud</groupId>
   <artifactId>spring-cloud-starter-oauth2</artifactId>
</dependency>

### Włączamy Single Sign-On

Aby włączyć **Single Sign-On** korzystając ze **Spring Boot'a** wystarczy użyć `@EnableOAuth2Sso` w naszej klasie konfiguracyjnej:

@Configuration
@EnableOAuth2Sso
class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.authorizeRequests()
                .antMatchers("/for-all")
                .permitAll()
                .anyRequest()
                .authenticated();
    }
}

Ponadto ustawiliśmy, iż zasób `/for-all` dostępny będzie dla wszystkich, natomiast każdy inny adres wymaga uwierzytelnienia.

### Controller

Dodajemy prosty kontroler:

@RestController
class CodeCoupleController {

    @GetMapping("/for-all")
    String showCodeCouple(){
        return "Code Couple!";
    }

    @GetMapping("/not-for-all")
    String showCodeCoupleAwesome(){
        return "Code Couple is awesome!";
    }

}

Pierwszy z zasobów będzie dostępny dla wszystkich, natomiast drugi wymaga logowania.

### Properties

Jak napisałem we wstępie, w modelu **Single Sign-On** stosujemy jeden serwis odpowiedzialny za uwierzytelnianie. Dotychczas wskazaliśmy, które zasoby mają być chronione oraz to, że będziemy korzystać z **SSO**. Teraz musimy wskazać serwis uwierzytelniający. Możemy utworzyć własny serwis, jednakże w tym wpisie wykorzystamy **GitHub'a**. Aby skorzystać z API **GitHub'a** należy w pliku `application.properites` dodać wpisy:

#Client id from GitHub
security.oauth2.client.client-id=generated-id
#Client secret from GitHub
security.oauth2.client.client-secret=generated-secret
#URI with access token
security.oauth2.client.access-token-uri=https://github.com/login/oauth/access\_token
#URI for authorization
security.oauth2.client.user-authorization-uri=https://github.com/login/oauth/authorize
#Scheme of authentication
security.oauth2.client.client-authentication-scheme=form

#User info endpoint
security.oauth2.resource.user-info-uri=https://api.github.com/user
#Prefer user info
security.oauth2.resource.prefer-token-info=false

Pod wpisami `security.oauth2.client.client-id` oraz `security.oauth2.client.client-secret` ustawiamy dane wygenerowane w serwisie **GitHub**. Opis jak wygenerować te dane:

*   [https://developer.github.com/apps/building-oauth-apps/creating-an-oauth-app/](https://developer.github.com/apps/building-oauth-apps/creating-an-oauth-app/)

### Flow

Po wejściu na "chroniony" adres, czyli w naszym przypadku `/not-for-all` sprawdzane jest to, czy jesteśmy zalogowani. Jeśli nie, następuje przekierowanie na stronę `/login`. Następnie sprawdzane jest, jaki sposób uwierzytelniania wybraliśmy. Wybraliśmy **SSO**, więc następuje przekierowanie na adres `security.oauth2.client.user-authorization-uri` wraz z przygotowanymi parametrami:

*   **client\_id** - wygenerowane w serwisie unikalne ID (to które ustawiliśmy w `security.oauth2.client.client-id`)
*   **redirect\_uri** - adres, na który zostanie przekierowany użytkownik po poprawnym zalogowaniu
*   **response\_type** - typ odpowiedzi, w naszym przypadku oczekujemy typu **code**
*   **state** - unikalny ciąg znaków dla bezpieczeństwa

Przykładowy adres:

https://github.com/login/oauth/authorize?client\_id=generated-id&redirect\_uri=http://localhost:9191/login&response\_type=code&state=yz1Bhx

Jeśli użytkownik wpisał poprawne dane, jesteśmy z powrotem przekierowywani na naszą stronę, tym razem z wygenerowanym parametrem `code` (tym samym, który ustawialiśmy w `response_type`):

http://localhost:9191/login?code=404e60f9ab4208bde000&state=yz1Bhx

Teraz wysyłany jest **POST** na adres z `security.oauth2.client.access-token-uri`, aby zdobyć token. W tym żądaniu zawarte są takie informacje jak:

*   **client\_id** - wygenerowane w serwisie unikalne ID (to które ustawiliśmy w `security.oauth2.client.client-id`)
*   **client\_secret** - wygenerowany w serwisie kod secret (ten który ustawiliśmy w `security.oauth2.client.client-secret`)
*   **code** - wygenerowany kod w poprzednim kroku
*   **grant\_type** - typ uprawnień, w naszym przypadku authorization\_code
*   **redirect\_uri** - adres, na który zostanie przekierowany użytkownik po poprawnym zalogowaniu

W odpowiedzi otrzymujemy `access_token` typu `Bearer`. Od teraz wszystkie nasze requesty będą podpisane tym tokenem. Następnie wracamy do naszego flow i w odpowiedzi w nagłówku `Location` otrzymujemy `Location: http://localhost:9191/not-for-all` i jesteśmy przekierowywani na nasz "chroniony" zasób.

### Uruchamiamy

Możemy teraz uruchomić aplikację i udać się pod adres `/for-all`. Powinien pokazać się napis "_Code Couple!_". Natomiast dla `/not-for-all` powinna pojawić się strona do logowania dla **GitHub'a**, po poprawnym zalogowaniu przeglądarka przenosi nas na nasz zasób z napisem "_Code Couple is awesome!_"

### GitHub

Całość jak zawsze na [GitHubie](https://github.com/kchrusciel/Spring-Boot-Examples/tree/master/spring-boot-sso-example).