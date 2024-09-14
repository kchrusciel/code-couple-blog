---
title: '#0 Spring Boot 2 - Introduction'
tags:
  - spring
  - spring boot
  - spring boot 2
id: '2543'
categories:
  - - Spring
  - - Spring Boot
date: 2018-07-13 20:01:57
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/12/springBoot2Art.png)

Z początkiem roku już oficjalnie dołączył do nas **Spring Boot** w wersji **2.0**. Wiele się zmieniło w porównaniu do wersji poprzedniej. Od teraz **Spring Boot** stoi pod hasłem programowanie reaktywne. Najnowszy **Spring Boot** oparty jest na projekcie [Project Reactor](https://projectreactor.io/), który jest **Spring'ową** implementacją specyfikacji [Reactive Streams](https://github.com/reactive-streams/reactive-streams-jvm).
<!-- more -->
### Zaczynamy

Od wersji 2.0 mamy możliwość wyboru, czy chcemy korzystać z **reaktywnego stosu** czy **stosu opartego o serwlety**. Reaktywny stos pozwala nam korzystać ze wszystkich benefitów związanych z paradygmatem programowania reaktywnego. Możemy tworzyć nieblokujące wywołania logiki naszej aplikacji. Pojawiło się także oficjalne wsparcie dla **Javy 9**, dlatego też **Java 7** nie jest już dłużej obsługiwana. W **Javie 9** została wprowadzona nowa klasa `java.util.concurrent.Flow`, która definiuje kontrakt zawarty w [Reactive Streams](https://github.com/reactive-streams/reactive-streams-jvm).

### Flux i Mono

![](https://i0.wp.com/therealdanvega.com/wp-content/uploads/2018/02/reactive_stack.png)

Jak napisałem we wstępie reaktywny stos opiera się na [Project Reactor](https://projectreactor.io/), który jest implementacją [Reactive Streams](https://github.com/reactive-streams/reactive-streams-jvm), natomiast sama część webowa na **WebFlux**. Stosowanie **WebFlux** wiąże się ze znajomością dwóch nowych pojęć:

*   **Flux** - do zwracania strumienia z  0..n danymi
*   **Mono** - do zwracania strumienia z  0..1 danymi

Od teraz możemy zmienić nasze kontrolery na bardziej "reactive" poprzez stosowanie pojęć wymienionych powyżej. Przykładowo:

@RestController
class WebController {

    @GetMapping
    Mono<String> helloCodeCouple() {
        return Mono.just("Hello Code Couple!");
    }

    @GetMapping("flux")
    Flux<String> helloCodeCoupleFlux() {
        return Flux.fromStream(Stream.of("Hello", "Code", "Couple"));
    }

}

### Tomcat vs Netty

Jeśli zdecydowaliśmy się na **stos reaktywny**, to domyślnym środowiskiem uruchomieniowym nie jest już **Tomcat**, a **Netty**:

2018-05-06 11:53:51.405 INFO 4332 --- \[ctor-http-nio-1\] r.ipc.netty.tcp.BlockingNettyContext : Started HttpServer on /0:0:0:0:0:0:0:0:8080
2018-05-06 11:53:51.405 INFO 4332 --- \[ main\] o.s.b.web.embedded.netty.NettyWebServer : Netty started on port(s): 8080

### Metryki

Kolejną bardzo dużą zmianą w stosunku do poprzedniej wersji są metryki. Pierwszy zagadanieniem jest bezpieczeństwo. Dotychczas project **Actuator** używał swojego mechanizmu do zabezpieczania metryk, co doprowadzało do wielu problemów, ponieważ musieliśmy utrzymywać dwie konfiguracje. W nowej wersji konfigurację bezpieczeństwa metryk ustawiamy tak samo jak dla innych endpointów. Projekt [Micrometer](https://micrometer.io/) jest teraz fasadą dla metryk. Inżynierowie ze Spring'a uznali, iż nie chcą ingerować w to jaki system metryk chcemy wybrać, dlatego udostępniają abstrakcję w postaci **Micrometer**, która dostarcza wsparcie dla wielu systemów do metryk.

### Delta

Projekt **DevTools** został wprowadzony w **Spring Boot'cie 1.3**. Pozwala on między innymi na korzystanie z funkcjonalności [LiveReload](http://codecouple.pl/2016/08/30/5-spring-boot-livereload/). Od wersji **2.0** przy każdy przeładowaniu aplikacji ukazuje nam się raport z wprowadzonymi zmianami. Przykładowo jeśli dodaliśmy nowy **bean** lub zmieniliśmy coś w pliku **properties** to wynik tych zmian zostanie wypisany w konsoli. Więcej informacji o [DevTools](https://docs.spring.io/spring-boot/docs/current/reference/html/using-boot-devtools.html).

### GitHub

Przykładowy serwis **REST'owy** znajdziecie na moim [GitHubie](https://github.com/kchrusciel/Spring-Boot-2-Examples). Ponadto zapraszam na kolejne wpisy traktujące o **Spring Boot'cie 2.0**!