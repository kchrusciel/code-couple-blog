---
title: '#17 Spring Boot – Distributed tracing - Zipkin i Sleuth'
tags:
  - sleuth
  - spring boot
  - spring cloud
  - zipkin
id: '1910'
categories:
  - - Cloud
  - - Spring Boot
date: 2017-07-21 13:13:19
author: 'Krzysztof Chruściel'
---

[![](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)

Każdy z nas, korzystając z architektury **microserwisów** posiada kilka usług które "**rozmawiają**" ze sobą. Jedna logiczna operacja, na przykład zakup czegoś w sklepie to tak na prawdę odwiedzenie kilku serwisów. Niestety podczas zakupu wystąpił błąd. Jak dowiedzieć się teraz w którym miejscu coś poszło nie tak? Można wchodzić po **SSH** na maszyny i robić **grepa** z **tailem** i szukać słówka **Error** ale jest to robota ręczna i męcząca. W odpowiedzi na zapotrzebowanie na rozproszone logowanie pokaże wam dziś **Zipkina**.
<!-- more -->
W tytule tego wpisu umieściłem dwa buzzwordy, **Zipkin** oraz **Sleuth**. Sleuth zapewnia **correlation ID** czyli unikalne ID który jest przekazywane pomiędzy requestami w jednym logicznym ciągu. Logiczny ciąg operacji w nomenklaturze **Dappera** oznaczany jest jako **trace**. Natomiast każda pośrednia operacja (jedna jednostka pracy, na przykład wysłanie requestu) w obrębie jednego **trace** nazywana jest **spanem**. Każda operacja składa się z czterech eventów:

*   **Client Send** - klient stworzył i wysłał request
*   **Server Received** - server odebrał request i zaczyna go przetwarzać
*   **Server Send** - server przetworzył request i wysyła go z powrotem do klient
*   **Client Received** - klient otrzymał przetworzony request

Przykładowe flow przez cztery serwisy, wszystkie eventy mają takie same **trace ID**: ![](https://raw.githubusercontent.com/spring-cloud/spring-cloud-sleuth/master/docs/src/main/asciidoc/images/trace-id.png) **Zipkin** jest swojego rodzaju bazą danych do której wysyłane są logi z **Sleutha.**

### Serwer

Tworzymy sobie nasz pierwszy serwis. Nazwiemy go `zipkin-server` musimy dodać adnotację `@EnableZipkinServer` ponieważ aplikacją ta będzie naszym serwerem Zipkinowym, czyli bazą danych dla logów.

@SpringBootApplication
@EnableZipkinServer
public class TracingServerApplication {

   public static void main(String\[\] args) {
      SpringApplication.run(TracingServerApplication.class, args);
   }
}

Musimy ustawić także port dla serwera według konwencji jest to port 9411 `server.port=9411`.

### Klient

Kolejny serwis będzie klientem który odpytuję inną usługę, nazwiemy ją `zipkin-client`. Tworzymy jeden endpoint `/hello` w którym wykonywana jest logika pobierania wartości z innego serwisu przy wykorzystaniu **RestTemplate**. Bardzo ważne jest oznaczenie **RestTemplate** jako `@Bean` ponieważ wtedy dodawany jest do niego interceptor odpowiedzialny za rozproszone logowanie, bez tego, nie otrzymamy pożądanego efektu. Dodajemy także **logger**, jest ważne aby w logach zobaczyć **correlation ID**.

@RestController
public class ClientController {

    private static final Logger LOG = Logger.getLogger(ClientController.class.getName());

    @Autowired
    private RestTemplate restTemplate;

    @Bean
    public RestTemplate getRestTemplate() {
        return new RestTemplate();
    }

    @GetMapping("/hello")
    String sayHello(){
        LOG.info("Hello from Client!");
        return restTemplate.getForEntity("http://localhost:8081/world", String.class).getBody();
    }

}

W pliku `application.properties` ustawiamy kilka wartości, takie jak nazwa aplikacji, adres oraz wartość samplera. `Sampler` jest to mechanizm odpowiedzialny za próbkowanie, domyślną wartością jest **10%**, oznacza to, że tylko **10%** requestów będzie wysyłanych do **Zipkina** czyli naszej bazy. Maksymalna wartość to **100%** czyli `1.0`:

spring.application.name=zipkin-client
server.port=8082
spring.sleuth.sampler.percentage=1.0

### Serwis

Ostatni serwis będzie odpytywany przez `zipkin-clienta` czyli naszą wcześniej stworzoną usługę. Nazwiemy go `zipkin-service`. W tym serwisie udostępnimy jeden endpoint `/world`.

@RestController
public class ServiceController {

    private static final Logger LOG = Logger.getLogger(ServiceController.class.getName());

    @GetMapping("/world")
    String sayWorld(){
        LOG.info("Hello from Service!");
        return "World";
    }

}

### Akcja!

Wywołajmy teraz akcję na naszym kliencie, wchodzimy pod adres /hello, w przeglądarce powinien pokazać się się napis "World". W logach naszej aplikacji klienckiej powinien pokazać się **log**:

2017-06-21 10:23:39.866  INFO \[zipkin-client,f74ca8ce515d5490,f74ca8ce515d5490,true\] 7864 --- \[nio-8082-exec-6\] pl.codecouple.ClientController           : Hello from Client!

który oznacza po kolei **\[nazwa\_usługi, traceID, spanID, czy wysyłać dane na Zipkina\]** - w pierwszym logu **spanID** jest zawsze taki sam jak **traceID**. Następnie udajemy się do logów naszego serwisu:

2017-06-21 10:23:40.014  INFO \[zipkin-service,f74ca8ce515d5490,c3a52d05d74b7602,true\] 7536 --- \[nio-8081-exec-1\] pl.codecouple.ServiceController          : Hello from Service!

Jak widzicie, **traceID** jest takie same, natomiast **spanID** oraz nazwa usługi są inne. Udało nam się dodać rozproszone logowanie!

### Zipkin UI

Dzięki wykorzystaniu **Zipkin UI** możemy przeglądać przebiegi  oraz czas wykonania naszych operacji. Domyślnym portem **UI** jest port **9411**. Jeśli wykonaliśmy uprzednio jakieś akcje powinniśmy widzieć w przebiegach różne **traces**. [![](http://codecouple.pl/wp-content/uploads/2017/06/zipkinTraces.png)](http://codecouple.pl/wp-content/uploads/2017/06/zipkinTraces.png)

Po wybraniu interesującego nas **trace**, pojawi nam się szczegółowy wynik z **spanami** które zawarte są w tym **trace**.

[![](http://codecouple.pl/wp-content/uploads/2017/06/zipkinTraceDetails.png)](http://codecouple.pl/wp-content/uploads/2017/06/zipkinTraceDetails.png)

Możemy teraz podejrzeć także szczegóły **spana**, należy tylko wybrać interesujący nas **span**, ja wybrałem **zipkin-service**.

[![](http://codecouple.pl/wp-content/uploads/2017/06/spanInfo.png)](http://codecouple.pl/wp-content/uploads/2017/06/spanInfo.png)

Znajduję się tu wiele informacji, jak przebieg naszych **eventów** opisanych we wstępie, oraz wiele różnych kluczy i wartości.

### More

Więcej możecie przeczytać w bardzo dobrze napisanej dokumentacji, źródła jak zwykle znajdziecie na moim **Githubie**:

*   Serwer - [spring-boot-zipkin-server-example](https://github.com/kchrusciel/Spring-Boot-Examples/tree/master/spring-boot-zipkin-example/spring-boot-zipkin-server-example)
*   Serwis - [spring-boot-zipkin-service-example](https://github.com/kchrusciel/Spring-Boot-Examples/tree/master/spring-boot-zipkin-example/spring-boot-zipkin-service-example)
*   Klient - [spring-boot-zipkin-client-example](https://github.com/kchrusciel/Spring-Boot-Examples/tree/master/spring-boot-zipkin-example/spring-boot-zipkin-client-example)