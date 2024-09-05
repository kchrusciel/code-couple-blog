---
title: Relacja – Confitura 2018
tags:
  - confitura
  - konferencja
id: '3046'
categories:
  - - Konferencje
date: 2018-07-06 12:01:34
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/04/relacjaKonferencja.png)

Jak zwykle końcówkę czerwca spędziliśmy w stolicy biorąc udział w **Confiturze**. Jest to największa darmowa konferencja Javova w Polsce, na której występują najbardziej znane osoby ze środowiska **JVM**. W tym roku odbyła się ona w nowy miejscu jakim jest budynek **Expo XXI**. Zapraszamy na relację!
<!-- more -->
### “Co by się stało gdyby Spring zniknął na tydzień…?”

No właśnie, co by się stało gdyby Spring zniknął na tydzień? Gdy pojawiło się to pytanie, sami zaczęliśmy się nad tym zastanawiać. **Maciej Próchniak** w dość humorystyczny sposób starał się nas przekonać do tego, że istnieje świat po za Springiem. Powinniśmy zawsze się zastanowić, czy aby na pewno potrzebujemy Springa. Jeśli dobrze zaplanujemy budowanie aplikacji, może okazać się, iż jest on mocno nadmiarowy. Oczywiście należy pamiętać o tym, że Spring jest technologią dojrzałą. Posiada bardzo dobrze rozbudowaną i czytelną dokumentację oraz mnóstwo innych pomocnych materiałów. Często ta cecha może zaważyć nad wyborem Spring vs reszta świata. Maciek zaproponował w jaki sposób możemy zastąpić niektóre komponenty Springowe takie jak kontener IoC, metryki czy dostęp do warstwy persystencji. Hmmmm....no tak, ale w Springu mam to załatwione przy pomocy jednej adnotacji! Okazuje się, że bez Springa nie zajmuje to dużo więcej linii, a pozbywamy się nadmiarowości nieużytych komponentów. Istnieją takie rozwiązania jak OSGI, Ratpack czy JDBI. Wybierajmy mądrze!

### Odzyskaj kontrolę nad aplikacją

