---
title: Relacja - GeeCON dzień 1
tags:
  - geecon
  - konferencja
id: '1749'
categories:
  - - Konferencje
date: 2017-05-28 22:08:08
author: 'Krzysztof Chruściel'
---

[![](http://codecouple.pl/wp-content/uploads/2017/04/relacjaKonferencja.png)](http://codecouple.pl/wp-content/uploads/2017/04/relacjaKonferencja.png)W tym roku miałam przyjemność uczestniczyć w **GeeCONie** - konferencji skupiającej miłośników **Javy** i **JVM**. Odbyła się ona w Multikinie w **Krakowie** i trwała 3 dni (**17-19.05**). Zapraszam na relację z pierwszego dnia!
<!-- more -->
Zacznę od spraw technicznych: bardzo fajna lokalizacja, z dala od ścisłego centrum, dlatego z parkingiem nie było żadnego problemu. Udało się zająć miejsce pod samym Multikinem, ale obok było też kilka innych sporych parkingów. Kolejnym zaskoczeniem była wyjątkowo szybka i sprawna rejestracja, która trwała zaledwie **2-3** **minuty**. Kolejek prawie nie było pomimo tego, że ludzie cały czas przychodzili. Rozdawanie koszulek i kufli niezależnie od rejestracji na pewno miało wpływ na czas rejestracji. Konferencja odbywała się jednocześnie w **4 różnych salach**. Pierwszy raz miałam okazję uczestniczyć w wykładach prowadzonych w salach kinowych, ale trzeba przyznać, że jest to dobry pomysł - obraz i dźwięk świetny w każdym miejscu, dalsze rzędy były nawet lepsze niż pierwsze.

Konferencja rozpoczęła się od...śniadania :) przy tak intensywnym przyswajaniu wiedzy nie możemy przecież zapomnieć o przyjmowaniu pokarmu.

O godz. 10:00 było oficjalne otwarcie konferencji (z transmisją w drugiej sali). Organizatorzy przywitali wszystkich gości oraz prelegentów. Potem przedstawili tegorocznych sponsorów oraz partnerów. **O'Reilly** dał możliwość uczestnikom na pobranie bezpłatnie jednego **e-booka** z listy wybranej przez organizatorów. Ja mam już w swoich zasobach _**Java Performance: The Definitive Guide.**_ Na konferencje przygotowane zostały dwie aplikacje. W jednej z nich mogliśmy znaleźć grafik wszystkich prelekcji wraz z krótkimi opisami. W drugiej znajdowała się gra konkursowa, w której mogliśmy zbierać punkty za m.in. rozwiązywanie quizów czy skanowanie QR kodów ukrytych na terenie kina. Nagrody w postaci **elektroniki** zostały rozdane w ostatnim dniu konferencji.

A teraz przejdźmy do tego co najważniejsze - prelekcje, w których uczestniczyłam:  

#### **Platform and Product Evolution at Sabre**

Była to prelekcja otwierająca GeeCONa. **David Moore** z Sabre opowiadał o tworzeniu, projektowaniu i rozwoju produktów przez organizacje. Zaznaczył, że stopień złożoności oprogramowania rośnie, a nie maleje wraz z rozwojem produktu. Kolejne zmiany często narażają system na porażkę. Utrzymywanie bezpieczeństwa również staje się coraz trudniejsze. W organizacjach najważniejsza jest świadomość takich elementów i umiejętność radzenia sobie ze zmianami. **David** na podstawie wieloletnich doświadczeń opisywał jak organizacyjne mogą radzić sobie podczas modernizacji systemów i kodu. Świetnym podsumowaniem prelekcji było stwierdzenie, że to nie technologie są trudne tylko ludzie, a produkty odzwierciedlają organizację. W firmach, w których jest słaba komunikacja nigdy nie powstanie dobry produkt. Bardzo dobry wybór prelegenta i tematu na otwarcie!

 

#### **Caching for Business Applications: Best Practices and Gotchas**

**Michael Plöd** podał nam 13 dobrych praktyk dotyczących **cachingu** w aplikacjach biznesowych. Zaczął od szybkiego wytłumaczenia czym w ogóle jest **cache**. Potem zaznaczył, że aplikacje biznesowe, o których będzie mówił to nie to samo co portale społecznościowe typu **Twitter** czy **Facebook**, które przetrzymują w cache wszystko. Dzięki stosowaniu odpowiednich metod **cachingu**, jesteśmy w stanie stworzyć aplikacje bardziej skalowalne, szybsze i tańsze w utrzymaniu. Michael skupił się na lokalnych i rozproszonych **cachach** na poziomie aplikacji. Poniżej przedstawione metody:

1.  **Identify suitable layers for caching** - wybór odpowiedniej warstwy
2.  **Stay local as long as possible**
    *   in-memory
    *   clustered - dla danych niewrażliwych
    *   clustered - with sync (wymiana informacji pomiędzy **cachami** - stosowanie inwalidacji i replikacji)
3.  **Avoid real replication where possible** - lepszym rozwiązaniem wydaje się być inwalidacja
4.  **Avoid big heaps just for caching** - może to prowadzić do destabilizacji klastra
5.  **Use a distributed cache for big amounts of data** - prowadzi to do lepszej skalowalności aplikacji i łatwiejszego zarządzania **cachem**.
6.  **The operations specialist is your new best friend**
7.  **Make sure that only suitable data gets cached** - najbardziej odpowiednimi danymi do przetrzymywania w cachu są dane często odczytywane, drogie w dostępie
8.  **Only use existing cache implementation** - NEVER EVER WRITE YOUR OWN CACHE IMPLEMENTATION!!! Jest mnóstwo dostępnych rozwiązań na rynku, które sprostają Twoim potrzebom
9.  **Introduce Caching in three steps**:
    *   Optymalizacja aplikacji
    *   Local cache
    *   Distributed cache
10.  **Optimize Serialization**
11.  **Use Off-Heap Storage for Cache instances with more than 4 GB Heap Size** - Nie ma Garbage Collection
12.  **Mind the security gap** - nie należy zapomnieć o bezpieczeństwie przy odczycie, szczególnie wrażliwych danych
13.  **Abstract your cache provider**

Michael zaznaczył na koniec, że żadna z wyżej wymienionych rad nie jest **silver bullet** która rozwiąże wszystkie problem, to tylko dobre rady i pomysły, nad którymi warto pomyśleć stosując **cache** w swoich aplikacjach.

Poniżej cała prezentacja:

https://speakerdeck.com/mploed/geecon-2017-caching-for-business-applications-best-practices-and-gotchas  

#### **DDD beyond the infamous repository pattern**

**Cyrille Martraire**, bardzo pozytywny człowiek z francuskim akcentem opowiadał o **DDD**. W trakcie wykładu nie zabrakło chwil relaksu ze śmiesznymi kotami (**Kitten Time**). Zaczął od wprowadzenia czym jest **DDD**. Wszystko opiera się na domenie, a język musi być powszechny. Nazwy klas, metod powinny być dobierane tak, aby każdy wiedział do czego służą nie zaglądając w implementację. Powinniśmy unikać technicznych "zanieczyszczeń". Prelegent przypomniał też o praktykach dobrego programowania obiektowego (**Object Calisthenics**). **DDD** powinniśmy stosować, jeżeli najważniejszą wartością jest **domena**. Ważne jest abyśmy każdą metodę dodali do właściwej klasy, a każdą klasę do właściwego pakietu. Przeciwieństwem tego jest klasa MainController, do którego pakowane jest wszystko niezależnie od właściwości i zastosowania. **Refaktoryzacja** powinna opierać się na zrozumieniu domeny. Kod powinien być tak pisany, że inni czytając go są w stanie zrozumieć i nauczyć się domeny. Prelekcja była prowadzona w formie **problem - rozwiązanie**. Na koniec **Cyrille** zaznaczył, że język programowania i frameworki nie mają znaczenia przy stosowaniu **DDD** - najpierw Domain Design, a dopiero potem technologie. Warto zacząć od przeczytania biblii, czyli "Domain-Driven Design: Tackling Complexity in the Heart of Software" Erica Evansa.

 

#### **Building a PWA with Ionic, Angular and Spring Boot (Matt Raible)**

**Matt Raible** prowadził prezentację w formie **live-codingu**. Zaczął od przedstawienia **Spring Boota**, w którym pisał backend oraz **Ionica** odpowiedzialnego za frontend. **Angulara** użył między innymi do walidacji. Prelegent podpowiedział, że jeżeli stworzymy aplikacje na urządzenia mobilne to lepszym podejściem jest **Mobile First Web Design** niż **Responsive Web Design**. Mówił też o **PRPL Pattern** (Push, Render, Pre-cache, Lazy-load) oraz o **PWA** (Progressive Web Apps). Aplikacje takie jesteśmy w stanie ściągnąć w bardzo krótkim czasie i zajmują mało miejsca. Live coding **Matt** zaczął od **Spring Initializera**, w którym stworzył projekt "Beer App". Potem połączył się z UI napisanym w **Ionicu**. W **PWA** fajne jest to, że aplikacja działa nawet po wyłączeniu sieci. Matt swoje rozwiązanie testował najpier przez plugin w **IntelliJ**, a następnie w emulatorze **IoS**. Kody źródłowe prelegenta znaleźć możecie [TUTAJ](https://github.com/oktadeveloper/spring-boot-ionic-example), a tutorial krok po kroku [TUTAJ](https://okta.github.io/blog/2017/05/17/develop-a-mobile-app-with-ionic-and-spring-boot).

 

#### **We don’t need Java EE, use Kubernetes!**

**Anatole Tresch** zaczął od tego, że historia jest bardzo ważna żeby zrozumieć teraźniejszość. Pokazał jak długi kod trzeba było kiedyś napisać żeby wysłać "Hello world" pomiędzy dwoma komputerami w języku C. Przełomem było pojawienie się **Javy** \- prawdziwej multiplatformy dostępnej za darmo dla każdego. Potem przyszła **Java EE**, w której pojawiły się nowe wzorce architektoniczne oraz elementy specyficzne dla aplikacji typu enterprise m.in. zdefiniowane formaty deploymentu (jar, war, ear) czy statyczna skalowalność. Pokazał również schemat stosu **Javy EE.** Później przeszedł do kontenerów. Opowiadał o **Dockerze**, w którym rozwiązana została kwestia wirtualizacji. Wymienił zalety, czyli m.in. lekkość **kontenerów** czy fakt, że możemy odpalać nasze aplikacje w całkowitej izolacji. Ale jak uruchomić kontenery na produkcji? Z pomocą przychodzą **Kubernetesy**. Zapewniają nam one odporność na awarie, skalowalność, modularność, load-balancing, routing, częściowe updaty czy service discovery. **Anatole** wymieniał również narzędzia wspomagające pracę z **Kubernetesami**. Jednym z nich jest **fabric8** - platforma do integracji z **kontenerami**. Można ją uruchamiać w połączeniu z **Mavenem**. Na zakończenie prelegent zaznaczył, że warto samemu się zacząć korzystać z **kontenerów**.

 

#### **Distributed Systems Theory for Mere Mortals**

**Ensar Basri Kahveci** z Ankary zaczął od definicji systemów rozproszonych, które są zbiorem encji próbujących rozwiązać powszechne problemy. Wymienił kilka głównych trudności w takich rozwiązaniach. Trudności te to między innymi niezależne awarie, opóźnienia w transmisji wiadomości czy komunikacja. Opowiadał o tym, że czas wykorzystywany jest do szeregowania **eventów**. Przedstawił protokoły **2PC**, **3PC** oraz teorię **CAP**, która mówi, że w rozproszonych bazach danych w dowolnej chwili mogą być zapewnione tylko dwie z trzech własności:  konsystencja, dostępność, odporność na podział. Prelegent zaznaczył, że w systemach rozproszonych nie ma żadnej magii i obecnie są one powszechnie stosowane, dlatego warto znać ich podstawy.

 

#### **Java Performance Engineers' Survival guide**

**Monica Beckwith** podała dwa podstawowe pytania, które powinniśmy sobie zadać tworząc aplikacje.

*   Kiedy użytkownik jest szczęśliwy?
*   Kiedy użytkownik nie jest szczęśliwy?

Żeby zacząć **Performance Engineering** powinniśmy zrozumieć **QoS** (Quality of Service) użytkowników końcowych oraz zdefiniować metryki, które będą mierzalne aby osiągnąć zadowolenie klientów. **Metryki**, które warto mierzyć to:

*   **throughput**
*   **response time**
*   **footprint**
*   **capacity management**

Pomiarów powinniśmy dokonywać na różnych warstwach:

*   **Application**:
    *   application services
    *   application Server
    *   DB
    *   other services in ecosystems
*   **JVM**:
    *   classloading stats
    *   JIT compilation stats
    *   GC stats
    *   threads stats
    *   locking stats
*   **Hardware**:
    *   memory bandwidth/traffic/consumptions
    *   CPU/core utilization
    *   CPU cache efficienty
    *   IO stats

Monica przedstawiła również dwie metody poprawy **performancu**:

*   top-down approach
*   bottom-up approach

Każda z nich składa się z 4 etapów:

*   monitor
*   profile
*   analyze
*   tune and apply

Do każdego z nich prelegentka podawała kilka darmowych narzędzi do pomiarów. Pierwszy dzień jak najbardziej spełnił moje oczekiwania. Wszystkie prelekcje były prowadzone na wysokim poziomie. Już za kilka dni pojawią się wpisy z drugiego i trzeciego dnia konferencji.