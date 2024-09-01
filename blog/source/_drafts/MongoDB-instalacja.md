---
title: MongoDB - instalacja
tags:
  - db
  - mongo
id: '810'
categories:
  - - DB
---

Warstwa persystencji to kolejny obszar, którym chciałbym się zająć odnośnie Spring Boot'a. Mamy kilka możliwości jeśli chodzi o wybór bazy. Dla środowiska developerskiego może okazać się, że baza typu In-Memory jak H2 lub HSQL będzie wystarczająca. My jednak chcemy użyć MongoDB.
<!-- more -->
Ze strony: https://www.mongodb.com/download-center

pobieramy interesującą nas wersję Mongo. W naszym przypadku Community Server -> Windows Server 2008 (ściągamy plik MSI).

Przechodzimy standardowy proces instalacji.

Po zainstalowaniu bazy, dodajemy "tutaj\_partycja:\\Program Files\\MongoDB\\Server\\3.2\\bin" do zmiennej środowiskowej. Dzięki temu nie będziemy musieli za każdym razem podawać całej ścieżki do plików. Pierwsze uruchomienie zaczynamy od uruchomienia polecenia:

`mongod --dbpath tutaj_partycja:\sciezka\do\twojej\bazy`

Uruchomiliśmy w ten sposób demona, czyli server MongoDB. We fladze --dbpath ustawiliśmy ścieżkę gdzie znajdować będą się pliki naszej bazy. Możemy także uruchomić demona bez tej flagi, wtedy nasza baza znajdować się będzie w domyślnej lokalizacji "\\data\\db".

Przydatna jest także flaga --smallfiles

Po pomyślnym uruchomieniu servera, możemy podłączyć się do bazy wydając polecenie `mongo` Powinno pojawić nam się pole do wpisywania komend. Aby sprawdzić poprawność działa, wydajmy polecenie `help.` Dzięki temu mamy listę dostępnych opcji. Po połączeniu z bazą możemy wydać polecenie show databases use test show collections db.nazwa\_kolekcji.find().pretty()