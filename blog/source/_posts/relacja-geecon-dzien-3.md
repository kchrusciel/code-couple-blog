---
title: Relacja - GeeCON dzień 3
tags:
  - geecon
  - konferencja
id: '1753'
categories:
  - - Konferencje
date: 2017-06-29 11:42:39
author: 'Krzysztof Chruściel'
---

#### ![](http://codecouple.pl/wp-content/uploads/2017/04/relacjaKonferencja.png)

Wpis trochę oddalony w czasie od poprzedniego dnia konferencji, ale udało się - ostatni dzień konferencji opisany. Serdecznie zapraszam do przeczytania relacji.
<!-- more -->
#### **Value types - The Next Big Thing for Java**

**Henning Schwentner** przedstawił nam koncepcję **value types** w Javie**.** Na wstępie rozróżnił obiekt od **value type**. Java jest językiem zorientowanym **obiektowo**. Więc zaczęliśmy od wyjaśnienia czym w ogóle jest obiekt? Ma on swój identyfikator, istnieje w czasie, może zmieniać swój stan, a na końcu zostaje usunięty przez **GC**. Z kolei value type nie ma identyfikatora, jest abstrakcją i jest niezmienny w czasie (**immutable**). Mając dwie zmienne, które mają tą samą wartość, metoda _equals_ zwróci nam true, ale są to dwa różne obiekty, ponieważ mają różne referencje, dlatego operator "==" zwróci nam false. Prelegent opowiedział jeszcze pare zdań na temat tego, gdzie rzeczywiście przechowywany jest obiekt, czym jest **heap**, **stack**, **compilation time** oraz **run time**. Z pomocą słuchaczy wymienionych zostało 8 podstawowych typów wartości w Javie. Do Javy 9 nie było dostępnych typów technicznych (unsignes, complex) oraz domenowych typów wartości jak np. kod pocztowy, IBAN, wartość pieniędzy. Gdy potrzebujemy takich typów możemy stworzyć własne  klasy **value-based**, które posiadają tylko i wyłącznie pola finalne, metodę equals, dzięki której obiekty porównywane są na podstawie wartości, a nie tożsamości. Obiekty tak tworzone mogą przypominać wartości, ale jednak dalej są obiektami i posiadają różne referencje. Java 10 przyniesie nam **value types**, dzięki czemu będziemy mogli zaoszczędzić trochę pamięci. Prelegent pokazał przyszłe rozwiązanie w kodzie.

Poniżej link do prezentacji z tegorocznej konferencji JFocus: https://www.youtube.com/watch?v=6kerOQaA9Jg **When Vert.x & RxJava meet - Knot.x: highly-efficient and scalable integration platform for modern websites**

**Maciej Laskowski, Tomasz Michalak** opowiadali o **Knot.x** po raz pierwszy. Jest to platforma, która została stworzona podczas **hackathonu** w ich firmie. Jest projektem open-source. Służy do integracji różnych komponentów, które tworzą strony na podstawie templatów. Szablonami mogą być strony HTML. Biblioteka ta korzysta z **Vertex'a** oraz **RxJavy**. Sama platforma podzielona jest na kilka warstw. Warstwa repozytorium to na przykład **Redis** lub **Apache**. Główną funkcjonalnością jest non-blocking loop. Dzięki temu możemy wykonywać asynchroniczne operacje. Jako event loop został wykorzystany **Reactor Pattern**. Na końcu panowie zaprezentowali demo wyszukiwarki książek. Przedstawili oni kilka przykładów związanych z **Knot.x** takich jak:

*   jedna instancja
*   dwie instancje komunikują się poprzez event bus
*   load balancing out of the box
*   jeden .jar
*   moduły i kontrakty

W **Knot.x'ie** panuje podejście imperatywne, czyli configuration first.

#### **JIT vs. AOT: Unity And Conflict of Dynamic and Static Compilers for Java**

Pierwszy slajd - Freddy (JIT) vs. Jason (AOT). **Nikita Lipsky** zaczął od tego, że kiedyś wszystkie kompilatory były statyczne, dopóki nie pojawiła się **Java**. Tak na prawdę dynamiczna kompilacja była znana wcześniej, ale dopiero z pojawieniem się Javy stało się to **mainstreamowe**. Mamy dwa sposoby wykonywania bytecodu:

*   interpretacja (wolna, ale przenośna)
*   kompilacja do kodu maszynowego (szybsza, ale odpalana na konkretnym urządzeniu)

Kolejną rzeczą jest sam moment kompilacji:

*   w czasie uruchamiania programu (dynamiczna kompilacja - JIT)
*   przed uruchomieniem (statyczna kompilacja - AOT)

Prelegent obalał mity dotyczące AOT oraz opowiadał o jej zaletach. Pokazał też wyniki testów wydajnościowych jednego i drugiego rozwiązania. Przedstawił też w jakich przypadkach lepszy jest JIT, a w jakich AOT.

Poniżej link do prezentacji z tegorocznej konferencji Riga Dev Days: https://www.youtube.com/watch?v=nzKqdxL8EXY

