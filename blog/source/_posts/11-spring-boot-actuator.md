---
title: '#11 Spring Boot - Insensitive Actuator'
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

[![springBootArt](https://raw.githubusercontent.com/kchrusciel/code-couple-blog-assets/main/2017/02/springBootArt.png)](https://raw.githubusercontent.com/kchrusciel/code-couple-blog-assets/main/2017/02/springBootArt.png)

Jednym z głównych założeń **Spring Boot** jest to, aby framework był _production ready_. Autorzy frameworku rozumieją przez **production ready** między innymi to, że aplikacja będzie dostarczać metryki **out-of-the-box**. Aby dodać metryki do swojego projektu, wystarczy dopisać jedną pozycję do zależności Maven. Jest to biblioteka **Actuator**.
<!-- more -->

Zacznijmy od dodania zależności Maven, czyli `spring-boot-starter-actuator`:

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-actuator</artifactId>
    </dependency>
</dependencies>
```

Na wstępie warto wspomnieć, że endpointy z pakietu **Actuator** mogą być *sensitive*. Oznacza to, że są dostępne z lub bez potrzeby logowania do aplikacji. Dziś opiszę te, które są dostępne bez logowania, czyli są **insensitive**. Tymi endpointami są:

* `/info`
* `/health`

### Info

Pierwszym omawianym endpointem jest `/info`. Zwraca on informacje na temat naszej aplikacji:

```json
{}
```

Otrzymaliśmy pusty wynik, ponieważ nie zdefiniowaliśmy w `application.properties` żadnych informacji o aplikacji. Aby dodać własne dane, musimy poprzedzić je słowem `info`:

```properties
info.site.name=CodeCouple.pl
info.site.authors=Krzysztof Chrusciel, Agnieszka Chrusciel
```

W rezultacie otrzymujemy:

```json
{
  "site": {
    "authors": "Krzysztof Chrusciel, Agnieszka Chrusciel",
    "name": "CodeCouple.pl"
  }
}
```

Możemy także rozszerzyć informacje o naszej aplikacji, wyświetlając dane na temat **build'a** (z pliku `META-INF/build-info.properties`) oraz dane z **GIT'a** (z pliku `git.properties`). Aby to osiągnąć, musimy dodać odpowiednie kroki do budowania. Krok `build-info` automatycznie doda plik `build-info.properties`. Natomiast plugin `git-commit-id-plugin` jest odpowiedzialny za stworzenie pliku `git.properties`.

```xml
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
```

W rezultacie otrzymamy:

```json
{
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
}
```

Możemy jeszcze bardziej rozszerzyć zbiór informacji z **GIT'a**. Wystarczy w `application.properties` dodać wpis:

```properties
management.info.git.mode=full
```

W łatwy sposób możemy dodać własne informacje w kodzie, jeśli z jakichś przyczyn nie chcemy, aby były one zmieniane w `application.properties`. Wystarczy zarejestrować komponent (`@Component`), który implementuje interfejs `InfoContributor`:

```java
@Component
public class CustomInfoContributor implements InfoContributor {

    @Override
    public void contribute(Info.Builder builder) {
        builder.withDetail("Blog",
                Collections.singletonMap("authors", "Agnieszka Pieszczek, Krzysztof Chrusciel"));
        builder.withDetails(Collections.singletonMap("article", "#11 Spring Boot – Insensitive Actuator"));
    }
}
```

Nasze informacje zostaną zwrócone w postaci:

```json
{
   "Blog": {
      "authors": "Agnieszka Pieszczek, Krzysztof Chrusciel"
   },
   "article": "#11 Spring Boot – Insensitive Actuator"
}
```

Istnieje także możliwość przekazania informacji z **Mavena**. Wartość taką musimy umieścić pomiędzy znakami `@`:

```properties
info.app.encoding=@project.build.sourceEncoding@
info.app.java.source=@java.version@
info.app.java.target=@java.version@
```

### Health

Drugim omawianym endpointem jest `/health`, czyli **health checker**. Zwraca on informacje na temat statusu naszej aplikacji:

```json
{"status":"UP"}
```

Po zalogowaniu się do aplikacji dostajemy więcej informacji niż tylko prosty status. Otrzymujemy także stan naszej bazy danych (jeśli z niej korzystamy):

```json
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
```

Jeśli z jakichś przyczyn chcesz udostępnić informacje o używanej bazie danych bez potrzeby logowania, wystarczy dodać jeden wpis:

```properties
endpoints.health.sensitive=false
```

Status naszej aplikacji jest **cache'owany** co **1000 milisekund**, dzięki czemu unikniemy ataku typu **DoS**. Możemy zmienić tę wartość, używając:

```properties
endpoints.health.time-to-live
```

Podobnie jak w przypadku `InfoContributor`, możemy stworzyć własny `HealthIndicator`:

```java
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
```

To tylko dwa endpointy, a już możemy zawrzeć w nich tyle informacji! W następnym wpisie pokażę wam inne endpointy z pakietu **Actuator**, które są dostępne dopiero po zalogowaniu, oraz ich różne ciekawe właściwości.