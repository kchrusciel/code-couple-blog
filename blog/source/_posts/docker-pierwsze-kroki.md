---
title: Docker - pierwsze kroki
tags:
  - deployment
  - docker
  - java
  - linux
  - lxc
  - microservices
id: '450'
categories:
  - - Docker
  - - Java
date: 2016-03-14 09:48:12
author: 'Krzysztof Chruściel'
---

![](https://www.docker.com/sites/default/files/Whale%20Logo332_5.png)

**Docker** \- kolejna sexy technologia pożądana przez wiele osób. Wykorzystywany jest do **deploymentu** oraz **developingu** aplikacji. **Docker** jest kontenerem bazującym na jądrze **Linuxa** (kontenery linuksowe - [lxc](https://linuxcontainers.org/)). Jest on bardzo lekki i przyspiesza proces wytwarzania oprogramowania.
<!-- more -->
Aby zacząć swoją przygodę z **Docker'em,** należy pobrać pliki z oficjalnej strony (artykuł dotyczy wersji na **Windows**):

*   [https://docs.docker.com/windows](https://docs.docker.com/windows/)/

Po pomyślnej instalacji możemy uruchomić terminal **Dockerowy** (fajny wieloryb :P): [![dockerTerminal](http://codecouple.pl/wp-content/uploads/2016/03/dockerTerminal.png)](http://codecouple.pl/wp-content/uploads/2016/03/dockerTerminal.png)

Polecenia poprzedzamy słowem "**docker**".

docker polecenie argument

**Obraz** (ang. _image_) jest to czysta kopia systemu **Linux** z najważniejszymi elementami, aby uruchomić dane środowisko. **Marek Goldmann** określił obraz jako klasę, natomiast kontener jest instancją klasy (obrazu). **Obrazy** przechowywane są w [Docker Hub](https://hub.docker.com/), znajdują się tam oficjalne repozytoria z obrazami (coś na wzór Github'a). Na górze strony znajduje się wyszukiwarka. Wyszukujemy interesujący nas obraz. Dla przykładu wpiszmy "**java**". Po wpisaniu ukaże nam się strona z dostępnymi tagami. **Tag** określa nazwę wersji.

[![dockerJavaImages](http://codecouple.pl/wp-content/uploads/2016/03/dockerJavaImages.png)](http://codecouple.pl/wp-content/uploads/2016/03/dockerJavaImages.png) Aby pobrać **obraz** należy wydać polecenie:

docker pull nazwa\_obrazu

W naszym przypadku chcemy uruchomić polecenie **java -version** (do tego wystarczy nam **java 8).** Wydajemy polecenie **docker pull java:latest**, wtedy zostanie pobrany obraz z **docker hub**.

Pobranie obrazu:

docker pull nazwa\_obrazu

docker pull nazwa\_obrazu:tag

Polecenia poniżej są równoważne:

docker pull java:latest

docker pull java

Dla naszego przykładu pobieramy ostatni obraz **javy**:

docker pull java:latest

Po pobraniu **obrazu** powinien on być widoczny na liście obrazów. Lista naszych obrazów:

docker images

[![dockerImages](http://codecouple.pl/wp-content/uploads/2016/03/dockerImages.png)](http://codecouple.pl/wp-content/uploads/2016/03/dockerImages.png)

Widzimy, że nasz obraz jest dostępny z tagiem "**latest**". Pora na uruchomienie obrazu.

Aby uruchomić **obraz** należy wydać polecenie:

docker run -flagi nazwa\_obrazu proces\_który\_chcemy\_uruchomić

Najczęściej stosowane **flagi** to:

*   **\-it** - tryb interaktywny (możemy np: korzystać z bash'a)
*   **\-d** - tryb deamon, działa na zasadzie usługi
*   **\--rm** - usuwa kontener po wyłączeniu (tylko kontener, nie obraz!)

Uruchamiamy nasz **kontener** w trybie **interaktywnym**:

docker run -it --rm java:latest bash

Uruchomiliśmy lekki kontener **Linuxowy** z wszystkim minimalnymi składkami, żeby uruchomić **jave**. Aby sprawdzić czy na pewno mamy zainstalowaną **jave** wystarczy podać polecenie:

java -version

[![dockerJavaContainer](http://codecouple.pl/wp-content/uploads/2016/03/dockerJavaContainer.png)](http://codecouple.pl/wp-content/uploads/2016/03/dockerJavaContainer.png) Jak widzicie na naszym kontenerze jest najnowsza **Java**.

Aby wyjść z kontenera wydajemy polecenie **exit**.

Uruchamiamy **kontener** po raz kolejny:

[![dockerJavaContainerVersion](http://codecouple.pl/wp-content/uploads/2016/03/dockerJavaContainerVersion.png)](http://codecouple.pl/wp-content/uploads/2016/03/dockerJavaContainerVersion.png)

ID **kontenera** jest inne, dzięki czemu mamy pewność, że pracujemy na świeżym **kontenerze**.

Aby usunąć obraz wydajemy polecenie:

docker rmi tag\_lub\_id\_obrazu

Ostatnim poleceniem, które zwraca listę aktualnie działających kontenerów jest:

docker ps

W następnym artykule napiszę jak tworzyć własny obraz **Dockerfile,** który przyspieszy **deployment**.