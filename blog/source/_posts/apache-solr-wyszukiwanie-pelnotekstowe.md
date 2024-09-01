---
title: Apache Solr - wyszukiwanie pełnotekstowe
tags:
  - apache solr
  - solr
id: '1049'
categories:
  - - Apache Solr
date: 2016-12-09 08:00:52
---

![SolrLogo](http://codecouple.pl/wp-content/uploads/2016/11/Solr_Logo_on_white-300x152.png)

**Apache Solr** to serwer wyszukiwania pełnotekstowego (ang. _full-text search_) napisany w **Javie.** Oparty jest on na **Apache Lucene** i może bardzo szybko usprawnić wyszukiwarkę w naszej aplikacji. Możemy uzyskiwać wyniki w formatach takich jak **JSON**, **Python**, **XML** czy **PHP**. Bardzo popularne rozwiązanie, posiada funkcje facetów, jest skalowalne i potrafi wiele więcej.
<!-- more -->
## 1\. Pobranie aplikacji

Proces instalacji przedstawiony jest na platformie **Windows**. Naszą przygodę z **Apache Solr** zacznijmy od pobrania aplikacji. Link poniżej:

[http://lucene.apache.org/solr/mirrors-solr-latest-redir.html](http://lucene.apache.org/solr/mirrors-solr-latest-redir.html)

## 2\. Uruchomienie aplikacji

**Apache Solr** napisany jest w **Javie,** także uruchamiany jest na **JVM**. Po pobraniu i rozpakowaniu źródeł możemy uruchomić aplikację. Pliki do uruchomienia znajdują się w folderze _/bin_. Aby uruchomić **Solr** najlepiej odpalić sobie **CMD** w folderze _/bin_ i wydać jedno z poleceń poniżej.

Domyślny sposób uruchomienia aplikacji:

solr start

Uruchomienie aplikacji na konkretnym porcie. Port **8983** jest portem domyślnym dla **Solr'a**:

solr start -p numer\_portu

Domyślnie aplikacja uruchamia się w tle, jeśli chcemy mieć podgląd do logów używamy flagi `-f` (ang. _foreground_):

solr start -f

Przekazanie parametrów do **JVM** aplikacji:

solr start -a "paramtery"

Uruchomienie aplikacji z przykładowymi danymi (ang. _examples_):

solr start -e nazwa\_przykładu

Uruchomienie aplikacji w trybie cloud z przykładowymi nodami:

solr start -e cloud

Uruchomienie aplikacji z przykładowymi danymi ukazującymi różne możliwości **Solr'a**:

solr start -e techproducts

Data import handler:

solr start -e dih

Przykład schema-less:

solr start -e schemaless

Uruchomienie aplikacji w trybie cloud:

solr start -c lub -cloud

Podgląd wszystkich opcji:

solr start -help

Dobra, starczy tych opcji uruchomienia i wypadałoby w końcu uruchomić aplikację!

Na potrzeby pisania artykułu wykorzystuję bazę z przykładami **techproducts**:

solr start -e techproducts

Polecenie to uruchomi plik **solr.cmd**. Od teraz możemy korzystać z serwera **Apache Solr**.

## 3\. Pokaz możliwości

Aby sprawdzić czy aplikacja na pewno się uruchomiła wystarczy w przeglądarce wpisać [http://localhost:8983/solr/](http://localhost:8983/solr/).

Pierwsze kroki skierujmy w stronę sprawdzenia możliwości **Solr'a**. Wystarczy wpisać adres [http://localhost:8983/solr/techproducts/browse](http://localhost:8983/solr/techproducts/browse) i otrzymujemy **out-of-the-box** przeglądarkę produktów opartą na **Velocity,** na której prezentowane są różne funkcje **Solr'a**. Między innymi **facets**, **highlithing**, **searching**, czy **autocomplete**. Co więcej, każda z opcji podpisana jest nagłówkiem.

**Highlithing** - pozwala podkreślić w określony przez nas sposób (może to być na przykład znacznik <b>) szukanej frazy.

**Facets** - można wykorzystać do sortowania na przykład po kategorii.

**Autocomplete** - podpowiadanie szukanej frazy, jak w **google,** gdy wpiszemy pierwsze litery słowa.

[![solrbrowser](http://codecouple.pl/wp-content/uploads/2016/12/solrBrowser-1024x624.png)](http://codecouple.pl/wp-content/uploads/2016/12/solrBrowser.png)

## 4\. Panel administracyjny

Aby uruchomić panel administracyjny aplikacji wystarczy w przeglądarce wpisać [http://localhost:8983/solr/](http://localhost:8983/solr/). [![SolrAdminPanel](http://codecouple.pl/wp-content/uploads/2016/12/solrAdminPanel-1024x424.png)](http://codecouple.pl/wp-content/uploads/2016/12/solrAdminPanel.png)

Teraz wybierzmy stworzony przez nas przykładowy Core o nazwie **techproducts**.

[![solrcorechoose](http://codecouple.pl/wp-content/uploads/2016/12/solrCoreChoose.png)](http://codecouple.pl/wp-content/uploads/2016/12/solrCoreChoose.png)

## 5\. Budowanie zapytań w panelu administracyjny

Po wybraniu odpowiedniego Core'a wybieramy opcję **query,** gdzie możemy zacząć zabawę z danymi (dane posiadamy dzięki temu, że uruchomiliśmy **Solr'a** z przykładowymi danymi - flaga `-e`).

[![solrcorequerychoose](http://codecouple.pl/wp-content/uploads/2016/12/solrCoreQueryChoose.png)](http://codecouple.pl/wp-content/uploads/2016/12/solrCoreQueryChoose.png)

Pojawiło  nam się dość mocno rozbudowane okno do tworzenia zapytań. Jest ono bardzo fajnym ułatwieniem, ponieważ nie musimy ręcznie tworzyć zapytań tylko wypisujemy odpowiednie pola i dzięki temu mamy od razu stworzony URL z zapytaniem. Utworzony URL komunikuje się z naszym serwerem i dzięki temu w naszym panelu administracyjnym mamy od razu wynik.

Po lewej stronie mamy wynik naszego zapytania. Po kliknięciu w górną belkę z całym naszym zapytaniem aplikacja przeniesie nas do przeglądarki, gdzie będziemy mieli wynik w formacie określonym poprzez pole `wt`. Wynik składa się minimum z dwóch części. Pierwsza z nich `responseHeader` zawiera informacje na temat zapytania, natomiast w drugiej części `response` zawarte są wyniki.

[![solrqueryresult](http://codecouple.pl/wp-content/uploads/2016/12/solrQueryResult.png)](http://codecouple.pl/wp-content/uploads/2016/12/solrQueryResult.png)

Po lewej stronie natomiast mamy wiele input boxów:

`Request-Handler (qt)` - adres, na który chcemy wysyłać nasze zapytania. Domyślnie jest to `/select`. Więcej adresów znajdziemy w pliku `solrconfig.xml` w sekcjach `<requestHandler name=....`

/select

`q` - czyli nasze okno to wpisywania zapytań (ang. _query_). Aby pobrać wszystkie wartości (podobne do select \* from table w **SQL**) używamy: `*:*`.

Pierwsza wartość to nazwa pola, a druga to szukana wartość:

\*:\*

Szuknie elementów, które w polu name zawierają frazę "500" i przed i za tą frazą są dowolne znaki oraz wartość pola manu to "maxtor":

name:\*500\*, manu:maxtor

`fq` - filtrowanie w naszym zapytaniu (ang. _filter query_).

Pobranie wszystkich elementów, w których popularność posiada wartość od 0 do 7. Można użyć znaku "\*" (\[5 to \*\]):

popularity:\[0 TO 7\]

`sort`\- służy do sortowania naszych wyników. Możemy sortować rosnąco lub malejąco.

Możemy sortować poprzez podanie kilku wartości, które rozdzielone są przecinkami:

name desc, price asc

`fl` - lista pól, nie musimy podawać tego w query - możemy tutaj określić listę pól

Zwrócenie pola weight oraz name ze wszystkich elementów:

weight, name

`wt` - określamy typ zwracanych danych (ang. _writer type_), dostępne opcje:

*   JSON,
*   XML,
*   Python,
*   PHP,
*   CSV,
*   Ruby.

## 6\. Zamknięcie aplikacji

Aby zastopować serwer używamy polecenia `stop`.

Zatrzymanie instancji na konkretnym porcie:

solr stop -p numer\_portu

Jeśli chcemy zastopować wszystkie instancje:

solr stop -all

## 7. Więcej informacji

Jeśli chcielibyście poszerzyć swoją wiedzę zachęcam do poczytania:

*   [http://lucene.apache.org/solr/resources.html](http://lucene.apache.org/solr/resources.html)
*   [https://wiki.apache.org/solr/](https://wiki.apache.org/solr/)

Oraz do obejrzenia: Warsaw JUG \[embed\]https://www.youtube.com/watch?v=-X3TzwfWDDA\[/embed\] Toruń JUG \[embed\]https://www.youtube.com/watch?v=\_9AnMQNxQuE\[/embed\] W kolejnym wpisie pokażę jak stworzyć własną kolekcję i zabierzemy się za integrację ze **Springiem**!