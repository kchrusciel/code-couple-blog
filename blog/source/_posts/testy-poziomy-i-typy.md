---
title: Testy - poziomy i typy
tags:
  - black-box
  - mock
  - test
  - white-box
id: '298'
categories:
  - - Testing
date: 2016-02-17 22:07:05
author: 'Krzysztof Chruściel'
---

[![](http://codecouple.pl/wp-content/uploads/2017/05/testingLogo.png)](http://codecouple.pl/wp-content/uploads/2017/05/testingLogo.png)

Zaczynając zabawę z testowaniem oprogramowania, należałoby wiedzieć jakie w ogóle mamy podziały testów i w jakich sytuacjach stosować każde z nich. Zaznaczmy, że poziomy i typy testów to dwa zupełnie różne, niezależne od siebie podziały. Każdy typ testu może być wykonany na każdym poziomie testowania. Przykładem są testy modułowe oraz systemowe, które dotyczyć mogą zarówno funkcjonalnych, jak i niefunkcjonalnych cech systemu. Niektóre połączenia poziomów i typów występują rzadziej, a inne częściej.
<!-- more -->
### Typy testów

Typy testów świadczą o celu ich wykonywania. Poniżej przedstawiłam cztery najbardziej znane typy:

*   funkcjonalne
*   niefunkcjonalne
*   strukturalne
*   ze względu na wprowadzane zmiany

_**Testy funkcjonalne**_ \- stanowią one weryfikację wymagań funkcjonalnych. Najprostszym językiem, sprawdzają "co" dany moduł robi. Wykorzystuje się tu **techniki czarnoskrzynkowe** (_ang. black-box_, bazują na specyfikacji, bez wnikania w kod programu).

_**Testy niefunkcjonalne**_ \- odpowiedzialne są za sprawdzanie "jak" działają dane komponenty. Testujemy tu między innymi niezawodność, efektywność, obciążenie systemu, czy bezpieczeństwo. Podobnie jak testy funkcjonalne, stosują one głównie **techniki czarnoskrzynkowe**, ale wymagane jest najczęściej specjalnie przygotowane środowisko testowe, czasem nawet specjalistyczny sprzęt.

_**Testy strukturalne**_ \- zwane są inaczej **testami białoskrzynkowymi** (_ang. white-box_) i ich zadaniem jest przetestowanie każdej możliwej ścieżki wykonania testowanego komponentu, podając odpowiednie dane na wejściu. Upewniamy się, że wszystkie elementy oprogramowania zostały pokryte przez testy.

_**Testy ze względu na zmiany**_ \-  dotyczą ponownego wykonania testu po wprowadzanych zmianach w kodzie. Testy te dzielimy na:

*   regresywne - testy po zaplanowanych zmianach kodu, upewniamy się, że po wprowadzonych zmianach nie pojawiły się nowe błędy.
*   retesty - testy zmiany kodu po wykryciu i naprawie błędu

W przypadku często wprowadzanych zmian i budowania nowych wersji stosowane są **smoke testy** (testy dymne). Dosłownie interpretując, są to testy, w których błędy zauważalne są w dymie wydobywającym się z urządzenia. W kontekście oprogramowania, smoke testy sprawdzają bardzo ogólnie działanie modułów (ich najważniejsze, główne funkcjonalności), nie wgłębiając się w szczegóły. Weryfikują czy występują jakieś poważne awarie uniemożliwiające przeprowadzenie innych testów.

### Poziomy testów

Poziomy testów odnoszą się do kolejnych faz wytwarzania oprogramowania. W zależności od projektu poziomy te trochę się różnią. W skrajnych przypadkach może występować tylko jeden poziom. Niezależnie od ilości poziomów, ich nazewnictwa i wyglądu, najważniejsze jest, żeby każdy poziom miał inny cel testowania, inną podstawę i najczęściej inny obiekt testowania. Każdy poziom ze względu na swój cel wykrywa różne typy błędów. Poniżej przedstawiłam klasyczne, najczęściej spotykane poziomy:

*   jednostkowe (inaczej modułowe, komponentów, unit-testy)
*   integracyjne
*   systemowe
*   akceptacyjne

_**Testy jednostkowe**_ - polegają na testowaniu pojedynczych modułów/komponentów oprogramowania. Testuje się w nich najmniejsze części oprogramowania (np. pojedyncze funkcje, klasy, moduły). Powinny być one wykonywane w izolacji od innych modułów. Jeśli mamy zależności pomiędzy komponentami, to powinniśmy zastosować **zaślepki** (_ang. stub_, kiedy testowany moduł wywołuje inny komponent) lub **sterowniki** (kiedy testowany obiekt jest wywoływany przez inny komponent), które symulują działanie części, które nie są obiektem testów. Ważne na tym poziomie jest testowanie **Corner Case'ów** (wartości brzegowych). Badamy tu jak najwięcej różnych ścieżek przejścia przez dany moduł, najlepiej wszystkie.

_**Testy integracyjne**_ - ich celem jest sprawdzenie poprawności integracji pomiędzy danymi komponentami. Na tym poziomie nie powinny być testowane pojedyncze części oprogramowania. Dobrym przykładem testów integracyjnych jest sprawdzanie poprawności łączenia się z bazą danych. Na tym poziomie testowane mogą być mniejsze komponenty takie jak funkcje, klasy, a także całe programy, systemy. Wyróżnić można tu **zstępującą** **i wstępującą** **metodę testowania.** Pierwsza z nich polega na testowaniu w pierwszej kolejności elementów najwyżej w hierarchii, a następnie niższych rzędów, kończąc na najniższym (stosowane są tu zaślepki). Metoda wstępująca działa odwrotnie. Zaczynamy od modułów najniższych rzędów (ułatwia to testowanie kolejnych modułów na wyższych rzędach), a kończąc na najwyższym.

_**Testy systemowe**_ - są przeprowadzane na zintegrowanym systemie i mają głównie sprawdzać scenariusze z punktu widzenia użytkownika. Sprawdzane są tu założenia i cele projektu. Uznawane są na najtrudniejsze testy, ponieważ bardzo ciężko je zautomatyzować. Wykonywane są najczęściej przez żywego osobnika i trwają bardzo długo.

_**Testy akceptacyjne**_ \- testy, które wykonywane są w celu akceptacji produktu przez klienta, lub inną uprawnioną do tego osobę. Na tym poziomie nie powinno być już żadnych błędów. Testy przeprowadzane są na środowisku docelowym i powinny sprawdzać, czy oprogramowanie spełnia oczekiwania i wszystkie założenia.