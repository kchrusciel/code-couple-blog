---
title: Docker Compose - odpalamy wiele kontenerów
tags:
  - docker
  - docker compose
id: '2269'
categories:
  - - Docker
date: 2017-11-10 12:05:32
---

![](https://www.docker.com/sites/default/files/Whale%20Logo332_5.png)

**Docker Compose** jest kolejnym krokiem w pracy z kontenerami. Służy do uruchamiania i definiowania aplikacji składającej się z wielu kontenerów. Definiując pojedynczy plik **Dockerfile** nie mamy problemu z uruchomieniem go, jeśli natomiast mamy wiele takich plików pojawia się bardzo duża złożoność. Rozwiązaniem problemu jest **Docker Compose**.
<!-- more -->
**Uwaga!** Aby korzystać z **Docker Compose** wymagana jest [instalacja **Dockera**.](https://codecouple.pl/2016/03/14/docker-pierwsze-kroki/)

Na początek zacznijmy od stworzenia dwóch plików **Dockerfile** dla naszych aplikacji. Pierwszy, który będzie producentem wiadomości na kolejkę:

FROM openjdk:8-jre-alpine
ADD target/producer-docker.jar producer-docker.jar
EXPOSE 8081
EXPOSE 8001
ENTRYPOINT \["java", "-agentlib:jdwp=transport=dt\_socket,server=y,suspend=n,address=8001", "-jar", "producer-docker.jar"\]

Natomiast plik **Dockerfile** dla consumera naszych wiadomości będzie wyglądał następująco:

FROM openjdk:8-jre-alpine
ADD target/consumer-docker.jar consumer-docker.jar
EXPOSE 8082
EXPOSE 8002
ENTRYPOINT \["java", "-agentlib:jdwp=transport=dt\_socket,server=y,suspend=n,address=8002", "-jar", "consumer-docker.jar"\]

Gdy stworzyliśmy pliki **Dockerfile** możemy przystąpić do utworzenia pliku `docker-compose.yml`.

version: '3'
services:
    rabbitmq:
        image: rabbitmq:3.6-management-alpine
        ports:
            - "5672:5672"
            - "15672:15672"
    producer:
        build: ./producer
        ports:
            - "8081:8081"
            - "8001:8001"
        links:
            - rabbitmq
        environment:
            RABBIT\_HOST: rabbitmq
    consumer:
        build: ./consumer
        ports:
            - "8082:8082"
            - "8002:8002"
        links:
            - rabbitmq
        environment:
            RABBIT\_HOST: rabbitmq

gdzie:

*   `version` - oznacza wersję **Docker Compose** (aktualna wersja to 3.3)
*   `services` - sekcja, w której definiujemy serwisy
*   `rabbitmq/producer/consumer` - nazwa własna usługi
*   `image` - wskazujemy z jakiego obrazu ma być zbudowany kontener
*   `build` - wskazujemy ścieżkę do pliku **Dockerfile** naszego serwisu
*   `ports` - definiujemy porty, które będą mapowane z konteneru
*   `links` - zależność pomiędzy kontenerami, `producer` oraz `consumer` "widzą się" z `rabbitmq`, czyli mogą korzystać z jego usług
*   `environment` - zmienna środowiskowa dla danego kontenera

Aby uruchomić **Docker Compose** w naszym terminalu **Dockerowym** używamy polecenia (tam gdzie mamy plik `docker-compose.yml`):

docker-compose up

Aby sprawdzić czy nasze kontenery pracują:

docker-compose ps

Teraz wystarczy udać się pod wybrany przez nas adres. Jeśli zakończyliśmy pracę z naszymi kontenerami wydajemy polecenie (tam gdzie mamy plik `docker-compose.yml`), które stopuje kontenery:

docker-compose stop

Usunięcie kontenerów osiągniemy dzięki (polecenie uruchamiamy tam gdzie mamy plik `docker-compose.yml`):

docker-compose rm

### Github

Całość jak zawsze na [GitHub](https://github.com/kchrusciel/Spring-Boot-Examples/tree/master/spring-boot-docker-compose-example).