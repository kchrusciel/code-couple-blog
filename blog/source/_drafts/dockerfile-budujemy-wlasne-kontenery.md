---
title: Dockerfile  - budujemy własne kontenery
tags:
  - docker
id: '491'
categories:
  - - Docker
---

**Dockerfile** służy do zautomatyzowania tworzenie obrazów. W artykule wprowadzającym do **Dockera** przedstawiony był sposób tworzenia obrazu z terminala **Dockera**. Bo utworzeniu obrazu należało go uruchomić a następnie wykonać jakieś polecenie. Jak widać musimy wykonać kilka kroku. Aby zautomatyzować ten proces wykorzystamy **Dockerfile**.
<!-- more -->
Zacznij od utworzenia folderu, możemy to wykonać z terminala Dockerowego:

mkdir codeCouple

cd codeCouple

Jako przykład utworzę plik który tworzy kontenerem z obrazem javy, a następnie umieszczę tam jar'a, uruchomię go i przekieruje porty na mojego hosta.

FROM java
MAINTAINER CodeCouple.pl
ENV CODE\_COUPLE CodeCouple.pl
LABEL version="1.0"

W folderze tworzymy plik o nazwie **Dockerfile**. Plik ten jest bez rozszerzenia. Składnia pliku:

\# Komentarz
INSTRUKCJA argumenty

Instrukcje nie są case-sensitive więc nie trzeba pisać ich drukowanymi literami jednak podobnie jak w SQL dobrą praktyką jest pisanie instrukcji drukowanymi literami. Poprawia to czytelność. Plik rozpoczynamy od polecenia FROM, który określa obraz z którego chcemy budować:

FROM nazwa\_obrazu

Lub:

FROM nazwa\_obrazu:tag

Następnie dodamy autora:

MAINTAINER nazwa

Zmienne środowiskowe ENV:

ENV klucz wartość

Metadane o naszym obrazie definiujemy poleceniem LABEL:

LABEL klucz=wartość

Aby sprawdzić aktualnie przypisane informacje o obrazie:

docker inspect nazwa\_obrazu

Pokazał nam się dość pokaźny wynik, aby pobrać interesujące nas dane używamy flagi [\--format](https://docs.docker.com/engine/reference/commandline/inspect/)

```
docker inspect --format='{{.Config.Label}}' nazwa_obrazu
```

Zwróci to nam etykiety przypisane do obrazu. Po utworzeniu pliku, w terminalu dockera wchodzi do folderu w którym mamy pliki jar oraz plik Dockerfile i wydajemy polecenie budujące:

docker build -t nasz\_tag .

docker build -t java:test .