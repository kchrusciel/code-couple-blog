---
title: Plik Jar z kilkoma wersjami plików - Multi-Release Jar
tags:
  - jar
  - java
  - java 9
id: '4032'
category: Java
date: 2019-09-02 12:01:05
author: 'Krzysztof Chruściel'
---

![](https://raw.githubusercontent.com/kchrusciel/code-couple-blog-assets/main/2017/02/java-logo.png)

W dzisiejszym wpisie wykorzystamy **funkcjonalność**, która pojawiła się wraz z wydaniem **Javy 9**. Jest to funkcja o nazwie **Multi-Release Jar**. Pozwala ona na dostarczenie jednego **artefaktu** zawierającego pliki w różnych wersjach dla poszczególnych edycji Javy. Zapraszam po więcej szczegółów.
<!-- more -->
### Problem

Bardzo często **migracja** do nowej wersji **Javy** wiąże się z koniecznością **utrzymywania** starej wersji dla klientów, którzy jeszcze się nie **zmigrowali**. Związane jest to również z wydawaniem różnych wersji aplikacji, co komplikuje procesy **CI** i **CD**. **Java** w teorii zapewnia kompatybilność wsteczną, ale nie zawsze działa to tak, jakbyśmy tego oczekiwali. Wydawanie aplikacji w kilku wersjach prowadzi również do **problemów** na środowiskach **developerskich** oraz **spowalnia** proces wytwarzania **oprogramowania**.

Przykładowo, mamy **dwóch** klientów: jeden korzysta z **Javy 8**, a drugi z **Javy 9**. W **Javie 9** pojawił się **feature X**, który mógłby znacząco przyspieszyć działanie kodu. Niestety, ze względu na utrzymywanie jednej bazy kodu, nie dostosowujemy aplikacji do korzystania z nowego feature, ponieważ wymusiłoby to wydanie dodatkowej wersji dla klienta z **Javą 8**. Nasz **development** jest tym samym ograniczony.

### Rozwiązanie - Multi-Release Jar

Rozwiązaniem powyższego problemu jest wykorzystanie funkcjonalności **Multi-Release Jar**. Pozwala ona dostarczyć jeden **artefakt**, który posiada przygotowane pliki dla różnych wersji **Javy**.

### Dwa pliki z implementacją

W naszym przykładzie przygotujemy **dwa** pliki. Każdy z nich będzie wypisywał tekst z przekazanej listy **jednoelementowej**. Listy te będą tworzone na dwa sposoby:

* z wykorzystaniem "**starego API**", czyli `Arrays.asList` (dla Javy 8)
* z wykorzystaniem **API** dostępnego od Javy 9, czyli `List.of` (dla Javy 9)

```java
public class Runner {

    public static void main(String[] args) {
        System.out.println(Arrays.asList("Java 8"));
    }

}

public class Runner {

    public static void main(String[] args) {
        System.out.println(List.of("Java 9"));
    }

}
```

Tutaj należy zwrócić uwagę na **dokonane zmiany**. Zgodnie z **dokumentacją**, możemy zmieniać tylko **logikę** wewnątrz **metody**. Wszystkie nagłówki i sygnatury metod muszą być takie same. Nie możemy dokładać kolejnych **publicznych** metod.

### Struktura folderów

Następnie musimy przechowywać te pliki w uporządkowanej **strukturze**. Najczęściej przygotowuje się nowy folder z **numerem** wersji w nazwie:

```
src/
    main/
        java/
            pl/
              codecouple/
                    Runner.java
        java9/
            pl/
              codecouple/
                    Runner.java
```

### Kompilacja

Jak pisałem we wstępie, funkcjonalność ta pojawiła się wraz z **Javą 9**. Po instalacji Javy i ustawieniu folderu `/bin` w zmiennych środowiskowych powinniśmy mieć dostęp do kompilatora **Javy** (`javac`). Od wersji **Javy 9** pojawiło się kilka nowych **przełączników** w tym narzędziu. Dla nas najistotniejszy jest przełącznik `--release`:

```shell
javac --release <release>
Compile for a specific VM version. Supported targets: 6, 7, 8, 9
```

**Skompilujmy** więc nasze źródła dla **dwóch** wersji, korzystając z tego przełącznika (przełącznik `-d` służy do wskazania **folderu** docelowego dla **skompilowanych** źródeł. Można do tego wykorzystać też **Maven'a**):

```shell
javac --release 8 -d classes src\main\java\pl\codecouple\Runner.java
```

Oraz źródła dla **Javy 9** z użyciem `List.of`:

```shell
javac --release 9 -d classes-9 src\main\java9\pl\codecouple\Runner.java
```

### Budowanie Multi-Release Jar

Udało nam się skompilować **kod źródłowy** w dwóch wersjach, teraz pora na przygotowanie **paczki** zawierającej obie **wersje**. Zrobimy to, wykorzystując polecenie `jar`, które, podobnie jak `javac`, pochodzi z folderu `/bin`. Użyjemy także dodatkowego przełącznika `--release`, w którym wskazujemy **folder** ze **skompilowanymi** plikami dla odpowiedniej wersji:

```shell
jar --release VERSION Places all following files in a versioned directory
of the jar (i.e. META-INF/versions/VERSION/)
```

Wszystkie te pliki zostaną umieszczone w folderze `META-INF/versions/WERSJA/`:

```shell
jar --create --file multi-release.jar --main-class pl.codecouple.Runner -C classes . --release 9 -C classes-9 .
```

### Zawartość archiwum

Jak pisałem powyżej, po wydaniu **polecenia** powinien pojawić się nowy plik `multi-release.jar`. **Zawartość** tego pliku prezentuje się następująco:

```
pl/
    codecouple/
        Runner.class
META-INF/
    versions/
        9/
            pl/
                codecouple/
                    Runner.class
    MANIFEST.MF
```

Wewnątrz folderu `versions/9` znalazł się **skompilowany** przez nas plik w wersji **Javy 9**. Ponadto w pliku `MANIFEST.MF`, który zawiera dodatkowe informacje o **archiwum**, pojawił się wpis:

```
Multi-Release: true
```

Jest to **wpis**, który świadczy o tym, że to archiwum jest w wersji **Multi-Release**. Jeśli chcielibyśmy **przetestować** nasz kod w działaniu, wystarczy przygotować **środowisko** z dwiema wersjami **Javy** (polecam [SDKMAN](https://sdkman.io/)):

```shell
java -version
java version "9"
Java(TM) SE Runtime Environment (build 9+178)
Java HotSpot(TM) 64-Bit Server VM (build 9+178, mixed mode)

java -jar multi-release.jar
[Java 9]

java -version
java version "1.8.0_144"
Java(TM) SE Runtime Environment (build 1.8.0_144-b01)
Java HotSpot(TM) 64-Bit Server VM (build 25.144-b01, mixed mode)

java -jar multi-release.jar
[Java 8]
```

Jak widać powyżej, funkcjonalność **Multi-Release Jar** pozwoliła nam stworzyć jeden **artefakt** działający na obu wersjach **Javy**.