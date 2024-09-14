---
title: '#19 Spring Boot – Microservice Registration and Discovery - Eureka'
tags:
  - cloud
  - eureka
  - microservices
  - service discovery
  - spring
  - spring boot
  - spring cloud
id: '1928'
categories:
  - - Cloud
  - - Spring Boot
date: 2017-09-29 12:05:38
author: 'Krzysztof Chruściel'
---

[![](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)**Service Discovery** jest kolejnym mechanizmem wykorzystywanym w środowisku **cloudowym**. Najpopularniejsze implementacje tego mechanizmu to między innymi: **Consul**, **Zookeeper** czy **Eureka** ze stajni Netflix. **Spring Cloud** wykorzystał implementacje firmy Netflix i stworzył swój wrapper, który w bardzo szybki i łatwy sposób pozwala integrować się z całym stosem **Spring Cloud**.
<!-- more -->
### Server

Zaczynamy od uruchomienia serwera. Dodajemy zależność do **Mavena**:

<dependency>
   <groupId>org.springframework.cloud</groupId>
   <artifactId>spring-cloud-starter-eureka-server</artifactId>
</dependency>

Aby wskazać, iż nasza aplikacja będzie serwerem należy użyć adnotacji `@EnableEurekaServer`.

@SpringBootApplication
@EnableEurekaServer
public class SpringBootEurekaServerExampleApplication {

   public static void main(String\[\] args) {
      SpringApplication.run(SpringBootEurekaServerExampleApplication.class, args);
   }
}

Warto dodać także kilka wpisów w `application.properties`:

#Conventional Eureka port
server.port=8761
#Application name
spring.application.name=eureka-server
#Server is not registered with eureka
eureka.client.register-with-eureka=false
#Server is not fetching registry
eureka.client.fetch-registry=false

#Security
security.user.name=user
security.user.password=password

Portem dla serwera według konwencji jest **8761**. Domyślnie nasz serwer zarejestruje siebie samego, aby wyłączyć tą opcje dodajemy wpis `eureka.client.register-with-eureka=false`. Warto pomyśleć także nad zabezpieczeniem tej usługi!

### Client

Dodajmy teraz klienta, czyli aplikację, która będzie rejestrować się na serwerze. W naszej aplikacji umieszczamy adnotację `@EnableDiscoveryClient`, która aktywuje implementacje `DiscoveryClient`. Domyślnie jest to implementacja **Netflix Eureka**, jednakże tak jak pisałem we wstępie, istnieją także inne implementacje jak **Zookeeper** czy **Consul**.

@SpringBootApplication
@EnableDiscoveryClient
public class SpringBootEurekaClientExampleApplication {

   public static void main(String\[\] args) {
      SpringApplication.run(SpringBootEurekaClientExampleApplication.class, args);
   }
}

Dodajemy zależność do **Mavena**:

<dependency>
   <groupId>org.springframework.cloud</groupId>
   <artifactId>spring-cloud-starter-eureka</artifactId>
</dependency>

Dodajmy też endpoint dla testów:

@RestController
public class ClientController {

    @GetMapping("/codecouple")
    public String showCodeCouple() {
        return "CodeCouple";
    }
}

To pod jaką nazwą będzie widoczny nasz klient na serwerze zależy od wpisu `spring.application.name` w pliku `application.properites`:

#Random server port
server.port=0
#Application name
spring.application.name=client-example
#Default zone
eureka.client.serviceUrl.defaultZone=http://user:password@localhost:8761/eureka/

### Application

Na koniec tworzymy kolejnego klienta:

@SpringBootApplication
@EnableDiscoveryClient
public class SpringBootEurekaAppExampleApplication {

   public static void main(String\[\] args) {
      SpringApplication.run(SpringBootEurekaAppExampleApplication.class, args);
   }

   @Bean
   @LoadBalanced
   public RestTemplate restTemplate() {
      return new RestTemplate();
   }
}

Dodajemy zależność do **Mavena**:

<dependency>
   <groupId>org.springframework.cloud</groupId>
   <artifactId>spring-cloud-starter-eureka</artifactId>
</dependency>

Możemy teraz stworzyć kontroler, który będzie się komunikował z naszym klientem wykorzystując `RestTemplate`. Jak widać w przykładzie nie hardkodujemy nigdzie adresu IP oraz portu do `client-example`, wykorzystujemy natomiast klienta zarejestrowanego w naszym **Service Discovery**.

@RestController
public class CodeCoupleController {

    private final RestTemplate restTemplate;

    public CodeCoupleController(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    @GetMapping("/show")
    public String showCodeCoupleRoxx(){
        return restTemplate.getForObject("http://client-example/codecouple", String.class) + " Roxx!";
    }
}

Na koniec te same ustawienia co w pierwszym kliencie:

#Server port
server.port=0
#Application name
spring.application.name=app-example
#Default zone
eureka.client.serviceUrl.defaultZone=http://user:password@localhost:8761/eureka/

### GitHub

Cały projekt jak zawsze znajdziecie na [**GitHubie**](https://github.com/kchrusciel/Spring-Boot-Examples/tree/master/spring-boot-eureka-example).