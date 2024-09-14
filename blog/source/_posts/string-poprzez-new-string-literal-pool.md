---
title: String poprzez new? - String Literal Pool
tags:
  - flyweight
  - GC
  - IoT
  - java
  - jvm
  - pyłek
  - string
  - string literal pool
id: '508'
categories:
  - - Clean Code
  - - Java
  - - JVM
date: 2016-06-11 09:00:33
author: 'Krzysztof Chruściel'
---

**String**, chyba najpopularniejszy obiektowy typ danych wykorzystywany w **Javie**. Kluczowe słowo to **obiektowy.** Jak dobrze wiemy, obiekty tworzymy poprzez słówko **new**, natomiast jak typowo tworzymy obiekt typu **String,** to nie używamy tego słowa kluczowego.
<!-- more -->
Pierwotnie **Java** miała być wykorzystywana do koncepcji zwanej aktualnie **IoT** (ang. **Internet Of Things**). Miała być stosowana na różnych urządzeniach, stąd pomysł o jej przenośności, czyli niezależenie od sprzętu dało się ją uruchomić wszędzie, gdzie był zainstalowany **JVM**. Urządzenia, na których miały działać programy miały bardzo dużo ograniczeń, jednym z nich była pamięć. Najbardziej "pamięciożernym" typem danych były **Stringi,** dlatego też autorzy wykorzystali wzorzec **Pyłek** (ang. **FlyWeight Pattern**, więcej o tym wzorcu już niedługo napisze **Agnieszka**!), który wykorzystywany jest wtedy, gdy często tworzone są obiekty, które mają takie same dane. Pozostawiając koncepcję **IoT** oraz **Pyłku** przejdźmy do przykładów.

Zacznijmy od utworzenia łańcucha znaków, możemy to wykonać na dwa sposoby:

String codeCouple = "codeCouple";
String agnieszka = new String("Agnieszka");

W momencie tworzenia obiektu typu **String,** zapisywana jest referencja w **String Literal Pool** odnosząca się do tego łańcucha znaków. **String Literal Pool** znajduje się na **Heap'ie**, jest to zbiór referencji do literałów łańcuchowych, które nie są czyszczone poprzez **GC**, dzięki temu przy tworzeniu takich samych łańcuchów oszczędzana jest pamięć. W przypadku gdy utworzymy:

String codeCouple = "codeCouple";
String codeCoupleSecond = "codeCouple";

Zostały utworzone trzy referencja, pierwsza w **String Literal Pool**, oraz dwie lokalne referencje. Dzięki temu możemy porównywać Stringi przy użyciu operatora "**\==**":

String codeCouple = "codeCouple";
String codeCoupleSecond = "codeCouple";

System.out.println(codeCouple == codeCoupleSecond);

result: true

Natomiast gdy utworzymy dwa **Stringi** o tej samej zawartości jednakże przynajmniej jeden z nich będzie utworzony ze słowem kluczowym "**new**" wtedy operator "**\==**" zwróci F**alse** ponieważ nie porównuje on zawartości a referencje:

String codeCouple = "codeCouple";
String codeCoupleSecond = new String("codeCouple");

System.out.println(codeCouple == codeCoupleSecond);

result: false

Aby porównać wartości należy użyć metody "**equals**", która korzysta z tablicy **char'ów**. **String** w pamięci przechowywany jest jako tablica **char'ów,** czyli każdy znak to jeden element tablicy. W momencie wywołania metody "**equals**" dwie tablice porównują swoje pojedyncze znaki. W momencie gdy znaki w obu tablicach się zgadzają dostajemy **True**. **String** jest obiektem typu **Immutable,** czyli jest niezmienny, ale więcej o tej koncepcji napiszę w innym artykule:

String codeCouple = "codeCouple";
String codeCoupleSecond = new String("codeCouple");

System.out.println(codeCouple.equals(codeCoupleSecond));

result: true

Gdy wiemy, że używamy **Stringów** bez użycia "**new**" wtedy lepiej używać operatora "**\==**" ponieważ tańsze jest sprawdzenie referencji niż iteracja po dwóch tablicach **char'ów**.

Gdy zależy nam na znikomej optymalizacji związanej z **call stackiem** możemy użyć operatora "**\==**" wtedy od razu czyli w notacji dużego **O** otrzymamy złożoność **O(1)** natomiast sam operator "**\==**" jest zaimplementowany w metodzie "**equals()**" dla tego też niema sensu korzystać z operatora porównania bo korzyści związane z mniejszą ilością skoków jest znikoma.