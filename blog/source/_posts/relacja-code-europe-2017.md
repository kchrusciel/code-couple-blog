---
title: Relacja – Code Europe 2017
tags:
  - codeeurope
  - code_europe
  - konferencja
id: '1696'
categories:
  - - Konferencje
date: 2017-05-05 15:30:41
author: 'Krzysztof Chruściel'
---

[](http://codecouple.pl/wp-content/uploads/2016/12/CodeEurope2016Relacja.png)[![relacjaKonferencja](http://codecouple.pl/wp-content/uploads/2017/04/relacjaKonferencja.png)](http://codecouple.pl/wp-content/uploads/2017/04/relacjaKonferencja.png)26 kwietnia odbyła się w Krakowie (**ICE**) konferencja **Code Europe** nazwana największą konferencją programistyczną w Polsce. Oprócz Krakowa odbywać będzie się ona również we Wrocławiu 23 maja w **Hali Stulecia** oraz w Warszawie 25 maja na **PGE Narodowym**. Zapraszamy na relację z krakowskiej edycji, ze ścieżki wybranej przez **CodeCouple**.
<!-- more -->
Rejestracja zaczęła się od godziny 8.30 pomimo tego, iż uczestnicy nauczeni doświadczeniem stali już w kolejce od godziny ósmej. Rok temu był problem z rejestracją uczestników przez co wiele osób spóźniło się lub w ogóle nie dotarło na pierwszą prelekcję. Niestety, w tym roku historia się powtórzyła. Nam udało się dotrzeć na pierwszy wykład 5 min przed czasem.

### 1\. Reactive Socket - the future of microservices communication

Prelekcja prowadzona była przez **Macieja Ciołka** (**CTO CodeHeros, Cloud Architect**). Na wstępie prelegent wspomniał o tym, że prezentacja powinna nosić nazwę "**RSocket**", a nie "**Reactive**", ponieważ kilka dni wcześniej biblioteka ta zmieniła nazwę, aby nie powtarzać cały czas słowa "**Reactive**". Rozwiązanie to jest warstwą abstrakcji i może być wykorzystywane z różnymi protokołami komunikacji:

*   **TCP/IP**,
*   **WebSocket**,
*   **Aeron**.

Przedstawione zostały sposoby komunikacji wykorzystywane przy **RSocket**:

*   **fire and forget** - wysłamy tylko requesta, odpowiedź nas nie interesuje (zapominamy o niej "forget"),
*   **request-response** - klasyczny przykład komunikacji,
*   **request-multiple responses (stream)** - w odpowiedzi otrzymujemy strumień danych.

W łatwy sposób możemy także decydować o ilości requestów i responsów, które chcemy przetworzyć. Do tego celu wykorzystujemy **Async pull,** gdzie w paramterze **_n_** podajemy ilość wiadomości. W połączeniu **Server-Server** przy wykorzystaniu parametru _**leasing**_ możemy ustawić wartość maksymalną przetwarzanych wiadomości. Na koniec przedstawione zostało krótkie demo, które pokazało jak w łatwy sposób zaimplementować asynchroniczne przetwarzanie wiadomości z wykorzystaniem biblioteki **RSocket**. Prezentacja była dobra jako forma zachęty do poszerzenia informacji na ten temat.

### 2\. Node.js behind: V8 engine & its optimizations

Kolejna prezentacja dotyczyła **slinika V8**, który wykorzystywany jest przede wszystkim w **Chromie**. Przedstawiona ona była przez **Dawid Rusnaka**, który pracuje w **G2A**. Na początku nakreślił on slajd z osią czasu, na której przedstawiona była historia **silnika V8**. Opisał także kompilatory, które były wykorzystywane przez **V8**:

*   **Crankshaft**,
*   **TruboFAN**,
*   **Ignition**.

Kolejno przedstawił jak obiekty przechowywane są w pamięci oraz jak czyszczone są poprzez wykorzystanie **GC**. Podobnie jak w **JVM** zachodziła **hipoteza generacyjna**, która mówi o tym, iż młode obiekty umierają częściej. Obszar pamięci podzielony został na młodą - _young_ i starą - _old_ generację. Jeśli chodzi o markowanie obiektów na heapie, wykorzystywane są trzy kolory:

*   **white** - na biało zaznaczamy obiekty, które nie zostały jeszcze sprawdzone,
*   **gray** - na szaro zaznaczamy obiekty sprawdzone, ale takie, które nie mają sprawdzonych wszystkich sąsiadów,
*   **black** - na czarno oznaczamy obiekty, które są sprawdzone wraz ze wszystkimi swoimi sąsiadami.

Na końcu prelegent przedstawił narzędzia do profilowania i wykrywania **memory leak'ów**. Prelekcja nam się podobała i zauważyliśmy duże podobieństwo mechanizmu **GC** do tego, który realizowany jest to w **JVM**.

### 3\. Advanced search for your legacy application

Zaczęło się od selfika z publicznością, a potem było już tylko lepiej. **David Pilato** (z **Elastic**), z francuskim akcentem zaprezentował nam jak wykorzystać silnik wyszukiwania pełnotekstowego **Elasticsearch** w aplikacjach legacy. Był to pokaz typu **live-coding.** David zaczął od prezentacji całego stosu Elastic oraz bardzo dobrze wyglądającego **dashboardu**. Zobaczyliśmy jak operować na agregatach danych oraz jak w prosty sposób dołączyć do istniejącej aplikacji funkcjonalność **autocomplete.** [Beyonder](https://github.com/dadoonet/elasticsearch-beyonder) jest ciekawym rozwiązaniem stworzonym przez prelegenta, który pozwala customizować indeksy oraz rodzaje mapping'ów. Prelegent pokazał, że duża porcja danych może być przetwarzana przy wykorzystaniu **Bulk Processor**, dzięki temu można wysyłać paczki z dużą ilością danych zamiast przetwarzać One By One (jeden po drugim). Na koniec David zaprezentował nam dashboardy z Kibany, które korzystały z agregatów. Przykładowo na mapie zaznaczone były najbardziej zaludnione obszary. Wraz z przybliżaniem obrazu na mapie dane dostosowywały się do lokalizacji. Prezentacja zaliczona jak najbardziej do udanych.

### 4\. The Rise of Serverless Architectures

**Benny Bauer** jest Izrealiczykiem, który pokazywał nam nowe podejście do architektury, a mianowice **Serverless**. Jest to kolejny poziom **granulacji** po mikroserwisach. Do realizacji logiki biznesowej wykorzystujemy małe funkcje (**FaaS** - Function as a Service), które przechowywane są najczęściej w cloudzie (na przykład projekt **AWS Lambda**). Przedstawiał on przypadki użycia, w który ta architektura znajduje zastosowanie:

*   Web backend,
*   Mobile backend,
*   File processing - pierwszy projekt zrealizowany w tej architekturze, tworzył on miniaturki z obrazków,
*   Bat,
*   Stream processing,
*   Scheduled tasks.

Ograniczenia związane z tym podejściem to:

*   mało pamięci - 1,5 GB,
*   mało miejsca - 500 MB,
*   czas wykonania - maksymalnie 5 minut,
*   duże opóźnienia - "zimna" usługa może uruchamiać się nawet do dwóch sekund,
*   brak stanu,
*   ceny.

Bardzo dużym minusem był także wysoki próg wejścia dla nowych programistów w zespole. **Granulacja** związana z tą architekturą powodowała powstanie wielu małych funkcji, przez co dla nowej osoby w teamie odnalezienie się w tym rozproszonym systemie jest bardzo ciężkie. Benny i jego prezentacja spełniły nasze oczekiwania.

### 5\. Object Calisthenics - 9 steps to better OO code

**Paweł Lewtak** opowiadał o dobrych praktykach **programowania obiektowego** na przykładzie języka **Python.** Przedstawił on 9 kroków, które należy wykonać, aby osiągnąć lepszy kod: 

1.  Only one ident per method - powinno się unikać zagnieżdżonych operacji warunkowych
2.  Don't use else - starać się unikać operacji _else_
3.  Value object - unikać metod z wieloma parametrami, a w zamian opakowywać je w klasy
4.  Only one dot per line - stosować prawo Demeter (rozmawiać tylko ze najbliższymi znajomymi)
5.  Do not abbreviate - dekomponować klasy oraz metody
6.  Keep your class small - dążyć do pisania jak najmniejszych klas
7.  More than two states - klasa nie powinna przechowywać więcej niż dwa stany, jeśli tak jest to należy ją wyekstraktować
8.  Collections - stosować kolekcje zawarte w API
9.  Don't use getters/setters - nie używać mutatorów do operacji innych niż ustawianie i pobieranie wartości, jeśli potrzebna jest jakaś logika do ustawienia wartości, to należy stworzyć odpowiednią do tego metodę

Dodatkowym 10 punktem był profit jaki uzyskamy stosując wszystkie powyższe reguły. Prezentacja poprawna, ale nie zaskoczyła nas w żaden sposób. Fajnie zebrane praktyki w jedną prezentacje.

### 6\. Is private IaaS solution hard to deploy and manage? Come and see yourself how easy it can be!

Kolejna prezentacja prowadzona przez **Pawła Krupę** dotyczyła prywatnych rozwiązań typu **IaaS** (Infrastructure as a Service). Na początku przedstawiony był problem przechowywania wrażliwych danych oraz zwiększających się kosztów korzystania z płatnych rozwiązań zewnętrznych usług. Najlepszym rozwiązaniem jest posiadanie wewnętrznej infrastruktury, jednak dostępne rozwiązania posiadają małą skalowalność. Najlepszym połączeniem jest własna infrastruktura do przechowywania danych, natomiast usługi, które potrzebują większych zasobów obliczeniowych powinny znajdować się w usługach zewnętrznych. Jednym z pierwszych open source'owych rozwiązań realizujących **IaaS** był projekt **OpenStack**. Posiadał on wadę związaną z losowym powodzeniem deploymentu (istniało 50% szans powodzenia). Projekt ten później ewaluował do różnych połączeń, np. OpenStack + Docker + Ansible, aby ostatecznie powstał projekt **Kolla.** Prezentacja jako jedyna była prowadzona w języku polskim. W przystępny sposób Paweł przedstawił nam narzędzia do tworzenia własnego **IaaS**.

### 7\. A Test-Driven Approaches to Documenting RESTful APIs with Groovy and Spring REST Docs

Ostatnim już wykładem na Code Europe było wystąpienie **Jennifer Strater**, amerykanki pracującej na duńskim uniwersytecie. Na początku przedstawiony został **Swagger** \- narzędzie do dokumentacji naszych aplikacji. Ma on pewne wady, które mają znaczący wpływ na czytelność kodu:

*   annotation hell,
*   niezaszyfrowany Security Token,
*   utrudnione modelowanie danych.

Jako plus wymieniony był _"Try it"_ button, który wykorzystywany był przez QA do testów integracyjnych.

**TDD** tym razem to **Test Driven Documentation**, czyli tworzenie dokumentacji sterowanej testami. Jest to nowe podejście stosowane przez **Spring Rest Docs**, w którym tworzymy dokumentację poprzez pisanie testów. Jest do bardzo dobre rozwiązanie, ponieważ wymusza ono na nas pisanie testów, a dodatkowo mamy przetestowaną dokumentację. Unikamy błędów związanych z brakiem aktualizacji dokumentacji po zmianach w kodzie. Jennifer pokazała nam wynik końcowy dokumentacji wygenerowanej przez Spring Rest Docs. Dokumentacja podzielona była na bardzo czytelne i intuicyjne sekcje z linkami, do poszczególnych działów. W Swagerze wygląda to zupełnie inaczej. Dokumentacja  na stronie składa się z listy opisanych endpointów. Prezentacja bardzo ciekawie poprowadzona i bardzo podoba nam się takie podejście to pisania testów.