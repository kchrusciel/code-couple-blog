---
title: PEP8
tags:
  - PEP8
  - python
id: '287'
categories:
  - - Clean Code
  - - Python
date: 2016-02-16 21:48:26
author: 'Krzysztof Chruściel'
---

Dokument, który chciałam przedstawić zawiera konwencję zapisu kodu Pythonowego. Stosowanie się do niego nie przyspiesza wykonywania programów, ale sprawia, że kod staje się bardziej czytelny. Jeden z autorów **PEP8** (Guido van Rossum) zaznacza, że kod jest znacznie częściej czytany niż pisany i właśnie dlatego tak ważne jest dbanie o jego czytelność i jednolitość. Poniżej przedstawiłam kilka ważniejszych zasad PEP8.
<!-- more -->
**Wcięcia** 4 spacje na każdy poziom wcięcia. Poniżej przedstawione poprawne i niepoprawne użycie wcięć:

*   Wyrównanie do nawiasu:

def long\_function\_name(var\_one, var\_two,
                       var\_three, var\_four)

*   Podwójne wcięcie, żeby oddzielić (wyróżnić) od reszty kodu:

Poprawnie:

def long\_function\_name(
        var\_one, var\_two, var\_three,
        var\_four):
    print(var\_one)

Niepoprawnie:

def long\_function\_name(
    var\_one, var\_two, var\_three,
    var\_four):
    print(var\_one)

*   Wiszące wcięcia w nowej linii:

Poprawnie:

foo = long\_function\_name(
    var\_one, var\_two,
    var\_three, var\_four)

Niepoprawnie (pierwszy argument niedopuszczalny w pierwszej linii, jeśli nie stosujemy pionowego wyrównania):

foo = long\_function\_name(var\_one, var\_two,
    var\_three, var\_four)

**Spacje vs. tabulatory**

Do wcięć powinno się stosować spacje.

Tabulatory powinny służyć tylko do wyrównywania kolejnych linii kodu, który jest już wcięty przez tabulatory.

**Maxymalna długość linii**

79 znaków w jednej linii (docstringi i komentarze – 72). Linie mogą być zawijane (kontynuowane) poprzez dodanie lewego ukośnika "\\" na końcu linii. Jednak preferuje się zawijanie linii przez implikowaną kontynuację linii w nawiasach {}()\[\]. Poniżej przykład:

def \_\_init\_\_(self, name, surname,
             height, weight, address, job):
    if (name == "Krzysztof" and surname == "CodeCouple" and
            job == 'programmer' and height == 187 and
            weight <= 100):
        print "That's it!"
    if name is not "Krzysztof" and height != 187 and (name == "Agnieszka" or
                                                      weight < 15):
        print "That's not Krzysztof"

**Puste linie**

Definicje klas i funkcji na najwyższym poziomie oddzielamy dwoma liniami. Metody w klasie powinny być oddzielane jedną linią. Dodatkowe puste linie mogą być stosowane do oddzielenia grup funkcji powiązanych i do wskazania sekcji logicznych. Nie należy nadużywać pustych linii.

**Importy**

Importy umieszczane są zawsze na początku pliku, po komentarzach i docstringach, a przed globalnymi i stałymi. Powinny być pogrupowane według poniższej kolejności:

1.  importy bibliotek standardowych
2.  zewnętrzne importy spoza aplikacji
3.  importy z lokalnej aplikacji/biblioteki

Pomiędzy każdą grupą importów powinna być jedna pusta linia. Każdy import powiniem być dodany w nowej linii:

import os
import sys

Ale można dodawać również po przecinku, jeśli zaznaczamy skąd importujemy:

from subprocess import Popen, PIPE

**Cudzysłów pojedynczy vs. podwójny**

PEP8 nie rekomenduje pojedynczego ani podwójnego cudzysłowu. Obie wersje są poprawne. Nie należy mieszać tych wersji. Wybrać jedną i trzymać się jej konsekwentnie.

**Białe znaki w wyrażeniach i deklaracjach** Operatory binarne zawsze powinny być otoczone spacjami (taką samą ilością z obu stron).

*   Jeśli używane są operatory o różnych priorytetach, należy rozważyć dodanie spacji wokół operatorów z najniższym priorytetem. W takich przypadkach należy kierować się własną estetyką.

c = a\*b + a\*c

*   Należy unikać spacji zaraz po otwarciu nawiasu i przed jego zamknięciem oraz przed przecinkami, średnikami i dwukropkami.

Poprawnie:

funkcja\_Agi(name, surname)
if name == "Aga": print x, y; x, y = y, x

Niepoprawnie:

funkcja\_Krzysia( name, surname )
if name == "Krzys" : print x , y ; x , y = y , x

*   Nie stosuje się również białych znaków przed nawiasem z argumentami oraz indeksami:

Poprawnie:

Aga(name)
dct\['key'\] = list\[i\]

Niepoprawnie:

Krzys (name)
dct \['key'\] = list \[i\]

*   Błędnym jest używanie więcej niż jednej spacji w wyrażeniach w celu wyrównania operatorów:

Poprawnie:

aga = 1
krzys = 2
very\_long\_name\_of\_variable = 3

Niepoprawnie:

aga                        = 1
krzys                      = 2
very\_long\_name\_of\_variable = 3

**Komentarze**

Gorsze są błędne komentarze niż ich brak. Stosujemy pełne zdania. Pierwsza litera jest wielką, chyba że pierwsze słowo to identyfikator, który zaczyna się małą literą. Komentarze powinny być pisane w języku angielskim. Unikać komentarzy w tych samych liniach, co wyrażenie, do którego się odnosi.

**Nazewnictwo**

Nie powinno się stosować liter "l" (małe "L"), "O" (duże "o'), "I" (duże "i") jako pojedynczy znak, ponieważ w zależności od czcionki, mogą być one mylone z cyframi zero oraz jeden.

**Moduły i pakiety** powinny mieć krótkie nazwy składające się tylko z małych znaków. W pakietach podkreślenia są zalecane, a w modułach mogą być stosowane jeśli zwiększa to czytelność.

**Nazwy klas** powinny być zgodne z **CamelCase** (każdy kolejny wyraz w nazwie zaczyna się wielką literą).

**Nazwy wyjątków**, które w rzeczywistości są klasami, zgodne są z **CamelCase**. Powinny zaczynać się od słowa "Error", jeśli wyjątek jest w rzeczywistości błędem.

**Nazwy funkcji oraz zmiennych** powinny być pisane małymi literami z podkreśleniami pomiędzy kolejnymi wyrazami. Style mieszane są dozwolone tam, gdzie panuje inny styl przyjęty wcześniej (zachowanie kompatybilności wstecz).

**Argumenty funkcji i metod** – zawsze używamy "self" jako pierwszy argument metod instancji oraz "cls" jako pierwszy argument metod klas. Jeśli nazwa zarezerwowana jest jako słowo kluczowe, należy dołączyć podkreślenie, żeby uniknąć konfliktów.

**Stałe** są zazwyczaj definiowane na poziomie modułu i pisane wielkimi literami z podkreśleniami oddzielającymi wyrazy.

Przy stosowaniu PEP8 nie należy przesadzać. Ważne, żeby zawsze kierować się zdrowym rozsądkiem, zerknąć na inne przykłady, kawałki kodu. Zadecydować co wygląda najlepiej i zachować spójność. Nie należy niszczyć wcześniejszej kompatybilności całego projektu tylko i wyłącznie, żeby wprowadzić PEP8.