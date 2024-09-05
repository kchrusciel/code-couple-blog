---
title: Relacja - GeeCON dzień 2
tags:
  - geecon
  - konferencja
id: '1751'
categories:
  - - Konferencje
date: 2017-06-02 20:09:09
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/04/relacjaKonferencja.png) Pora na relację z kolejnego dnia konferencji. Zaczęliśmy z samego rana o 9:00.
<!-- more -->
 

#### **Event Sourcing and CQRS with Spring Stream**

**Jakub Pilimon** zaczął wykład od **CQRS** (Command Query Responsibility Segregation). Myślą przewodnią jest oddzielenie operacji odpowiedzialnych za odczyt danych od tych, które ich stan zmieniają. Eventy (czyli zapis każdej operacji) zawsze powinny być zapisywane oraz posiadać sygnaturą czasową. Kuba przytoczył sytuację, w której zostawiamy aplikację na weekend, przychodzimy w poniedziałek do pracy i okazuje się, że mamy błędy. Należałoby przywrócić bazę do stanu sprzed błędu. Ale czy konieczne jest przywracanie całej bazy, wszystkich operacji? Może wystarczy odnaleźć tylko ciąg zdarzeń, które spowodowały błąd i je ponowić. Dzięki **Event Sourcing** mamy tą możliwość. Prelegent pokazał kod dwóch aplikacji napisanych wykorzystując **SpringBoot'a**. Jedna generowała zdarzenia. Druga to **UI**, który miał zadanie subskrybenta odbierającego te zdarzenia. Dzięki ustawieniu własności `spring.cloud.stream.bindings.input.group` jesteśmy w stanie pobrać wygenerowane dane. Możemy wybrać tylko aktualnie przychodzące, lub całą historię wcześniejszych zdarzeń. Testy takiego rozwiązania są dużo prostsze, bo nie dzielimy bazy. Prelegent mówił również o dzieleniu zdarzeń na paczki jeśli są ich bardzo duże ilości. Wspominał o lepszym performance, bo w **Event Sourcingu** uniezależniamy się od stanu. Na koniec wymienił problemy, z jakimi trzeba się zmierzyć stosując takie rozwiązanie:

*   **event versoring** - częsta zmiana struktury eventu
*   przy błędach nie poprawiamy danych tylko eventy

 

#### **5 ways to improve your Java EE applications in reactive way**

