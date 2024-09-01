---
title: '#6 Wzorce projektowe: Feature Toggles'
tags:
  - feature toggle
id: '3003'
categories:
  - - Wzorce projektowe
---

![](http://codecouple.pl/wp-content/uploads/2017/03/designPatternArt.png)

"_Cześć, nazywam się Łukasz Szydło i od 2010 nie stworzyłem brancha_" - takimi słowami (parafrazując) rozpoczął swoją prezentacje pt. "_WJUG #181 - Continuous Delivery: architektura i praktyka_" **Łukasz Szydło**. Jest to wystąpienie w którym **Łukasz** próbuje przekonać na do stosowania wzroca **Feature Toggles**. Jest to wzorzec, dzięki któremy uda nam się uniknąć między innymi **merge hell'i**, ale czy jest to jedyny benefit? Zapraszam do artykułu!
<!-- more -->
### Feature Toggle

Feature toggle jest to technika, która pozwala włączać lub wyłączać funkcjonalności w aplikacji (bez zmian w kodzie). Zmiana ta może odbywać się przy budowania aplikacji lub w trakcie jej działania. Jest to potężne narzędzie ułatwiające ciągła integracje funkcjonalności. Pozwala ona na szybkie dostarczanie nowych feature'ów, które można bardzo szybko wyłączyć w przypadku niepowodzenia.

### Zalety

Dzięki stosowaniu **Feature Toggles** możemy uniknąć merge hell'i. Jeśli nasz kod od razu znajduje się na głównym branchu, nie mamy problemu z long-live branchami. Jeśli nie będziemy zbyt często mergować develop brancha do naszego long-live feature brancha, może się okazać iż mamy bardzo wiele konfliktów do rozwiązania (szczególnie przydatne przy nowych, małych projektach), lub część logiki została zaimplementowana w innym miejscu.

Szybko widzimy zmiany innych.

Lepszy kod (bardziej abstrakcyjny). Brzydki kod na branchu bo jest bezpiecznie? Siadacie do nowej zmiany, to zanim napiszesz, robisz refactoring.

Kolejną zaletą jest szybszy dostarczanie aplikacji. Jeśli kod nowego feature znajduje się już w kodzie produkcyjnym, dzięki wykorzystaniu jednej flagi, która może być zmieniona z runtime, od razu możemy dostarczyć nową funkcjonalność, bez potrzeby budowania nowej aplikacji.

Feature Toggles pozwala być bardziej "Business Oriented".  Możemy sterować różnymi logicznymi przypadkami (dla regionów). Przykładowo możemy uruchomić nową

Prostszy CI (wystarczy budować z master branch'a)

### Wady

W zależności od implementacji, wadą może być narzut związany ze sprawdzaniem takiej flagi, która decyduje, który feature ma być uruchomiony. Jeśli przechowujemy stan w bazie, a mamy bardzo dużą ilość użytkowników to za każdym razem tą bazę odpytujemy. Oczywiście możemy tą wartość cachować, jednakże jest to kolejny narzut na implementację.

Dodatkowe commity

Tarcimy poczucie bezpieczeństwa.

Trudniejsze testowanie (różne kombinacje)

Review?

### Więcej

W następnych artykułach, przedstawię wam jak wykorzystać gotową bibliotekę do **Feature Toggles** wraz ze **Spring Boot'em**. Korzystacie z **Feature Toggles**? Jakie są wasze opinie?