---
title: Redis - data structures server
tags: []
id: '2684'
categories:
  - - Python
---

![](https://www.javatpoint.com/redis/images/redis-tutorial.png)

**NoSQL** jest akronimem słów "_Non SQL_" lub też "_Not only SQL_". Jest to ruch w którym odchodzi się od klasycznych **relacyjnych baz danych** do struktur lub modeli, które są bardziej dostosowane do typu danych wykorzystywanych przez nas. Istnieje kilka modeli baz **NoSQL** między innymi, **grafy**, **dokumenty** czy pary **klucz-wartość**. **Redis** jest bazą, która przechowuje dane jako ostatni z wymienionych sposób czyli jako pary **klucz-wartość**.
<!-- more -->
### Czym jest Redis?

**Redis** jest jedną z dostępnych baz, która przechowuje informacji w postaci pary **klucz-wartość** (_ang. key-value storage_). Nie jest to "zwykła" baza, jest to  "_data structures_ _server_" który pozwala przechowywać wartości jako różne struktury a nie tylko jako prosty **String**_._ Ponadto jest to **open source'owy** projekt, który może być wykorzystywany jako **baza danych**, **cache** lub **message broker**. **Redis** przechowuje dane w pamięci **RAM** i posiada kilka wbudowanych **typów/struktur danych** (opisy w dalszej części):

*   **String**
*   **List**
*   **Set**
*   **Sorted Set**
*   **Hash**
*   **BitMaps**
*   **HyperLogLogs**

### Instalacja

**Redis'a** możemy zainstalować na kilka sposobów. Wykorzystując zwykłą instalację [https://redis.io/download](https://redis.io/download). Lub korzystając z **Docker'a** ściągając  już gotowy obrazu znajdującego się [https://hub.docker.com/\_/redis/](https://hub.docker.com/_/redis/).

Po instalacji, instancja serwera znajduje się na domyślnym porcie 6379.

### Redis - CLI

Po instalacji najprościej jest zacząć pracować z **Redisem**, korzystając z **CLI**. Jeśli nie chcemy instalować **Redisa**, możemy skorzystać z [https://try.redis.io/](https://try.redis.io/) i pobawić się trochę konsolą.

### Klucze

Klucze są wartościami, które są "binary save". Oznacza to że kluczem może być dowolna binarna sekwencja. Może to być zwykły String "my:key" ale może to być także zawartość jakiegoś pliku. Istnieje kilka tipów odnośnie kluczy:

*   **klucze nie powinny być zbyt długie** - długość klucza ma wpływ na **performance** różnych operacji, powinniśmy stosować krótkie nazwy kluczy
*   **klucze nie powinny być zbyt krótkie** - krótkie klucze mają pozytywny wpływ na **performance** ale należy też pamiętać o ich czytelności
*   **rozmiar** - maksymalny rozmiar klucza to **512 MB**
*   **używaj konwencji** - powinniśmy korzystać z konwencji "object-type:id" przykładowo "user:21"

### String

String jest podstawowym typem danych w **Redisie**. Wszystko klucze przechowywane są jako **String**. Typ ten może być wykorzystywany także jako wartość. Polecenia `SET` oraz `GET` służą do ustawienia jak i pobierania wartości:

SET some:key "value"
GET some:key
"value"

Wartość podobnie jak klucze mają ograniczenie w postaci rozmiaru, który nie może przekroczyć **512** **MB**.

### List

Jest bardziej złożoną strukturą danych, która zaimplementowana jest jako **Linked List** wraz z przechowywaniem informacji o pierwszym i ostatnim elemencie. Dzięki temu dodawanie i usuwanie elementów z początku/końca listy jest bardzo szybkie `O(1)`, natomiast pobieranie elementów zajmuje `O(n)` (więcej można przeczytać [we wpisie o strukturach](http://codecouple.pl/2017/12/15/2-java-performance-tablica-vs-lista/)). Dodawanie nowych elementów do listy odbywa się przez polecenia `LPUSH` (dodaje do lewej strony listy czyli na początek _head_) oraz `RPUSH` (dodaje do prawej strony listy czyli na koniec _tail_). Odczyt elementów z listy realizuje polecenie `LRANGE`, które przyjmuje dwa parametry, indeks początku i końca (`-1` oznacza koniec):

RPUSH list "third"
RPUSH list "second"
LPUSH list "first"
LRANGE list 0 -1
1) "first"
2) "third"
3) "second"

### Set

Podobnie jak w matematyce, zbiór nie może przechowywać duplikatów oraz jest on nie posortowany. Dodawanie elementu do zbioru odbywa się przez polecenie SADD. Natomiast odczyt do SMEMBERS:

SADD some-set 1 21 10
SMEMBERS some-set
1) "1"
2) "10"
3) "21"

### SortedSet

Jeśli natomiast potrzebujemy **zbiór**, który jest posortowany, możemy wykorzystać strukturę zwaną SortedSet.

### Hash

Służy do przechowywania obiektów pod kluczem.

### Czas ważności

Bardzo ważnym aspektem w kontekście przechowywania wartości w **cache** lub przechowywania **sesji** użytkownika w bazie jest jej **czas ważności**. Do ustawienia czasu ważności służy polecenie `EXPIRE`, które przyjmuje wartość w sekundach:

SET some.key "some.value" #ustawiamy wartość some.value pod klucze some.key
EXPIRE some.key 10        #ustawiamy czas ważności na 10 sekund
TTL some.key              #sprawdzamy przez ile sekund nasza wartość jest aktywna
(integer) 9               #jest ważna jeszcze przez 9 sekund
GET some.key              #pobieramy po upływie 10 sekund
(nil)                     #nasza wartość nie istnieje

### Więcej

Oczywiście jest to tylko wstęp do **Redis'a**. Sam **CLI** posiada wiele więcej ciekawych komend. Jeśli zainteresował was temat polecam kilka linków:

*   [https://try.redis.io/](https://try.redis.io/) - interaktywna konsola
*   [https://redis.io/](https://redis.io/) - strona projektu
*   [https://redis.io/documentation](https://redis.io/documentation) - bardzo dobrze napisana dokumentacja
*   [https://redis.io/topics/data-types-intro](https://redis.io/topics/data-types-intro) - wprowadzenie do typów danych

A już niedługo wykorzystamy **Redis'a** w połączeniu ze **Spring Boot'em** do przechowywania sesji.