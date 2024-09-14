---
title: '#25 Spring Boot - Turbine - wspólny dashboard'
tags:
  - hystrix
  - hystrix dashboard
  - spring boot
  - turbine
id: '2381'
categories:
  - - Spring Boot
date: 2017-12-22 12:11:14
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)

[W poprzednim wpis](http://codecouple.pl/2017/11/24/23-spring-boot-hystrix/)ie pokazywałem jak wykorzystać **Hystrix'a** jako jeden ze sposób realizacji wzorca **Circuit Breaker**. Pojawił się [także wpis dotyczący](http://codecouple.pl/2017/12/08/24-spring-boot-hystrix-dashboard/) **dashboard'u**, na którym wyświetlane były informacje dla danego **Circuit Breaker'a**. Niestety wadą tego rozwiązania było to, iż mieliśmy jeden **dashboard** per aplikacja, więc jeśli chcielibyśmy sprawdzać stan kilku **Circuit Breaker'ów** musielibyśmy przełączać się pomiędzy **dashboardami**. Rozwiązaniem tego problemu jest stworzenie jednego **strumienia** przy wykorzystaniu biblioteki **Turbine**.
<!-- more -->
### Discovery serwis

**Turbine**, aby móc połączyć się z innymi usługami, używa mechanizmu **Service Discovery.** Zaczynamy od uruchomienia usługi:

@SpringBootApplication
@EnableEurekaServer
public class DiscoveryServiceApplication {

   public static void main(String\[\] args) {
      SpringApplication.run(DiscoveryServiceApplication.class, args);
   }
}

Następnie konfigurujemy `application.properties`:

server.port=8761
spring.application.name=discovery-service
eureka.client.register-with-eureka=false
eureka.client.fetch-registry=false

Wszystkie serwisy zarejestrowane w naszej usłudze widoczne są pod `http://localhost:8761/`. Więcej informacji o **Service Discovery** [można przeczytać w tym artykule](http://codecouple.pl/2017/09/29/19-spring-boot-microservice-registration-and-discovery-eureka/).

### Pierwszy serwis

Pierwszy serwis będzie nazywał się `first-service`:

@SpringBootApplication
@EnableCircuitBreaker
@EnableHystrixDashboard
@EnableEurekaClient
public class FirstServiceApplication {

   public static void main(String\[\] args) {
      SpringApplication.run(FirstServiceApplication.class, args);
   }
}

Po uruchomieniu **Hystrixa**, musimy dodać klasę, która będzie przez niego obsługiwana:

@RestController
@RequestMapping("/")
public class HystrixController {

    @HystrixCommand(fallbackMethod = "fallback")
    @GetMapping
    String hystrixMethod(){
        if (RandomUtils.nextInt(10) > 5) {
            return "Bingo!";
        }
        throw new RuntimeException();
    }

    String fallback(){
        return "Fallback";
    }

}

Musimy także dodać kilka wpisów do `application.properties`:

server.port=8080
spring.application.name=first-service
eureka.client.service-url.defaultZone=http://localhost:8761/eureka

Aby sprawdzić czy **Hystrix** działa, odświeżamy nasz endpoint `http://localhost:8080/` kilka razy i oglądamy wynik na dashboardzie `http://localhost:8080/hystrix`, gdzie jako adres podajemy `http://localhost:8080/hystrix.stream`. W wyniku powinniśmy zobaczyć:

![](http://codecouple.pl/wp-content/uploads/2017/12/hystrixDashboard.png)

### Drugi serwis

Dla drugiego serwisu musimy wykonać te same kroki co dla pierwszego. Jedyna różnica to `application.properties`:

server.port=8081
spring.application.name=second-service
eureka.client.service-url.defaultZone=http://localhost:8761/eureka

### Turbine

Na początek dodajemy zależność do **Maven'a**:

<dependency>
   <groupId>org.springframework.cloud</groupId>
   <artifactId>spring-cloud-starter-turbine</artifactId>
</dependency>

Aby uruchomić **Turbine** musimy użyć adnotacji `@EnableTurbine`, następnie musimy dodać dashboard `@EnableHystrixDashboard`.

@SpringBootApplication
@EnableTurbine
@EnableEurekaClient
@EnableHystrixDashboard
public class TurbineServiceApplication {

   public static void main(String\[\] args) {
      SpringApplication.run(TurbineServiceApplication.class, args);
   }
}

W pliku `application.properties` musimy wskazać aplikacje, z których chcemy agregować nasze strumienie:

server.port=8989
spring.application.name=turbine-dashboard
eureka.client.service-url.defaultZone=http://localhost:8761/eureka
turbine.app-config=first-service,second-service
turbine.cluster-name-expression=new String("default")

Następnie udajemy się pod adres naszego dashboardu `http://localhost:8989/hystrix/` jako strumień podajemy `http://localhost:8989/turbine.stream`

![](http://codecouple.pl/wp-content/uploads/2018/01/turbine.png)

### GitHub

Całość jak zawsze na [GitHubie](https://github.com/kchrusciel/Spring-Boot-Examples/tree/master/spring-boot-hystrix-turbine-example).