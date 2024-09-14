---
title: Sprawdzamy rozmiar naszych obiektów z Java Object Layout
tags:
  - java
  - java object layout
id: '3498'
categories:
  - - Java
date: 2019-01-04 12:01:52
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)Jeśli ktoś podobnie jak ja zastanawia się "_ciekawe ile ten obiekt zajmuje miejsca w pamięci?_" to mam dla was dobrą wiadomość! **Java Object Layout** (JOL) jest mini-programem, który potrafi policzyć jaki będzie rozmiar **obiektu** przechowywanego w **pamięci**. Oczywiście dobrze wiemy, iż w aktualnych czasach pamięć jest "tania", jednakże jeśli chcielibyśmy się przekonać, który obiekt zajmuje mniej miejsca w pamięci to zapraszam do artykułu.
<!-- more -->
### SerialNumber

Zaczniemy od stworzenia klasy reprezentującej **numer seryjny**. Na początku posiada ona tylko jedno pole typu `int`:

class SerialNumber {

    private final int value;

    SerialNumber(final int value) {
        this.value = value;
    }

}

### Typy prymitywne

Autorzy **Javy** założyli, iż ich platforma będzie przenaszalna. Aby to osiągnąć musieli rozwiązać wiele problemów. Jednym z nich były różne rozmiary typów. Dlatego też wirtualna maszyna Javy posiada z góry określone rozmiary dla typów prymitywnych:

*   `byte` - **1** bajt
*   `short` - **2** bajty
*   `int` - **4** bajty
*   `long` - **8** bajtów
*   `float` - **4** bajty
*   `double` - **8** bajtów
*   `char` - **2** bajty
*   `boolean` - rozmiar zależy od implementacji JVM (najczęściej jest to **1** bajt)

Więc jak dotychczas nasz obiekt `SerialNumber` powinien zajmować **4** bajty.

### Typy obiektowe

**Typy prymitywne** w **Javie** muszą znajdować się wewnątrz obiektu. Każdy obiekt zbudowany jest z typów prymitywnych lub z kolejnych typów obiektowych (które, "na samym dole" składają się z typów prymitywnych). Każdy typ obiektowy oprócz wartości pól przechowuje informacje o samym sobie (metadane). Metadane te składają się z:

*   `class` - wskaźnik do typu klasy w naszym przypadku - **4** bajty
*   `flagi` - przechowują informacje o stanie obiektu. Między innymi **shape** obiektu, czyli czy jest to klasa czy tablica oraz hash code - **4** bajty
*   `lock` - monitor, który będzie wykorzystywany do **mutex'ów** - **4** bajty
*   `size` - rozmiar tablicy (wartość ta obecna jest tylko dla typów tablicowych) - **4** bajty

Posiadając informację na temat typów obiektowych i prymitywnych wiemy już, iż nasz obiekt powinien zajmować **12 + 4 = 16 bajtów**. Aby to sprawdzić wykorzystamy do tego narzędzie **JOL** (skrót od **Java Object Layout**).

### Java Object Layout

Jak pisałem we wstępie **JOL** jest narzędziem do sprawdzania rozmiaru obiektów. Zacznijmy od dodania zależności do projektu:

<dependency>
    <groupId>org.openjdk.jol</groupId>
    <artifactId>jol-core</artifactId>
    <version>0.9</version>
</dependency>

Na samym początku wypiszmy informację o naszej aktualnej **wirtualnej maszynie**:

System.out.println(VM.current().details());

W odpowiedzi dostaniemy wiele ciekawych informacji:

\# Running 64-bit HotSpot VM.
# Using compressed oop with 0-bit shift.
# Using compressed klass with 0-bit shift.
# Objects are 8 bytes aligned.
# Field sizes by type: 4, 1, 1, 2, 2, 4, 4, 8, 8 \[bytes\]
# Array element sizes: 4, 1, 1, 2, 2, 4, 4, 8, 8 \[bytes\]

*   Uruchamiamy nasz program na **64** bitowej wersji **JVM - HotSpot**
*   **Compressed Oops** i **Klass** opiszemy w przyszłości
*   Obiekty będą wyrównane do **8** bajtów (to jest bardzo ważna informacja, dalej w artykule się to wyjaśni)
*   Rozmiary typów w naszej **JVM** (pierwsza wartość **4** bajty to **rozmiar referencji**)

Wypiszmy więc rozmiar naszego obiektu `SerialNumber`:

final SerialNumber serialNumber = new SerialNumber(123456);
System.out.println(ClassLayout.parseClass(SerialNumber.class).toPrintable(serialNumber));

W odpowiedzi otrzymamy:

pl.codecouple.SerialNumber object internals:
 OFFSET  SIZE   TYPE DESCRIPTION                               VALUE
      0     4        (object header)                           01 00 00 00
      4     4        (object header)                           00 00 00 00
      8     4        (object header)                           00 14 fd 16
     12     4    int SerialNumber.value                        123456
