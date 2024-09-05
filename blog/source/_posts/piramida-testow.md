---
title: Piramida testów
tags:
  - test
  - test doubles
id: '1717'
categories:
  - - Testing
date: 2017-05-12 15:30:33
author: 'Krzysztof Chruściel'
---

[![](http://codecouple.pl/wp-content/uploads/2017/05/testingLogo.png)](http://codecouple.pl/wp-content/uploads/2017/05/testingLogo.png)

Rozmawiając z kilkoma osobami na temat podziału ilości testów względem ich przeznaczenia okazało się, że pojęcie **piramidy testów** nie jest aż tak popularne jak mi się wydawało. Ponad pół roku temu **Agnieszka** w bardzo fajny sposób [opisała rodzaje testów](http://codecouple.pl/2016/02/17/testy-poziomy-i-typy/), dlatego też ten wpis jest tylko uzupełnieniem jej postu. Także w pierwszej kolejności zapraszam do przeczytania jej artykułu i zapraszam z powrotem!
<!-- more -->
**Piramida testów** to nic innego jak przedstawienie w sposób graficzny **hierarchii ilości** wykonywanych testów: [![](http://codecouple.pl/wp-content/uploads/2017/05/testPyramid.png)](http://codecouple.pl/wp-content/uploads/2017/05/testPyramid.png)

### Testy jednostkowe

Na samym dole znajdują się **testy jednostkowe** (około **70%** wszystkich testów). Testy te powinny testować pojedynczą "**jednostkę**" kodu. Są "**najtańsze**". Oznacza to, że wykonywanie ich jest bardzo szybkie, ponieważ nie testują one **komponentów graficznych** oraz **integracji** z innymi systemami, co związane jest z przygotowaniem odpowiednich środowisk. Ponadto, testy te uruchamiane są w **izolacji**, oznacza to, że nie jesteśmy w żaden sposób związani z innymi elementami systemu. Aby osiągnąć **izolację** wykorzystujemy  [Test Doubles](https://martinfowler.com/bliki/TestDouble.html).

### Testy integracyjne

Środkową pozycję zajmują **testy integracyjne** (około **20%** wszystkich testów). Testują one "**integrację**" z innymi komponentami/serwisami/usługami zewnętrznymi. Nie są to już testy uruchamiane w kompletnej izolacji jak w **testach jednostkowych,** tym razem interesuje nas integracja z innymi komponentami, na przykład z naszą bazą danych.

### Testy akceptacyjne - end to end - funkcjonalne

Testy te są różnie nazywane, jednakże są to **testy akceptacyjne** (około **10%** wszystkich testów), które znajdują się na samej górze hierarchii naszej **piramidy**. Testują one całą **funkcjonalność** od początku do końca (**end to end**), symulują zachowanie użytkowników i najczęściej testują też **UI** przy wykorzystaniu na przykład **Selenium**.

Bardzo obrazowa koncepcja **piramidy testów** pomaga nam określić ich priorytety.