#### **Java9 and REPL. Forget debugging, welcome joy and productivity**

**Jakub Marchwicki** opowiedział nam o jednej z nowości w **Javie 9**. Na początku dowiedzieliśmy się czym jest **JShell**. Prelegent zaznaczył, że jest to narzędzie świetne dla osób zaczynających zabawę z Javą, bo w szybki sposób bez budowania i uruchamiania całych programów jesteśmy w stanie sprawdzić działanie wpisanych przez nas linii kodu. Jest to też dobry sposób na testowanie nowo poznanych bibliotek. Nie potrzebujemy do tego żadnego **IDE**, wystarczy linia poleceń. Slajdów było tylko kilka, Kuba skupił się na pokazaniu możliwości **REPL** w praktyce. Zaczęliśmy od prostych działań matematycznych, następnie stworzyliśmy interfejs i metody. Prelegent pokazał też użycie streamów i optionali z Javy 8. Następnie stworzyliśmy prostą aplikacje webową, a na koniec wykorzystaliśmy **Mavena** do zbudowania aplikacji. Fajne jest to, że możemy zapisać kod, który wykonujemy w **JShell**, a następnie uruchomić w dowolnym **IDE**. Prelegent na koniec zaznaczył, że warto korzystać z **REPL**, bo dzięki temu jesteśmy w stanie zupełnie inaczej spojrzeć na swój kod.

#### **TestContainers – integration testing without the hassle**

**Anton Arhipov** zaczął od stwierdzenia, że testy jednostkowe nie są wystarczające. Uruchamiane w izolacji mogą przechodzić poprawnie, ale **bez dobrych testów integracyjnych** nie mają sensu. Prelegent zaczął prezentację od pokazania kilku zdjęć, które pewnie każdy z nas widział (np. szafki, które się nie otwierają jednocześnie).

Typowy test **jRebel** składa się z następujacych operacji:

*   start server
*   deploy v1 version
*   verify behaviour
*   compile v2
*   verify behaviour
*   ...
*   stop server and clean

Wymagania potrzebne do testów:

*   odtwarzalne środowisko
*   izolacja
*   cross-platform
*   łatwość w ustawieniu, użyciu i utrzymaniu

Rozwiązaniem może być **Docker**. Dzięki jego wykorzystaniu możemy tworzyć nowy **kontener per test**. Całe środowisko tworzone jest od nowa, więc mamy pewność, że żadne "szumy" nie będą miały wpływu na wykonanie testu. Możemy także wykorzystać mechanizm **docker compose** i w imperatywny sposób określać jak tworzone będzie środowisko. Wykorzystanie **Dockera** ułatwia także testowanie w architekturze microserwisów, ponieważ nie musimy uruchamiać wielu aplikacji na jednym środowisku, tylko uruchamiamy je w osobnych, wyizolowanych kontenerach. Na kontenerach możemy uruchamiać także testy funkcjonalne, dzięki wykorzystaniu **Selenium**. Testy te odpalane są bez wykorzystania przeglądarki, więc nie potrzebujemy **UI**!

#### Zakończenie

Nadszedł czas na uroczyste zakończenie konferencji. Organizatorzy podziękowali wszystkim prelegentom i uczestnikom. Słuchacze z kolei mieli okazję podziękować organizatorom gromkimi brawami. Przedstawione zostały wyniki konkursu oraz zapowiedziana została już przyszłoroczna edycja, która będzie szczególna, bo już 10-ta. Zachęceni zostaliśmy do wzięcia udziału w tegorocznej edycji **GeeCONa** w Pradze, a na sam koniec przedstawiony został gość specjalny - **Rod Johnson**, który wygłosił ostatnią prelekcję.

#### **Simplification and Automation in Java: Yesterday, Today and Tomorrow**

Razem z twórcą **Springa Rodem Johnsonem** zaczęliśmy podróż od Javy Enterprise. Od jej początków dużo się nauczyliśmy. Wiemy, że automatyzacja jest ważna, ale wiemy też, że możemy zautomatyzować więcej. Zaczęliśmy od problemów **J2EE**:

*   za dużo kodu
*   proste rzeczy były trudne
*   za dużo źle zrealizowanych pomysłów

Z pomocą przyszła generacja kodu. Ale musimy zwrócić uwagę na to, że nie powinniśmy nigdy generować kodu, którego człowiek by nie napisał i takiego, który już został napisany przez człowieka. Dużym krokiem do przodu było stworzenie **Springa**:

*   dużo mniej kodu
*   czysty kod - mniej antywzorców

Ale nie było tak kolorowo:

*   dużo XML'i
*   duże aplikacje ORM'owe są ciężkie w utrzymaniu
*   nadal ciężko stworzyć nowy projekt

Kolejny krokiem było przejście na styl deklaratywny, czyli **convention over configuration**. Co doprowadziło do powstania **Spring Boot'a**. Ta ewolucja także miała swoje problemy i powstał projekt **Atomist**. Na koniec **Rod** pokazał nam możliwości **Atomista** w połączeniu ze **Slackiem** oraz narzędziami do **CI**.