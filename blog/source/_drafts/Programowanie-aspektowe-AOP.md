---
title: Programowanie aspektowe - AOP
tags: []
id: '2669'
categories:
  - - Python
---

**Programowanie aspektowe** jest bardzo ciekawym **paradygmatem** programowania.
<!-- more -->
### Programowanie aspektowe

Wyobraźmy sobie sytuację, w której do zaimplementowania dostajemy system bankowy. Jeden z modułów odpowiedzialny będzie za realizowanie płatności. Ponadto klient chciałbym aby każda płatność miała mierzony czas operacji, oraz aby przed wywołaniem metody została wyświetlona informacja w logach. Zaczynamy implementować na kod:

\[snipped\]

Okazuje się że nasza metoda, której odpowiedzialnością jest tylko zrealizowanie płatności, sprawdza ponadto pola, dba o transakcyjność oraz wypisuje informacje do logów, gdzie podziało się **SRP**? Ponadto metoda traci na czytelności przez te wszystkie warunki poboczne. Aby pozbyć się tej nadmiarowości możemy wykorzystać **aspekty**, czyli w jednym miejscu zdefiniować zachowanie, które będzie wywoływane dla konkretnych warunków. Możemy zdefiniować **aspekt**, który będzie wypisywał informację do logów dla wszystkich metod ze słówkiem "_Payment_" w nazwie:

\[snipped\]

Od teraz w naszym metodach ze słówkiem "_Payment_" możemy usunąć logowanie. Dzięki zastosowaniu **aspektu**, nasz kod stał się bardziej czytelny i rzeczywiście zaczyna mieć tylko jedną odpowiedzialność. Ponadto **aspekty** są reużywalne, jeśli za jakiś czas okaże się iż więcej metody potrzebuje dodać logowanie w czasie wywołania metody, możemy wykorzystać stworzony przez nasz aspekt. Podsumowując aspekty służą do rozdzielenia funkcjonalności w bardzo elegancki sposób i wykorzystywania poprzez zdefiniowanie punktów interakcji.

### Pojęcia

Wraz z tym paradygmatem związanych jest kilka pojęć:

*   **Aspect** - jest to dodana przez nas funkcjonalność, która będzie wywoływana w ramach dołączenia aspektu (tutaj dodajemy naszą logikę, na przykład logowanie)
*   **JoinPoint** - jest to tak zwany punkt łączenia, czyli miejscu w który nasz aspekt zostanie dołączony/wywołany (przykładowo przed lub po metodzie)
*   **Advice** - tłumaczone jako porady, czyli osobne klasy, które używane są w zdefiniowanych wcześniej punktach złączeń

### Typy Advices

Typ definiuje kiedy ma zostać wywołany konkretny `Advice`. Istnieje kilka typów `Advice`:

*   **Before** - wywołanie przed wykonaniem - `@Before`
*   **After** - wywołanie po wykonaniu - `@After`
*   **After returning** - wywołanie po zwróceniu wartości - `@AfterReturning`
*   **After throwing** - wywołanie po rzuconym wyjątku - `@AfterThrowing`
*   **Around** - najszerszy zakres, dotyczy całego wywołania - `@Around`

### Praktyka