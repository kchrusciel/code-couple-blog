---
title: Jak działa Class Loader
tags:
  - class loader
  - java
  - jvm
id: '3596'
categories:
  - - Java
date: 2019-02-01 12:01:18
---

![](https://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

Kolejny z serii artykuł o **Class Loaderach**. W dwóch poprzednich poznaliśmy [podstawowe Class Loadery wbudowane](https://codecouple.pl/2019/01/18/class-loader-w-javie/) w **JVM** oraz w jaki [sposób możemy stworzyć własny Class Loader](https://codecouple.pl/2019/01/25/wlasny-class-loader/). Dziś na tapetę weźmiemy to co dzieje się pod spodem **Class Loadera**. Zapraszamy!
<!-- more -->
### Fazy

Proces ładowania klas poprzez **Class Loader** podzielony jest na poniższe fazy:

![](https://codecouple.pl/wp-content/uploads/2019/01/class_loader_phases-559x1024.png)

### Loading

Pierwszą fazą ładowania klasy jest **Loading**. Faza ta odpowiada za załadowanie binarnej reprezentacji pliku .class do pamięci **JVM'a**. Ładowane są tam takie dane jak nazwy **referencji**, informacje o **metodach** czy **konstruktorach**. Dla każdego pliku `.class` **JVM** tworzy nowy obiekt na heap'ie typu `java.lang.class`. Jest to obiekt reprezentujący załadowany obiekt. Nie jest to "prawdziwa" instancja obiektu załadowanej klasy tylko jego struktura. W naszym programie może istnieć wiele instancji danej klasy, ale klasa reprezentująca strukturę jest tylko jedna.

Ponadto podczas tej fazy występuje wstępna **weryfikacja**. Sprawdzana jest wtedy poprawność struktury pliku `.class` (dzieje się to również dla wszystkich klas powiązanych). Jeśli plik jest niepoprawny to wystąpi błąd typu `ClassFormatError`. Następnie sprawdzane jest czy numer wersji wygenerowanego pliku będzie pasował do aktualnej wersji **JVM**, jeśli nie to wystąpi błąd `UnsupportedClassVersionError`.

Po poprawnym stworzeniu obiektu i jego weryfikacji przechodzimy do fazy **Linking**.

### Linking

Podobnie jak faza **Loading**, **Linking** jest bardzo złożoną fazą. Składa się ona z trzech podfaz: **verifying**, **preparing** oraz **resolving**. Zadaniem **Loadingu** jest weryfikacja poprawności językowej zawartej w pliku `.class` oraz ustawienie wartości domyślnych dla pól.

#### Verifying

Pierwszą podfazą fazy **Linking** jest weryfikacja (ang. _verifying_). Podczas tej fazy sprawdzana jest poprawność kodu bajtowego. Proces ten wykonywany jest przez weryfikator kodu bajtowego. Sprawdzane są tam między innymi informacje o tym czy nie **wywołujemy** metod prywatnych z innych klas, czy nie **nadpisujemy** finalnych klas. Jeśli podczas weryfikacji wystąpi błąd to otrzymamy `VerifyError`.

Warto wspomnieć o tym, iż proces weryfikacji jest procesem kosztownym w kontekście ładowania klas. Natomiast wykonanie tego sprawdzania pozwala na szybsze działanie naszej aplikacji w runtime, ponieważ żadna weryfikacja kodu bajtowego nie musi już zachodzić.

#### Preparing

Po sprawdzeniu poprawności struktury oraz zawartości pliku .class następuje faza przygotowania (ang. _preparing_). Podczas tej fazy przypisywane są wartości domyślne dla pól statycznych. Ponadto tworzone są tutaj struktury wymagane przez **JVM** do popranego działania jak **tablice method**.

Podczas fazy **preparing** nie jest wywoływany kod związany ze **statycznymi initializatorami kodu**. Wywołanie tego kodu odbywa się w ostatniej fazie czyli **inicjalizacji**.

#### Resolving

Faza **resolving** jest fazą opcjonalną. Podczas tej fazy sprawdzana jest poprawność danych przechowywanych w klasowym obszarze zwanym **constant pool**. W obszarze tym przetrzymywane są dane o referencjach do innych klas i interfejsów. Jeśli któraś z klas jest wymagana podczas ładowania to faza ta sprawdza czy referencje rzeczywiście istnieją i są poprawne.

Czasami zdarza się, iż  chcemy załadować tylko klasę, a większość referencji będzie używanych potem. Przykładowo jeśli użycia znajdują się w metodach, które aktualnie nie są wywoływane. Wtedy ta faza jest opcjonalna dla tych niewymaganych referencji.

### Initializing

Ostatnia faza to inicjalizacja.