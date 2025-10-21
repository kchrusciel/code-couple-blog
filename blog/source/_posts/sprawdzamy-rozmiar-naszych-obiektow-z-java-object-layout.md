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

![](https://raw.githubusercontent.com/kchrusciel/code-couple-blog-assets/main/2017/02/java-logo.png)Jeśli ktoś, podobnie jak ja, zastanawia się: "_ciekawe, ile ten obiekt zajmuje miejsca w pamięci?_", to mam dla was dobrą wiadomość! **Java Object Layout** (JOL) to miniprogram, który potrafi obliczyć, jaki będzie rozmiar **obiektu** przechowywanego w **pamięci**. Oczywiście dobrze wiemy, że w aktualnych czasach pamięć jest "tania", jednakże jeśli chcielibyśmy się przekonać, który obiekt zajmuje mniej miejsca w pamięci, zapraszam do artykułu.
<!-- more -->
### SerialNumber

Zaczniemy od stworzenia klasy reprezentującej **numer seryjny**. Na początku posiada ona tylko jedno pole typu `int`:

```java
class SerialNumber {

    private final int value;

    SerialNumber(final int value) {
        this.value = value;
    }

}
```

### Typy prymitywne

Autorzy **Javy** założyli, że ich platforma będzie przenaszalna (przenośna). Aby to osiągnąć, musieli rozwiązać wiele problemów. Jednym z nich były różne rozmiary typów. Dlatego też Wirtualna Maszyna Javy (**JVM**) posiada z góry określone rozmiary dla typów prymitywnych:

* `byte` - **1** bajt
* `short` - **2** bajty
* `int` - **4** bajty
* `long` - **8** bajtów
* `float` - **4** bajty
* `double` - **8** bajtów
* `char` - **2** bajty
* `boolean` - rozmiar zależy od implementacji **JVM** (najczęściej jest to **1** bajt)

Więc jak dotychczas nasz obiekt `SerialNumber` powinien zajmować **4** bajty.

### Typy obiektowe

**Typy prymitywne** w **Javie** muszą znajdować się wewnątrz obiektu. Każdy obiekt zbudowany jest z typów prymitywnych lub z kolejnych typów obiektowych (które "na samym dole" składają się z typów prymitywnych). Każdy typ obiektowy, oprócz wartości pól, przechowuje informacje o samym sobie (metadane, czyli **nagłówki obiektów**). Metadane te składają się z:

* **wskaźnik do typu klasy** (`Klass Pointer`) - wskaźnik do typu klasy. W naszym przypadku (przy włączonym `Compressed Oops`) - **4** bajty.
* **flagi** (`Mark Word`) - przechowują informacje o stanie obiektu, w tym **hash code** oraz flagi **blokady** (lock) - **8** bajtów.

**Uwaga**: W nowoczesnych 64-bitowych JVM, nagłówki obiektu zazwyczaj zajmują **12 bajtów** (8 bajtów na `Mark Word` i 4 bajty na `Klass Pointer`, dzięki technice **Compressed Oops**).

Zakładając nagłówki o rozmiarze **12 bajtów**, wiemy już, że nasz obiekt powinien zajmować **12 + 4 = 16 bajtów**. Aby to sprawdzić, wykorzystamy narzędzie **JOL** (skrót od **Java Object Layout**).

### Java Object Layout

Jak pisałem we wstępie, **JOL** jest narzędziem do sprawdzania rozmiaru obiektów. Zacznijmy od dodania zależności do projektu:

```xml
<dependency>
    <groupId>org.openjdk.jol</groupId>
    <artifactId>jol-core</artifactId>
    <version>0.9</version>
</dependency>
```

Na samym początku wypiszmy informację o naszej aktualnej **Wirtualnej Maszynie**:

```java
System.out.println(VM.current().details());
```

W odpowiedzi dostaniemy wiele ciekawych informacji:

```shell
# Running 64-bit HotSpot VM.
# Using compressed oop with 0-bit shift.
# Using compressed klass with 0-bit shift.
# Objects are 8 bytes aligned.
# Field sizes by type: 4, 1, 1, 2, 2, 4, 4, 8, 8 [bytes]
# Array element sizes: 4, 1, 1, 2, 2, 4, 4, 8, 8 [bytes]
```

* Uruchamiamy nasz program na **64**-bitowej wersji **JVM - HotSpot**.
* **Compressed Oops** i **Klass** opiszemy w przyszłości.
* Obiekty będą wyrównane do **8** bajtów (to jest bardzo ważna informacja, która zostanie wyjaśniona dalej w artykule).
* Rozmiary typów w naszej **JVM** (pierwsza wartość **4** bajty to **rozmiar referencji**).

Wypiszmy więc rozmiar naszego obiektu `SerialNumber`:

```java
final SerialNumber serialNumber = new SerialNumber(123456);
System.out.println(ClassLayout.parseClass(SerialNumber.class).toPrintable(serialNumber));
```

W odpowiedzi otrzymamy:

```shell
pl.codecouple.SerialNumber object internals:
 OFFSET  SIZE   TYPE DESCRIPTION                               VALUE
      0     4        (object header)                           01 00 00 00
      4     4        (object header)                           00 00 00 00
      8     4        (object header)                           00 14 fd 16
     12     4    int SerialNumber.value                        123456
Instance size: 16 bytes
Space losses: 0 bytes internal + 0 bytes external = 0 bytes total
```

* **0 – 8 bajtów** to **Mark Word** (flagi i monitor).
* **8 – 12 bajtów** to **Klass Pointer** (wskaźnik na typ obiektu).
* **12 – 16 bajtów** to nasza wartość `int`.

Czyli zgodnie z założeniami (12 bajtów nagłówka + 4 bajty pola `int`), nasz obiekt zajmuje **16 bajtów** pamięci.

### Wyrównanie do 8 bajtów

Spróbujmy do naszej klasy dodać kolejne pole typu `int`. W teorii nasza klasa powinna zajmować $12 + 4 + 4 = **20** bajtów:

```java
class SerialNumber {

    private final int value;
    private final int secondValue;

    SerialNumber(final int value, int secondValue) {
        this.value = value;
        this.secondValue = secondValue;
    }

}
```

Sprawdzamy rozmiar:

```shell
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
```

Nasza klasa powinna zajmować **20** bajtów, natomiast zajmuje aż **24**. Jest to tak zwane **wyrównanie do 8 bajtów** (**Alignment Padding**). **Java** "pod spodem" wyrównuje rozmiar obiektów do wielokrotności **8 bajtów**. W naszym przypadku najbliższą wielokrotnością **8** dla **20** jest liczba **24**. To dopełnianie wynika z konfiguracji aktualnego JVM, o czym świadczy linia: "*Objects are 8 bytes aligned*". Informacja o tym dopełnieniu (`loss due to the next object alignment`) znajduje się również na powyższym zrzucie rozmiaru.

### Rozmiar referencji

Co w przypadku, gdy oprócz typów prymitywnych w naszej klasie pojawią się typy obiektowe? **Rozmiar referencji** do zagnieżdżonego obiektu zajmuje **4** lub **8** bajtów w zależności od tego, czy uruchamiamy program na **32- czy 64-bitowej** Wirtualnej Maszynie **Javy** (w przypadku 64-bitowej JVM z włączonym `Compressed Oops` referencja zajmuje 4 bajty). Sprawdźmy rozmiar obiektu korzystając z **JOL**:

```java
class SerialNumber {

    private final int value;
    private final int secondValue;
    private final IntNumber objectValue; // Referencja do innego obiektu

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
```

Wynik (`SerialNumber`):

```shell
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
```

Gdy pierwszy raz pracowałem z **JOL**, wynik ten wydał mi się zbyt mały. Założyłem, że obiekt wewnętrzny (`IntNumber`) będzie zajmował 16 bajtów (12 nagłówki + 4 dla `int`). Natomiast klasa `ClassLayout` zwraca rozmiar tylko **aktualnej klasy**, wraz z rozmiarem referencji do obiektów zagnieżdżonych, **bez zliczania** ich wewnętrznej reprezentacji. W tym przypadku wynik jest poprawny, ponieważ referencja zajmuje **4** bajty (4 bajty referencji + 16 bajtów pól + padding = 24 bajty).

### Graph Layout

Aby policzyć **całkowity rozmiar obiektu** wraz ze wszystkimi typami referencyjnymi użytych w środku (czyli ślad pamięci), powinniśmy skorzystać z klasy `GraphLayout`:

```java
final SerialNumber serialNumber = new SerialNumber(123456, 1234567, new IntNumber(1));
System.out.println(GraphLayout.parseInstance(serialNumber).toFootprint());
```

Tym razem wynik się zgadza:

```shell
pl.codecouple.SerialNumber@66cd51c3d footprint:
     COUNT       AVG       SUM   DESCRIPTION
         1        16        16   pl.codecouple.IntNumber
         1        24        24   pl.codecouple.SerialNumber
         2                  40   (total)
```

Całkowity rozmiar zajmowany w pamięci to **40 bajtów** (16 bajtów dla `IntNumber` + 24 bajty dla `SerialNumber`).

### Github

Całość jak zawsze na [GitHubie](https://github.com/kchrusciel/CodeCouple/tree/master/JavaObjectLayout).