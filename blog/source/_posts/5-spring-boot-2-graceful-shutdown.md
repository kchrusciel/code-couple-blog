---
title: '#5 Spring Boot 2 - Graceful Shutdown'
tags:
  - graceful shutdown
  - spring
  - spring boot
  - spring boot 2
id: '3878'
category: Spring Boot 2
date: 2019-05-27 12:31:08
author: 'Krzysztof Chruściel'
---

![](https://codecouple.pl/wp-content/uploads/2017/12/springBoot2Art.png)

**Graceful Shutdown** jest mechanizmem, który pozwala na **zamknięcie** aplikacji w "_poprawny_" sposób. Ale co tak naprawdę oznacza, że zamykamy aplikację w "_poprawny_" sposób? Odpowiedzi na to pytanie będziemy szukać w dzisiejszym artykułe. Implementację mechanizmu **Graceful Shutdown** oprzemy na przykładzie aplikacji napisanej przy wykorzystaniu **Spring Boot 2**.
<!-- more -->
### Graceful Shutdown

Wyobraźmy sobie sytuację, w której na naszym **klastrze** mamy trzy instancje aplikacji w wersji _1.0.0_. Po pewnym czasie **wydajemy** nową wersję _1.1.0_ więc pora na **migrację** działających instancji. Istnieje wiele mechanizmów przełączania **ruchu** i **zmiany** wersji, jednakże zawsze musimy pamiętać o tym, aby przed zamknięciem zakończyć wszystkie rozpoczęte **procesy**. Poprawna obsługa tych rozpoczętych **procesów** określana jest mechanizmem **Graceful Shutdown**.

Najczęściej realizuje się to w taki sposób, iż w momencie otrzymania **sygnału** o zamknięciu aplikacji (na przykład **SIGTERM**), nasza aplikacja przestaje **przyjmować** nowy ruch i czeka na **zakończenie** wszystkich procesów. Należy uwzględnić tutaj także sytuacje **wyjątkowe**, w której pomimo **odroczonego** zamknięcia jakiś proces nadal się **wykonuje**. Wtedy najlepiej **zapisać** takie przetwarzanie w bazie danych i wykonać operację **jeszcze raz** na nowej wersji. Poniżej znajduje się przykład realizacji  **Graceful Shutdown** z wykorzystaniem **Spring Boot'a**.

### Długie zadanie

Na początku dodajmy **endpoint** `/long` symulujący długo wykonującą się pracę oraz `/veryLong`, który przekroczy czas naszego **Graceful** **Shutdown**:

```java
@RestController
public class LongController {

    private static final Logger logger = LoggerFactory.getLogger(LongController.class);

    @GetMapping("/long")
    String longJob() throws InterruptedException {
        logger.info("Start");
        Thread.sleep(30\_000);
        logger.info("Done");
        return "Done";
    }

    @GetMapping("/veryLong")
    String veryLongJob() throws InterruptedException {
        logger.info("Start");
        Thread.sleep(50\_000);
        logger.info("Done");
        return "Done";
    }

}
```

### Connector

Następnie musimy zaimplementować `Connector`. Będzie on wywoływany wtedy, gdy będziemy chcieli **zamknąć** kontener serwletów:

```java
@Component
public class TomcatGracefulShutdownConnector implements TomcatConnectorCustomizer {

    private volatile Connector connector;

    @Override
    public void customize(final Connector connector) {
        this.connector = connector;
    }

    public Optional<ThreadPoolExecutor> threadPoolExecutor() {
        this.connector.pause();
        Executor executor = this.connector.getProtocolHandler().getExecutor();
        if(executor instanceof ThreadPoolExecutor) {
            return Optional.of((ThreadPoolExecutor) executor);
        }
        return Optional.empty();
    }

}
```

### Factory

Kolejny krok to rejestracja **Bean'a** `GracefulShutdown` w **kontenerze** serwletów. Możemy to zrealizować za pomocą `WebServerFactoryCustomizer`, który parametryzowany jest odpowiednim **factory**. **Factory** zależy od tego na jakim **serwerze** uruchamiamy aplikację. Będą to odpowiednio:

*   `TomcatServletWebServerFactory` - dla **Tomcat'a**
*   `JettyServletWebServerFactory` - dla **Jetty**
*   `NettyReactiveWebServerFactory` - dla **Netty**
*   `UndertowServletWebServerFactory` dla **Undertow**

W tym przykładzie wykorzystamy `TomcatServletWebServerFactory`, w którym nadpiszemy metodę `customize`. W metodzie tej dodamy nasz `Connector`:

```java
@Component
public class TomcatWithGracefulShutdown implements WebServerFactoryCustomizer<TomcatServletWebServerFactory> {

    private final TomcatGracefulShutdownConnector gracefulShutdown;

    public TomcatWithGracefulShutdown(final TomcatGracefulShutdownConnector gracefulShutdown) {
        this.gracefulShutdown = gracefulShutdown;
    }

    @Override
   public void customize(TomcatServletWebServerFactory factory) {
       factory.addConnectorCustomizers(gracefulShutdown);
   }
}
```

### Obsługa

Nam sam koniec dodamy obsługę mechanizmu **Graceful Shutdown**. Reaguje on na zdarzenie `ContextClosedEvent`, który występuje w momencie zgłoszenia **zamknięcia** aplikacji. Następnie pobieramy **pulę wątków** z naszego kontenera serwletów i ją zamykamy. Na zamknięcie puli czekamy **maksymalnie** trzydzieści sekund (ten czas zależy od nas), dzięki czemu mamy możliwość **dokończenia** zadań:

```java
@Component
public class GracefulShutdown implements ApplicationListener<ContextClosedEvent> {

    private static final Logger logger = LoggerFactory.getLogger(GracefulShutdown.class);

    private final TomcatGracefulShutdownConnector gracefulShutdown;

    public GracefulShutdown(final TomcatGracefulShutdownConnector gracefulShutdown) {
        this.gracefulShutdown = gracefulShutdown;
    }

    @Override
    public void onApplicationEvent(final ContextClosedEvent contextClosedEvent) {
        try {
            final ThreadPoolExecutor threadPoolExecutor = gracefulShutdown.threadPoolExecutor().orElseThrow(IllegalStateException::new);
            threadPoolExecutor.shutdown();
            if(!threadPoolExecutor.awaitTermination(30, TimeUnit.SECONDS)) {
                logger.error("Not graceful");
            } else {
                logger.info("Graceful");
            }
        } catch(InterruptedException ex) {
            Thread.currentThread().interrupt();
        }
    }
}
```

### Testujemy!

Teraz pora na **uruchomienie** aplikacji i **sprawdzenie** naszego mechanizmu. Po **uruchomieniu** udajemy się na adres `/long` i w terminalu **przerywamy** proces (przykładowo pod system **Windows** jest to CTRL + C):

```
2019-04-23 20:31:31.617   : Start
^C
2019-04-23 20:32:01.352   : Done
2019-04-23 20:32:01.653   : Graceful
2019-04-23 20:32:01.655   : Shutting down ExecutorService 'taskScheduler'
2019-04-23 20:32:01.656   : Shutting down ExecutorService 'applicationTaskExecutor'
```

Jak widzicie powyżej, **sygnał** o zamknięciu aplikacji został wysłany, a mimo to została ona **zamknięta** dopiero po wykonaniu wszystkich zadań (lub trzydziestu sekundach). Sprawdźmy teraz działanie dla `/veryLong`:

```
2019-04-23 20:35:02.656   : Start
^C
2019-04-23 20:35:36.038   : Not Graceful
2019-04-23 20:35:36.040   : Shutting down ExecutorService 'taskScheduler'
2019-04-23 20:35:36.041   : Shutting down ExecutorService 'applicationTaskExecutor'
2019-04-23 20:35:38.228   : HandlerInterceptor.afterCompletion threw exception
```

Jak widzicie **dodanie** wsparcia dla **Graceful Shutdown** jest bardzo proste. Jednakże, moim zdaniem przydałoby się jakieś **natywne** wsparcie dla tego **rozwiązania** (na przykład w projekcie **actuator**?). Niestety jak narazie musi wystarczyć nam takie **rzeźbienie**.

### Github

Całość jak zawsze na [Github'ie](https://github.com/kchrusciel/Spring-Boot-2-Examples/tree/master/spring-boot-graceful-shutdown-example).