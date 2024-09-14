---
title: '#16 Spring Boot - Cloud Config'
tags:
  - spring
  - spring boot
  - spring cloud
id: '1781'
categories:
  - - Spring Boot
date: 2017-06-23 14:57:46
author: 'Krzysztof Chruściel'
---

[![](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)

**Spring Cloud** we współpracy z **Netflixem** w bardzo pozytywny sposób ułatwiają pracę w architekturze **mikroserwisów**. Dostarczają oni wiele mechanizmów które pozwalają spełnić założenia jakie stawia poprawne tworzenie **mikroserwisów**. Pierwszym narzędziem **Cloudowym** który przedstawię jest **Cloud Config**.
<!-- more -->
### 12 Factor manifesto

[12 Factor manifesto](https://12factor.net/pl/) zawiera 12 punktów które powinna spełnia aplikacja w środowisku rozproszonym. Jeden z punktów mówi o tym, że ustawienia specyficzne dla danego środowiska powinny znajdować się tylko na nim. Domyślna implementacja **application.properties** spełnia te założenia, jednakże rozwiązanie to ma kilka wad.

### Brak historii

Aktualnie (bez korzystania z **Spring Cloud Config**) najczęściej trzymamy nasze ustawienia razem z kodem w jakiś plikach typu **properties** (najgorzej jeśli te wartości są **zahardkodowane**!). Nie jest to dobre rozwiązaniem, ponieważ może zdarzyć się, że przez przypadek zacommitujemy nasz plik z hasłami lub ustawieniami z którymi nie chcemy dzielić się z innymi. Jeśli nie przechowujemy naszych plików z konfiguracją na jakimś serwerze z systemem kontroli wersji tracimy możliwość przeglądania historii tych plików. Potem możemy stracić dużo czasu na rozmyślanie dlaczego ktoś zmienił jakąś wartość w propertiesach.

### Brak możliwości współdzielenia informacji

Kolejnym minusem trzymania konfiguracji w lokalnych plikach jest brak możliwości dzielenia się ustawieniami pomiędzy **mikroserwisami**. Bez serwera z konfiguracjami musimy kopiować zawartość plików które można by uwspólnić.

### Bezpieczeństwo

W kwestii bezpieczeństwa przechowywanie **haseł** czystym **plain textem** nie jest bezpiecznym rozwiązaniem.

### Zmiany w plikach

Problemem jest także przeładowywanie aplikacji po każdej zmianie w **properties**. **Killer featurem** który rozwiązuje ten problem jest `@RefreshScope.` **Spring Cloud Config** dostarcza mechanizm który w łatwy sposób może odświeżyć kontekst aplikacji bez potrzeby ponownego jej uruchomienia.

### Config Server

Korzystanie z **Spring Cloud Config** zaczynamy od stworzenia serwera który będzie dostarczał propertiesy. Adnotacja `@EnableConfigServer` uruchamia naszą aplikację jako serwer, według konwencji port **8888** jest portem jaki powinniśmy ustawiać dla serwera. W kolejnym kroku dodajemy wpisy do pliku application.properties. **Cloud Config** domyślnie korzysta z **Git'a** dlatego też wszystkie **propertiesy** powinniśmy przechowywać właśnie tam. Dla treningu można stworzyć sobie lokalne repozytorium w którym umieszczamy dwa pliki konfiguracyjne: `application.properties` oraz `client-service.properties`. Ścieżkę do repozytorium ustawiamy pod wpisem `spring.cloud.config.server.git.uri`. Minimalna konfiguracja:

@SpringBootApplication
@EnableConfigServer
public class ConfigServerApplication {

   public static void main(String\[\] args) {
      SpringApplication.run(ConfigServerApplication.class, args);
   }
}

#Applicatione name
spring.application.name=config-server
#Conventional port number
server.port=8888
#URI to GIT with all properties
spring.cloud.config.server.git.uri=GIT-URI-HERE

Po uruchomieniu serwera wystarczy wejść pod adres [http://localhost:8888/application/master](http://localhost:8888/application/master) aby zobaczyć wpisy dla naszego pliku `application.properties`. Natomiast każde inne **property** poprzedzamy nazwą pliku. Dla `client-service.properties` będzie to adres [http://localhost:8888/client-service/master](http://localhost:8888/client-service/master). GitHub dla serwera: [https://github.com/kchrusciel/spring-boot-config-server-example](https://github.com/kchrusciel/spring-boot-config-server-example).

### Config Client

Aby móc korzystać z serwera konfiguracji musimy wykorzystać fazę **bootstrapowania** aplikacji. Aby to zrobić musimy utworzyć plik `bootstrap.properties`, który jest ładowany w tej fazie. Jest on identyczny jak plik `application.properites` jednakże ładowany jest w innej fazie uruchamiania.

> A Spring Cloud application operates by creating a "bootstrap" context, which is a parent context for the main application. **_Out of the box it is responsible for loading configuration properties from the external sources_**, and also decrypting properties in the local external configuration files.

W tym pliku ustawiamy nazwę aplikacji `spring.application.name=config-client`. Nazwa ta powinna być odpowiednia dla nazwy pliku **properties** który znajduje się w repozytorium (w naszym przypadku jest to `config-client)`. Kolejnym elementem jest ustawienie adresu serwera konfiguracji, `spring.cloud.config.uri=http://localhost:8888`. Wartość `http://localhost:8888` jest wartością domyślną, więc tak naprawdę wpis ten jest nadmiarowy (zostawiam dla czytelności).

#Application name
spring.application.name=client-service
#Config server address by default is 8888
spring.cloud.config.uri=http://localhost:8888

### Refresh Scope

`@RefreshScope` jest adnotacją która pozwala nam odświeżyć wykorzystywane przez nas property bez potrzeby przeładowywania aplikacji. Jest to rozwiązanie które eliminuje wadę wymienioną we wstępie. Na początek do naszego config-client dodajemy endpoint `/message`:

@RestController
@RefreshScope
public class ConfigClientController {

    @Value("${info.property}")
    private String property;

    @GetMapping("/message")
    String property() {
        return property;
    }

}

Który wyświetla nam zawartość property `info.property`. Dodajmy teraz ten wpis do naszego `config-client.properties`, przykładowo `info.property=CodeCouple` (należy **zacommitować** tą zmianę jeśli korzystamy z GIT'a) a następnie uruchamiamy aplikację. Pod endpointem `/message` wyświetli nam się napis **CodeCouple**. Teraz zmieniamy znów tą wartość w pliku `config-client.properties` na `info.property=CodeCouple roxx!!`. Po ponownym odświeżeniu `/message` nadal widzimy starą wartość. Aby wykorzystać możliwości `@RefreshScope` musimy wykorzystać acutatory i wysłać puste żądanie **POST** na endpoint `/refresh`, teraz bez potrzeby restartu aplikacji powinniśmy widzieć nową zawartość (odśwież przeglądarkę jeśli nie widzisz zmiany).

### Szyfrowanie

Uwaga! Aby to zadziałało [należy zainstalować JCE](http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html).

W bardzo prosty sposób możemy rozwiązać problem szyfrowania haseł. Na naszym serwerze konfiguracji ustawiamy wartość dla `encrypt.key`:

#Cipher value, this value should comes from ENV variables
encrypt.key=secret

Wartość `secret` jest ustawiona dla przykładu, jednakże wartość ta powinna pochodzić ze zmiennych środowiskowych lub z jakiegoś **jks** z kluczami. Następnie mamy dostępne dwa endpointy, `decrypt` oraz `encrypt`. Pod adres `encrypt` uderzamy **POST'em** z naszą wartością którą chcemy zaszyfrować kluczem:

curl localhost:8888/encrypt -d szyfrujemy
bfed366b135b6d96d736571d2131e330fc34e0396cde0ab430429fe9373ba9d0

W odpowiedzi dostajemy zaszyfrowaną wartość która do enkrypcji wykorzystała nasz klucz z `encrypt.key`. Teraz na naszym serwerze **Gitowym** wystarczy poprzedzić wartość kluczem `{cipher}`:

info.encrypted.property={cipher}bfed366b135b6d96d736571d2131e330fc34e0396cde0ab430429fe9373ba9d0

Teraz możemy używać tej wartości która w momencie użycia zostanie odszyfrowana. Dla testu możemy wysłać **POST'a** na adres `decrypt`:

curl localhost:8888/decrypt -d bfed366b135b6d96d736571d2131e330fc34e0396cde0ab430429fe9373ba9d0
szyfrujemy

### More

Więcej informacji na temat dobrych praktyk znajdziecie [TUTAJ](https://12factor.net/pl/config). Linki do [GitHuba](https://github.com/kchrusciel/Spring-Boot-Examples/tree/master/spring-boot-config-example).