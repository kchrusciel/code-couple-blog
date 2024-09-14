---
title: '#20 Spring Boot - szybki start z Dockerem'
tags:
  - docker
  - spring
  - spring boot
id: '2201'
categories:
  - - Docker
  - - Spring Boot
date: 2017-10-13 12:15:52
author: 'Krzysztof Chruściel'
---

[![](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)

Jest to wpis dla osób, które chciałyby w szybki sposób uruchomić swoją aplikację **Spring Boot'ową** na **Dockerze**. Uruchamianie aplikacji na **kontenerach** ma wiele zalet, jedną z nich jest wspólne środowisko dla wszystkich developerów. Dzięki temu unikniemy "u mnie działa". Jak uruchamiać aplikację na kontenerze? Odpowiedź we wpisie.
<!-- more -->
Na początek warto stworzyć sobie prostą aplikację z jednym endpointem. Przykładowa aplikacja na [GitHubie](https://github.com/kchrusciel/Spring-Boot-Examples/tree/master/spring-boot-dockerfile-example).

### Dockerfile

W naszym projekcie **Spring Boot'owym** tworzymy nowy plik **Dockerfile**. W tym pliku wpisujemy:

FROM openjdk:8-jre-alpine
ADD target/code-couple-docker.jar code-couple-docker.jar
EXPOSE 8081
ENTRYPOINT \["java", "-jar", "code-couple-docker.jar"\]

gdzie:

*   `FROM` - wskazujemy obraz do budowy kontenera (minimalny system operacyjny z zależnościami)
*   `EXPOSE` - wskazujemy port, poprzez który będzie można komunikować się z kontenerem (port, który udostępnia kontener)
*   `ADD` - kopiujemy nasz plik do kontenera (kopiujemy naszą aplikację)
*   `ENTRYPOINT` - podajemy parametry do uruchomienia aplikacji (uruchamiamy jara)

### Deprecated

W linii `FROM` wybrałem wersję `open-jdk:8-jre-alpine`, a nie `java`, ponieważ oficjalne repozytorium `java` jest deprecated:

*   [https://hub.docker.com/\_/java/](https://hub.docker.com/_/java/) - repozytorium, które jest deprecated
*   [https://hub.docker.com/\_/openjdk/](https://hub.docker.com/_/openjdk/) - repozytorium, z którego należy korzystać

### JDK vs JRE

Jeśli zależy nam na optymalizacji naszych kontenerów powinniśmy zastanowić się, czy na pewno potrzebujemy całe **JDK**, czy samo **JRE** nie będzie wystarczające. W naszym przypadku **JRE** wystarczy.

### Debian vs Alpine

Jak widzicie, wybrałem wersję `8-jre-alpine` oznacza to, iż nasza wersja Javy będzie okrojona. Nie dostaniemy pakietów potrzebnych do między innymi **JavyFX**, czy **VisualVM** do monitoringu. Fragmenty, które zostały usunięte:

\# Download and unarchive Java
RUN mkdir /opt && curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie"\\
  http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz \\
     tar -xzf - -C /opt &&\\
    ln -s /opt/jdk1.7.0\_79 /opt/jdk &&\\
    rm -rf /opt/jdk/\*src.zip \\
           /opt/jdk/lib/missioncontrol \\
           /opt/jdk/lib/visualvm \\
           /opt/jdk/lib/\*javafx\* \\
           /opt/jdk/jre/lib/plugin.jar \\
           /opt/jdk/jre/lib/ext/jfxrt.jar \\
           /opt/jdk/jre/bin/javaws \\
           /opt/jdk/jre/lib/javaws.jar \\
           /opt/jdk/jre/lib/desktop \\
           /opt/jdk/jre/plugin \\
           /opt/jdk/jre/lib/deploy\* \\
           /opt/jdk/jre/lib/\*javafx\* \\
           /opt/jdk/jre/lib/\*jfx\* \\
           /opt/jdk/jre/lib/amd64/libdecora\_sse.so \\
           /opt/jdk/jre/lib/amd64/libprism\_\*.so \\
           /opt/jdk/jre/lib/amd64/libfxplugins.so \\
           /opt/jdk/jre/lib/amd64/libglass.so \\
           /opt/jdk/jre/lib/amd64/libgstreamer-lite.so \\
           /opt/jdk/jre/lib/amd64/libjavafx\*.so \\
           /opt/jdk/jre/lib/amd64/libjfx\*.so \\

### Tworzymy obraz

Jeśli nie mamy jeszcze zainstalowanego **Dockera** można go pobrać tutaj [https://www.docker.com/](https://www.docker.com/) i zainstalować według instrukcji. Następnie uruchamiamy **Dockera**, i wpisujemy kilka poleceń:

docker build -f Dockerfile -t code-couple-docker:latest .

gdzie:

*   `-f` wskazujemy nasz plik Dockerfile - domyślnie szukany jest w aktualnej lokalizacji
*   `-t` podajemy tag do naszego obrazu - domyślnie dodawane jest `latest`

Zbudowany obraz możemy uruchomić poleceniem:

docker run -p 8081:8081 code-couple-docker

gdzie:

*   `-p` oznacza mapowanie portów, mapujemy port **8081** (zdefiniowany w `application.properties` naszej aplikacji) z naszego kontenera na port **8081** na naszej maszynie

Teraz możemy korzystać z naszej aplikacji na porcie **8081**.

### Więcej

Oczywiście opisałem tutaj najbardziej rzemieślniczy sposób uruchamiania aplikacji na środowisku kontenerów, jednakże chciałem, aby był to artykuł dla osób początkujących z **Dockerem**. W następnych wpisach pokażę jak zautomatyzować ten proces. Pojawią się też wpisy o **Docker Cloud**. Cały projekt jak zawsze na [GitHubie](https://github.com/kchrusciel/Spring-Boot-Examples).