**Ondrej Mihályi** przedstawił na początku samo założenie **programowania reaktywnego**. W tym celu zapytał co najczęściej robimy jak strona się dłużej ładuje - czekamy. Czasem to czekanie może prowadzić do....i tutaj zdjęcie kościotrupa. Nie jest to najlepsza wizja. Naszym celem powinno być jak najszybsze wyświetlenie użytkownikowi treści, o którą nas pyta lub informacji o niepowodzeniu. Prelegent przedstawił nam graf [Reactive Manifesto](http://www.reactivemanifesto.org/):

\[caption id="" align="aligncenter" width="599"\][![](http://www.reactivemanifesto.org/images/reactive-traits.svg)](http://www.reactivemanifesto.org/images/reactive-traits.svg) http://www.reactivemanifesto.org/\[/caption\]

Po krótkim wprowadzeniu teoretycznym przyszedł czas na praktykę. Prelegent pokazywał nam jak możemy zrefaktoryzować nasz kod napisany w **Javie EE** do postaci reaktywnej przy użyciu **CompletableFuture** w Javie 8. Aplikacja, którą nam pokazywał to [CARGOTRACKER](https://javaee.github.io/cargotracker/). Kod był już przygotowany, a prowadzący jedynie pokazywał różnice w kodach. Najważniejsze punkty, które omówił to:

*   **Asynchronous API**
*   **Chaining callbacks**
*   **Messages (JMS, WebSocket, CDI events)**
*   **Separate thread pools**
*   **Context propagation**

Programowanie reaktywne nie jest proste, ale warto spróbować!  

#### **Reactive Spring**

Dwie prelekcje o programowaniu reaktywnym pod rząd. Tym razem pora na **Josha** **Longa**. Przyznam, że czekałam na tą prelekcję i zdecydowanie warto było. Zaczęło się od żartów, które pojawiały się też później. Prelekcja była typu **live coding**. Zaczął od stworzenia projektu poprzez **Spring Initializera** (jego drugie ulubione miejsce po produkcji). **Josh** przedstawił nam dwa główne typy w [Reactorze](https://projectreactor.io/), na którym pracował podczas wykładu:

*   **Mono (0 lub 1 element)**
*   **Flux (0 lub N-elementów)**

W aplikacji zapisywaliśmy i odczytywaliśmy za pomocą metod z typów mono i flux filmy po danym atrybucie, lub wszystkie. Wykorzystywaną bazą było **MongoDB**. Stworzony został klient, który subskrybował tylko jeden z dostępnych tytułów filmów. Ten prosty przykład pokazał jakie możliwości daje nam reaktywny **Spring** i jak proste może być napisanie takiego kodu. **Josh** omówił też kwestię bezpieczeństwa przy tworzeniu reaktywnych aplikacji. Warto samemu spróbować.

Poniżej prelekcja, co prawda nie z **GeeCON** tylko z **DEVOXX**, ale zachęcam do obejrzenia dla tych który jeszcze nie widzieli: https://www.youtube.com/watch?v=EDB24onZxsA  

#### **Stages of maturity on the way to microservices**

Kolejna prelekcja prowadzona była przez **Jakuba Marchwickiego** oraz **Jarosława Pałkę**. Już na samym wstępie zaznaczyli, że cała prezentacja to tylko i wyłącznie ich wersja pojęcia **mikroserwisów**. Dlaczego ludzie zaczynają wchodzić w mikroserwisy? Rodzi to nadzieję, liczymy, że znajdziemy coś lepszego i dzięki temu będziemy mogli mniej pracować. Prelegenci całą prezentację stworzyli w oparciu o swoje doświadczenie i błędy, z którymi się zetknęli. W **monolitycznych aplikacjach** jak pojawia się jakiś błąd to najczęściej siada całość, a przecież nie każda funkcjonalność jest sobie równa. Przy mikroserwisach błąd jednego serwisu niekoniecznie blokuje pozostałe.

Mikroserwisy nie zawsze są dobrym rozwiązaniem i powinniśmy się zastanowić czy wprowadzamy je z racjonalnych powodów a nie tylko i wyłącznie z czyjejś zachcianki. Decyzja powinna być przemyślana, ale z pewnością warto próbować i rozważać nowe pomysły.

Podział na oddzielne serwisy, w których każdy odpowiedzialny jest tylko za jedną rzecz przysparza zdecydowanie mniej bólu i ułatwia pracę. Prelegenci mówili, że warto automatyzować wszystko co możliwe, żeby nie musieć wstawać w nocy i nie robić **rollbacku na produkcji.** Nie możemy też zamykać się tylko na swój kawałek kodu nad, którym pracujemy. Często słyszane "u mnie działa" jest bardzo nieprofesjonalne i musimy patrzeć dalej. **Nie ignorujmy infrastruktury**.

Wprowadzanie zmian zawsze zajmuje czas i musimy się ciągle uczyć, uczyć, uczyć! Ale jeśli w przyszłości przyniesie nam to korzyści to może jest to warte tego wysiłku. Ważne jest też dobre zrozumienie systemu nad którym pracujemy, zaczynając od systemu operacyjnego, kontenerów, JVM, frameworków, a kończąc na samej aplikacji. Nie bójmy się zadawać pytań, jeśli czegoś nie wiemy.

Prelegenci mówili też o przykładach **źle zarządzanej organizacji**, w której jak powstaje błąd w aplikacji to cała firma musi pracować nad poprawką. Zaznaczają, że błędy są czymś całkowicie naturalnym i zdarzają się codziennie, nie powinniśmy się tego wstydzić i zrzucać winy na innych. Stawiajmy analizę i wyciąganie wniosków nad uczucia i domysły.

Bardzo ważna jest kontrola i obserwacja logów i metryk, zaglądamy do nich często, dlatego piszmy je z sensem. Na koniec prowadzący powiedzieli, że **mikroserwisy** mogą ułatwić życie, a to jest zdecydowanie warte wprowadzenia ich w firmie. 

 

#### **Consumer-Driven Contracts to enable API evolution**

**Marcin Grzejszczak** zaczął od wprowadzenia teoretycznego i wyjaśnienia czym są:

*   **Producer** - serwis, który wystawia API/wysyła wiadomości
*   **Consumer** - serwis, który pobiera API/odczytuje wiadomości
*   **Contract** - umowa pomiędzy producentem i konsumerem jak API/wiadomości będą wyglądać
*   **Consumer Driven Contract** - podejście, w którym konsumer steruje zmianami API producenta

Za każdym razem kiedy słyszycie o jakiejś nowej technologii, zmianach zastanawiacie się jakie problemy to rozwiąże. Jeśli chodzi o **CDC** to można wymienić dwa takie problemy:

*   słuszność używania i reużywalność mocków w testach integracyjnych
*   łatwe i przyjemne tworzenie API

Po wprowadzeniu przyszedł czas na **live coding**. Prelegent pokazał jak stworzyć wszytskie 3 fazy:

*   **Consumer** - off-line work
*   **Producer** - features implementation
*   **Consumer** - switch to on-line work

Stworzony został **consumer** oraz **producent** przy wykorzystaniu **TDD**. Wszystkie oczekiwania zostały przedstawione poprzez czytelne kontrakty napisane w **Groovym**. Zobaczyliśmy jak mocki **producenta** mogą być wykorzystywane przez **consumera**. Uruchamianie i ustawianie mocków było w pełni zautomatyzowane. Podczas prezentacji użyty został plugin **Spring Cloud Contract**. Daje on funkcjonalność **StubRunnera**, jest prosty w obsłudze, i dostępne jest automatyczne generowanie testów z kontraktów. Same kontrakty pisane były w **Groovym**. Marcin wspomniał również, że dobrym narzędziem jest **Spring Rest Docs** do pisania dokumentacji.

Poniżej prezentacja:

https://www.youtube.com/watch?v=sAAklvxmPmk  

#### **Inside JVM JIT**

**Charles Oliver Nutter** opowiadał o JIT. Musimy przecież wiedzieć co dokładnie robi JVM "pod spodem", żeby podejmować dobre decyzje. Zaczął od słownictwa, które przyda nam się podczas prezentacji (bytecode, native code, heap, JIT, aot itp.). Potem przedstawił graf JVM 101. Opowiadał o inliningu metod instancyjnych, statycznych oraz specyfikowanych. Przedstawił narzędzia do analizy: javac, javap, -xxPrintCompilation, -xxPrintInlining, -xxPrintAssembly. Przeszliśmy przez analizę 3 poziomów:

*   bytecode
*   compilation logs
*   native code

Na każdym etapie mieliśmy możliwość zobaczenia instrukcji w asemblerze. Charles na koniec zaznaczył, że JVM to niesamowita platforma oraz, że każda operacja ma swój koszt. Znając ten koszt jesteśmy w stanie pisać bardziej optymalne metody i klasy, a tym samym być lepszymi programistami.

 

#### **Microservices - the naked truth of the maintainability**

**Jakub Kubryński** stwierdził, że prawdziwego developera poznać można po tym jak utrzymuje kod a nie jak go zaczyna tworzyć. Ile linii kodu powinien mieć jeden mikroserwis? Wcale nie tak mało jak nam się wydaje. Licząc linie kodu naszych monolitycznych aplikacji i dzieląc to na małe mikroserwisy (przykładowo 1000 linii) okazałoby się, że potrzebujemy ich kilkadziesiąt tysięcy. **Mikroserwisy** powinny być **business oriented**, od technologii mamy biblioteki. Przy monolitycznych aplikacjach deployment/restart trwa długo. Stosując mikroserwisy skraca nam się ten czas, szczególnie, że w większości przypadków nie potrzebujemy deployować/restartować całej aplikacji tylko dany jej fragment. Prelegent przedstawił jeszcze inne wady i zalety mikroserwisów. Na koniec podzielił się z nami swoją wizją, która mówi, że za parę lat zaczniemy łączyć [mikroserwisy do jednej aplikacji monolitycznej](https://twitter.com/cyriux/status/865223719626657792).

 

Został ostatni dzień konferencji. Już niebawem kolejny wpis.