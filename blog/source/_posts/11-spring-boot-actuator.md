---
title: '#11 Spring Boot -  Insensitive Actuator'
tags:
  - Actuator
  - java
  - spring boot
id: '1462'
categories:
  - - Java
  - - Spring Boot
date: 2017-02-24 15:48:07
author: 'Krzysztof Chruściel'
---

[![springBootArt](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)

Jednym z głównych założeń **Spring Boot'a** jest to, aby był on production ready. Autorzy frameworku poprzez **production ready** rozumieli między innymi to, iż aplikacja dostanie metryki **out-of-the-box**. Aby dodać metryki do swojego projektu wystarczy dodać jedną pozycje w mavenowych zależnościach. Nazywa się ona **Actuator**.
<!-- more -->
Zacznijmy od dodania mavenowej zależności, dodajemy `spring-boot-starter-actuator`:

<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-actuator</artifactId>
    </dependency>
</dependencies>

Na samym wstępie warto wspomnieć, iż endpointy z pakietu A**ctuator** mogą być s**ensitive**. Oznacza to, iż są dostępne z lub bez potrzeby logowania do aplikacji. Dziś opiszę te, które są dostępne bez logowania, czyli są **insensitive**, takimi endpointami są:

*   /**info**,
*   /**health**

### Info

Pierwszym omawianym endpointem jest `/info`. Zwraca nam on informacje na temat naszej aplikacji:

{}

Otrzymaliśmy pusty wynik, ponieważ nie zdefiniowaliśmy w `application.properties` żadnych wpisów o aplikacji. Aby dodać jakieś informacje musimy poprzedzić je słowem `info`:

info.site.name=CodeCouple.pl
info.site.authors=Krzysztof Chrusciel, Agnieszka Pieszczek

Wtedy w wyniku otrzymujemy:

"site": {
 "authors": "Krzysztof Chrusciel, Agnieszka Pieszczek",
 "name": "CodeCouple.pl"
 },

Możemy także rozszerzyć informacje na temat naszej aplikacji. Możemy wyświetlić informację na temat build'a z pliku `META-INF/build-info.properties` oraz dane z **GIT'a** z pliku `git.properties`. Aby to osiągnąć musimy dodać kroki do budowania. Krok `build-info` doda nam automatycznie plik `build-info.properties`. Natomiast drugi plugin `git-commit-id-plugin` odpowiedzialny jest za stworzenie pliku `git.properties`.

<build>
   <plugins>
      <plugin>
         <groupId>org.springframework.boot</groupId>
         <artifactId>spring-boot-maven-plugin</artifactId>
         <executions>
            <execution>
               <goals>
                  <goal>build-info</goal>
               </goals>
            </execution>
         </executions>
      </plugin>
      <plugin>
         <groupId>pl.project13.maven</groupId>
         <artifactId>git-commit-id-plugin</artifactId>
      </plugin>
   </plugins>
</build>

W wyniku otrzymamy:

"build": {
"version": "0.0.1-SNAPSHOT",
"artifact": "spring-demo",
"name": "spring-demo",
"group": "pl.codecouple",
"time": 1488007497000
},
 "git": {
 "commit": {
 "time": 1488007334000,
 "id": "0216be1"
 },
 "branch": "master"
 }

Możemy jeszcze bardziej rozszerzyć zbiór informacji z **GIT'a**. Wystarczy w `application.properties` dodać wpis:

management.info.git.mode=full

W łatwy sposób możemy dodać swoje informacje w kodzie jeśli z jakiś przyczyn nie chcemy, aby zostały one zmienione w `application.properties`. Wystarczy zarejestrować `@Component,` który implementuje interfejs `InfoContributor`:

@Component
public class CustomInfoContributor implements InfoContributor {

    @Override
    public void contribute(Info.Builder builder) {
        builder.withDetail("Blog",
                Collections.singletonMap("authors", "Agnieszka Pieszczek, Krzysztof Chrusciel"));
        builder.withDetails(Collections.singletonMap("article", "#11 Spring Boot – Insensitive Actuator"));
    }
}

Nasze informacje:

{
   "Blog": {
      "authors": "Agnieszka Pieszczek, Krzysztof Chrusciel"
   },
   "article": "#11 Spring Boot – Insensitive Actuator"
}

Istnieje także możliwość przekazania informacji z **Mavena**. Wartość taką musimy umieścić pomiędzy znakami `@`:

info.app.encoding=@project.build.sourceEncoding@
info.app.java.source=@java.version@
info.app.java.target=@java.version@

### Health

Drugim omawianym endpointem `/health` jest **health checker**. Zwraca nam on informacje na temat statusu naszej aplikacji:

{"status":"UP"}

Po zalogowaniu się do aplikacji dostajemy już więcej informacji poza prostą informacją na temat statusu. Otrzymujemy także stan naszej bazy jeśli z niej korzystamy:

{
   "status": "UP",
   "diskSpace": {
      "status": "UP",
      "total": 290389487616,
      "free": 129824768000,
      "threshold": 10485760
   },
   "db": {
      "status": "UP",
      "database": "H2",
      "hello": 1
   }
}

Jeśli z jakiś przyczyn chcesz udostępnić informacje z jakiej bazy korzystasz bez potrzeby logowania wystarczy dodać jeden wpis:

endpoints.health.sensitive=false

Status naszej aplikacji jest cachowany co **1000 milisekund**, dzięki temu unikniemy ataku typu **DoS**. Możemy zmienić tą wartość:

endpoints.health.time-to-live

Podobnie jak w przypadku `InfoContributor` możemy stworzyć własny `HealthIndicator`:

@Component
public class CustomHealthContributor implements HealthIndicator {

    @Override
    public Health health() {
        int errorCode = check(); // perform some specific health check
        if (errorCode != 0) {
            return Health.down().withDetail("Error Code", errorCode).build();
        }
        return Health.up().withDetail("CodeCouple", Status.UP).build();
    }

    private int check(){
        return 0;
    }

}

To tylko dwa endpointy, a już możemy zawrzeć w nich tyle informacji! W następnym wpisie pokaże wam inne endpointy z pakietu **Actutor,** które dostępne są dopiero po zalogowaniu oraz ich różne ciekawe właściwości.