**Bartek Zdanowski**, który jest jednym z organizatorów Confitury wprowadzał nas w temat logowania w naszych aplikacjach. Zaczęliśmy od podstaw, jak wygląda struktura loggera i jakie dostępne są poziomy logowania. Prelegent podał przykłady sytuacji, w których należy stosować każdy z nich. Najważniejsze, żeby w obrębie teamu stosować te samy poziomy do tych samych zdarzeń. Logowanie w środowisku rozproszonym może stanowić problem. Rozwiązaniem może okazać się [Mapped Diagnostic Context](http://codecouple.pl/2017/07/21/17-spring-boot-distributed-tracing-zipkin-i-sleuth/), w którym nadajemy ten sam Correlation-Id wszystkim wiadomościom przesyłanym w jednym ciągu zdarzeń. Dobrą praktyką jest tworzenie w tych samych miejscach loggerów na różnym poziomie. Dzięki temu bez ponownego deploymentu jesteśmy w stanie wybrać tylko interesujące nas poziomy logowania. Na koniec nie mogło zabraknąć gorącego ostatnio tematu jakim jest **RODO**. Pamiętajmy, aby nie logować danych wrażliwych. Wypisanie id użytkownika z bazy jest wystarczające do jednoznacznej jego identyfikacji, a w przypadku skorzystania z klauzuli zapomnienia wystarczy, że usuniemy tylko jeden rekord z bazy, a wszystkie logi, które się do niego odwoływały nie dostarczą nam już żadnych informacji. Uff..nie pójdziemy za kratki.

### Jak być zarąbistym developerem w oczach szefa i ... klienta

Jeśli idziesz na wykład **Wojtka Seligi**, to możesz mieć pewność, że będzie to bardzo dobra prezentacja (po raz kolejny to potwierdził). W dzisiejszych czasach firmy mogą konkurować między sobą jedynie jakością. Aby osiągnąć dobrą jakość trzeba posiadać bardzo dobry i zmotywowany zespół. Jeśli posiadamy ekipę pasjonatów, dla których rozwój i jakość jest najważniejsza, to możemy osiągnąć sukces. No dobra, ale jak znaleźć takich ludzi? O tym była właśnie prezentacja Wojtka. Mówił on o tak zwanych Smart Creatives, czyli o osobach, które są ponadprzeciętne w tym co robią oraz angażują i inspirują innych do pracy.  Mają one bardzo pozytywny wpływ na rozwój firmy i w znaczący sposób przyczyniają się do osiągnięcia sukcesu. Na koniec prelegent przedstawił pytania jakie zadaje ludziom na rozmowach kwalifikacyjnych, aby sprawdzić, czy są Smart Creatives. Wojtek sam przyznał, że nie zna odpowiedzi na wszystkie z nich, jednakże zadając je sam ciągle się uczy. Przykładowe pytania to "_czego się dziś nauczyłeś?_", "_co nowego możesz wnieść do firmy?_" lub "_masz 5 min, czego możesz mnie dzisiaj nauczyć?_". Naszym zdaniem jest to kolejna prezentacja, która potwierdza, że ciężka praca oraz kreatywność jest najważniejsza. Budujące jest to, że według [HackerRank](https://www.hackerrank.com/) w Polsce praca z silną, mądrą ekipą jest ważniejsza niż wynagrodzenie. To do roboty, szukajcie silnego teamu!

### (Too) Smart UI? Jak projektować API REST-owe

Model dojrzałości **Richardson'a** został przedstawiony na konkretnych przykładach przez **Szymona Janikowskiego**. Prelegent mówił o tym, aby projektować API REST'owe na podstawie tego jaki mamy model aplikacji. Przykładowo, jeśli jest to aplikacja typu CRUD, wtedy drugi poziom z modelu dojrzałości będzie wystarczający. Jest tak, ponieważ aplikacja CRUD'owa nie zawiera żadnej logiki biznesowej, więc odpowiednie czasowniki i URI wystarczą. Przeciwstawnym biegunem jest API, które jest modelowane na podstawie procesu biznesowego. Wtedy do projektowania powinniśmy podchodzić jak do tworzenia kodu z wykorzystaniem DDD. W jak najlepszy sposób należy enkapsulować wiedzę domenową wchodząc na trzeci poziom modelu dojrzałości oraz sterować stanem poprzez odpowiednie linki (**HATEOAS**). Bardzo ciekawa prezentacja, która skłania nas do myślenia o API jako o bardziej złożonym procesie niż tylko byciu "RESTFul".

### Requirements & BDD: The lost art of analysis and acceptance scenarios

**Jakub Nabdralik** zaczął od wprowadzenia do tematu zbierania wymagań. Uświadomił on nam, iż user stories według definicji to tylko wstęp do dalszej dyskusji na temat featurów, natomiast my bardzo często traktujemy je jako kompletne wymagania do implementacji. Niestety, zazwyczaj informacje zebrane w user stories są zbyt ubogie i pojawiają się pytania. Więc jak radzi sobie z tym team Jakuba? Mają oni przygotowany odpowiedni szablon do nowych funkcjonalności, który zawiera najważniejsze pytania na ich temat. Następnie developer w ramach zadania odpowiada na te pytania (lub zbiera informacje od klienta), a w kolejnym kroku tworzy pull requesta z tymi odpowiedziami, aby inni developerzy mieli pogląd, co będzie implementowane w ich aplikacji. Taka informacja pozwala lepiej oszacować zadanie, a podczas PR mogą wystąpić dodatkowe pytania/wątpliwości. Pod koniec prezentacji prelegent pokazał nam jak korzystając z BDD przenosić wymagania biznesowe do kodu. Specyfikacja jako tekst nie sprawdza się, ponieważ z założenia miało być to rozwiązanie dla biznesu, ale czy ktoś z Was widział ludzi w garniturach piszących kod jako specyfikację? To jak spotkać jednorożca. Dlatego jako developerzy powinniśmy korzystać z BDD do tworzenia wykonywalnej specyfikacji.

### Full-Text Search Internals

**Philipp Krenn** jest przedstawicielem firmy **Elastic**, która znana jest z takich produktów jak **ElasticSearch**, **Logstash**, czy **Kibana**. Prezentacja dotyczyła produktu ElsaticSearch. Na początku zaprezentował on jak wygląda cały proces przetwarzania zdań. Jest on dość złożony i składa się z kilku etapów:

*   **html\_strip** - pozbycie się znaczników (<znacznik>wartość</znacznik> - > to jest wartość)
*   **tokenizer** - rozbicie zdania na tokeny
*   **lowercase** - zmniejszenie słów do małych liter
*   **stop words** - usunięcie wszystkich _stop words_ jak the, a czy an (mogą być różne dla różnych języków, [język Polski](https://github.com/apache/lucene-solr/blob/master/lucene/analysis/stempel/src/resources/org/apache/lucene/analysis/pl/stopwords.txt))
*   **snowball** - usunięcie liczby mnogiej ze słów

Następnie bardziej dokładnie został przedstawiony proces analizy zdań. Przykładowo może to być analiza fonetyczna, która na podstawie fonetycznego zapisu odnajduje rekordy. Na sam koniec Philipp przestawił nam algorytmy scoringu oraz jak sami możemy zaimplementować własny algorytm.

### Programistów z biznesem przypadki trudne

Na sam koniec był "kabaret" i to dosłownie. Trójka przedstawicieli firmy **Bottega**, czyli **Kuba Kubryński**, **Michał Michaluk** oraz **Sławomir Sobótka** wprowadziła nas w świat **DDD** za pomocą programu telewizyjnego "_Interwencja IT_". Kuba był redaktorem, który przedstawiał problem pomiędzy biznesem (reprezentowanym przez Sławka) oraz developmentem (reprezentowanym przez Michała). Program podzielony był na trzy bloki "_problem - rozwiązanie_":

*   niewidczone zmiany (długie releasy) - małe, inkrementalne zmiany
*   niezrozumienie wymagań - event storming
*   brak "liczb" do dyskusji - metryki

Naszym zdaniem taka forma prezentacji na zakończenie była świetnym pomysłem, ponieważ humor bardzo dobrze wpływa na przyswajanie wiedzy!