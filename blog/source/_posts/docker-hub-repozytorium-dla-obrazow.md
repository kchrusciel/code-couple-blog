---
title: Docker Hub - repozytorium dla obrazów
tags:
  - docker
  - docker hub
  - dockerfile
id: '2325'
categories:
  - - Cloud
  - - Docker
date: 2017-12-01 12:22:28
---

![](https://www.docker.com/sites/default/files/Whale%20Logo332_5.png)

We wcześniejszy wpisach na temat **Dockera** poruszyliśmy zagadnienia takie jak pliki [Dockerfile](http://codecouple.pl/2017/10/13/20-spring-boot-szybki-start-z-dockerem/) oraz narzędzie [Docker Compose](http://codecouple.pl/2017/11/10/docker-compose-odpalamy-wiele-kontenerow/). Dziś pokażę wam jak w łatwy sposób umieszczać obrazy w **DockerHub'ie**. [DockerHub](https://hub.docker.com/) podobnie jak **GitHub** jest repozytorium, w którym możemy przechowywać stworzone przez nas obrazy. W pakiecie dostajemy **jedno darmowe** prywatne repozytorium oraz nielimitowaną ilość publicznych repozytoriów.
<!-- more -->
### Utworzenie konta na Docker Hub

Na początek zakładamy konto na [https://hub.docker.com/](https://hub.docker.com/).

### Tworzymy repozytorium

Jeśli stworzyliśmy konto, możemy przystąpić do utworzenia naszego repozytorium (wpisujemy dane według własnych potrzeb, jeśli ma być to repo publiczne dobry opis jest wskazany): ![](http://codecouple.pl/wp-content/uploads/2017/12/createRepo.png) Po utworzeniu, będzie ono dostępne: ![](http://codecouple.pl/wp-content/uploads/2017/12/createdRepo.png)

### Wrzucamy obraz na DockerHub

Wracamy na nasze środowisko. Tworzymy naszą aplikację wraz z plikiem **Dockerfile**. W moim przykładzie wykorzystam [tę aplikację](https://github.com/kchrusciel/Spring-Boot-Examples/tree/master/spring-boot-docker-compose-example/producer). Na początek logujemy się w terminalu do naszego konta na **DockerHub**:

docker login

Następnie budujemy nasz obraz. Należy pamiętać, aby poprzedzić nazwę obrazu nazwą naszego użytkownika oraz o użyciu odpowiednich tagów (w moim przypadku `latest`):

docker build -t kchrusciel/code-couple-email-producer:latest .

Teraz, jeśli jesteśmy zalogowani i mamy zbudowany obraz z odpowiednią nazwą, możemy **wypushować** nasz obraz:

docker push kchrusciel/code-couple-email-producer

Gdy nasz obraz znajduje się teraz w repozytorium można wykorzystywać go do budowania innych obrazów oraz dzielenia się wynikami naszej pracy: ![](http://codecouple.pl/wp-content/uploads/2017/12/pushedRepo.png)

docker pull kchrusciel/code-couple-email-producer

Lub na przykład w plikach **Dockerfile**:

FROM kchrusciel:code-couple-email-producer

Był to kolejny wpis z serii **Dockerowej**, zapraszam na kolejne!