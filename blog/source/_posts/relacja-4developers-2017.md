---
title: Relacja - 4Developers 2017
tags:
  - 4developers
  - 4DevŁódź
  - konferencja
id: '2329'
categories:
  - - Konferencje
date: 2017-11-17 12:01:56
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/10/4dev_Lodz_750x100-1.gif) **4Developers,** edycja **Łódzka** już za nami. Pora na relację, w której znajdziecie opisy prelekcji oraz konferencji jako całości. Odbyła się ona 9 listopada w **BioNanoparku**. Organizatorzy przywitali nas bardzo dobrze przygotowanym procesem rejestracji, w którym otrzymaliśmy starter packi. Szybka kawka i ruszamy z pierwszą prelekcją!
<!-- more -->
### O annotacjach – czas powstrzymać demony

Zakapturzony czarodziej, czyli **Jarosław Ratajski** był pierwszym prowadzącym tego dnia. Starał się on przekazać, iż stosowanie **frameworków** takich jak **Spring** nie koniecznie jest dobrym rozwiązaniem wszędzie. Sama technika wstrzykiwania zależności jest bardzo dobra, jednakże możliwość łatwego stosowania bez zrozumienia jej prowadzi do tego, że nasz kod przestaję być Javą, a staje się zagubionym i brzydkim **XML'em**. Powinniśmy dostosować technologię do potrzeb, a nie wybierać frameworki według upodobań. Jedną z proponowanych lekkich bibliotek był **Ratpack**. Bardzo fajna prezentacja!

### W poszukiwaniu zaginionej wydajności, czyli słów kilka o tym, jak podkręcić aplikacje działające na MongoDB

Niestety, nie obyło się bez problemów technicznych na początku prezentacji. Temat prelekcji bardzo ciekawy tym bardziej, że Agnieszka ma styczność z dużą ilością danych w bazie **MongoDB** na produkcji. Prowadzącym był jeden z liderów Łódzkiego **JUG'a**, **Wiktor Sztajerowski**. Przedstawiał on poszczególne fazy wykonywania zapytania oraz jak indeksy mają na nie wpływ. Kolejność ta poprawiała czas wykonania zapytania. Na koniec prezentacji przedstawione było jak radzić sobie z indeksami w replikach.

### Micro-monolith Anti-Pattern Tomasz Fijałkowski

_Allegro on the stage_, czyli **Tomasz Fijałkowski**. Przedstawił on wady i zalety zarówno architektury opartej o mikroserwisy, jak i architektury monolitycznej. Większość zalet **mikroserwisów** może być z powodzeniem zastosowane w monolicie. Największą zaletą **mikroserwisów** jest zwinność, która występuje jako skalowalność developmentu. Mikro-monolity mogą występować na frontendzie, gdzie zależy nam na spójności **UI**. Na koniec prelegent zwrócił nam uwagę, iż nie powinniśmy stosować bibliotek common'owych, które zawierają logikę biznesową. **Mikrousługi to zwinność**!

### Modern Agile Retrospectives

Pomimo, iż prezentacja była miękkim tematem, została poprowadzona w bardzo fajny i ciekawy sposób. **Piotr Stawirej** z firmy TomTom przedstawił sposoby na idealne retrospektywy. Samego procesu nie powinniśmy traktować jak zwykłego spotkania. Stosować należy różne techniki takie jak określanie Smart Goal'ów, czy Fishbone do określania przyczyn problemów. Warto zapamiętać, że im więcej czasu Scrum Master poświęci na przygotowanie retro, tym lepsze będą jego efekty.

### Getting Things Programmed

**Michał Bartyzel** był kolejnym prelegentem. Jest on autorem książki "**Getting Things Programmed**". Przedstawił on osiem punktów związanych z efektywną pracą. Każdy z punktów był szczegółowo omówiony i poparty przykładami z życia codziennego. W tych punktach znalazło się:

*   kolejkuj zadania
*   określ pierwszą czynność
*   zapisz zanim zakodzisz
*   narysuj zanim zaarchitekcisz
*   nazywaj
*   izoluj
*   pisz elegancko
*   znajduj czas na rzeczy ważne

Bardzo fajna prezentacja nie tylko dla ludzi związanych z **IT**.

### Nailing down bugs in distributed systems

Prelekcja poprowadzona przez **Kamila Szymańskiego** w zastępstwie za nieobecnego **Wojtka Oczkowskiego**, który miał opowiadać o transakcyjnym przetwarzaniu w JPA. Kamil podzielił swoją prezentację na trzy części:

*   narzędzia
*   integracja
*   proces eliminacji

W narzędziach znalazły się rozwiązania takie jak **Zipkin** (więcej [TUTAJ](http://codecouple.pl/2017/07/21/17-spring-boot-distributed-tracing-zipkin-i-sleuth/)), czy **Sentry**. Cała prezentacja oparta była o aplikację sklepu internetowego.

### WildFly Swarm: JavaEE w świecie mikroserwisów

**Michał Szynkiewicz** zaczął od przykładu serwisu do zamawiania pizzy. Było to prezentacja typu live coding. Przedstawione zostały przykłady jak integrować aplikację z różnymi systemami takimi jak **Keycloak**, **Zipkin** czy **OpenShift**. Integracja przebiegała bardzo płynie, zazwyczaj polegała ona na dodaniu zależności do **Mavena**. Na koniec prelegent pokazał jak debugować naszą aplikację przy wykorzystaniu narzędzia **Arquillian**.

### Podsumowanie

Bardzo dobrze i owocnie spędzony dzień w Łodzi. Dziękujemy organizatorom za zaproszenie i stawiamy mocną piątkę za organizację. Miejmy nadzieję do zobaczenia w przyszłym roku!