Instance size: 16 bytes
Space losses: 0 bytes internal + 0 bytes external = 0 bytes total

*   **0 - 4 bajtów** to **flagi** naszej klasy
*   **4 - 8 bajtów** to miejsce na **monitor**
*   **8 - 12 bajtów** to **wskaźnik** na typ obiektu, w tym przypadku jest to `pl.codecouple.SerialNumber`
*   **12 - 16 bajtów** nasza wartość `int`

Czyli zgodnie z założeniami nasz obiekt zajmuje **16 bajtów** pamięci.

### Wyrównanie do 8 bajtów

Spróbujmy do naszej klasy dodać kolejne pole typu `int`. W teorii nasza klasa powinna zajmować **20** bajtów:

class SerialNumber {

    private final int value;
    private final int secondValue;

    SerialNumber(final int value, int secondValue) {
        this.value = value;
        this.secondValue = secondValue;
    }

}

Sprawdzamy rozmiar:

pl.codecouple.SerialNumber object internals:
 OFFSET  SIZE   TYPE DESCRIPTION                               VALUE
      0     4        (object header)                           01 00 00 00
      4     4        (object header)                           00 00 00 00
      8     4        (object header)                           00 14 c2 16
     12     4    int SerialNumber.value                        123456
     16     4    int SerialNumber.secondValue                  1234567
     20     4        (loss due to the next object alignment)
Instance size: 24 bytes
Space losses: 0 bytes internal + 4 bytes external = 4 bytes total

Nasza klasa powinna zajmować **20** bajtów, natomiast zajmuje ich aż **24**. Jest to tak zwane wyrównanie do **8 bajtów**. **Java** "pod spodem" wyrównuje obiekty do wielokrotności **8 bajtów**. Czyli w naszym przypadku najbliższą wielokrotnością **8** przy **20** jest liczba **24** (dopełnianie to wynika z działania aktualnego JVM'a, "_Objects are 8 bytes aligned_"). Informacja o tym dopełnieniu znajduje się również na powyższym zrzucie rozmiaru.

### Rozmiar referencji

Co w przypadku jak oprócz typów prymitywnych w naszej klasie pojawią się typy obiektowe? **Rozmiar referencji** do obiektu zajmuje **4** lub **8** bajtów w zależności czy uruchamiamy program na **32 lub 64 bitowej** wirtualnej maszynie **Javy**. Sprawdźmy rozmiar obiektu korzystając z **JOL**:

class SerialNumber {

    private final int value;
    private final int secondValue;
    private final IntNumber objectValue;

    SerialNumber(final int value, int secondValue, IntNumber objectValue) {
        this.value = value;
        this.secondValue = secondValue;
        this.objectValue = objectValue;
    }

}

class IntNumber {

    private final int value;

    IntNumber(int value) {
        this.value = value;
    }
}

Wynik:

pl.codecouple.SerialNumber object internals:
 OFFSET  SIZE   TYPE DESCRIPTION                              VALUE
      0     4       (object header)                           01 00 00 00
      4     4       (object header)                           00 00 00 00
      8     4       (object header)                           00 14 c7 16
     12     4   int SerialNumber.value                        123456
     16     4   int SerialNumber.secondValue                  1234567
     20     4   IntNumber SerialNumber.objectValue            (object)
Instance size: 24 bytes
Space losses: 0 bytes internal + 0 bytes external = 0 bytes total

Gdy pierwszy raz pracowałem z **JOL** to wynik ten wydał mi się zbyt mały. Ponieważ, założyłem iż mój obiekt wewnętrzny będzie zajmował **16 bajtów** (**12** nagłówki + **4** dla `int`). Natomiast klasa `ClassLayout` zwraca rozmiar tylko aktualnej klasy wraz z referencją do obiektów zagnieżdzonych bez zliczania ich wewnętrznej reprezentacji. W tym przypadku wynik jest poprawny, ponieważ referencja zajmuje **4** bajty.

### Graph Layout

Aby policzyć całkowity rozmiar obiektu wraz z wszystkim typami referencyjnymi użytymi w środku powinniśmy skorzystać z klasy `GraphLayout`:

final SerialNumber serialNumber = new SerialNumber(123456, 1234567, new IntNumber(1));
System.out.println(GraphLayout.parseInstance(serialNumber).toFootprint());

Tym razem wynik się zgadza:

pl.codecouple.SerialNumber@66cd51c3d footprint:
     COUNT       AVG       SUM   DESCRIPTION
         1        16        16   pl.codecouple.IntNumber
         1        24        24   pl.codecouple.SerialNumber
         2                  40   (total)

### Github

Całość jak zawsze na [GitHub'ie](https://github.com/kchrusciel/CodeCouple/tree/master/JavaObjectLayout).