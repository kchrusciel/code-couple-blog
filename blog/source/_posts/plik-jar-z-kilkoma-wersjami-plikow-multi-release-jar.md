---
title: Plik Jar z kilkoma wersjami plików - Multi-Release Jar
tags:
  - jar
  - java
  - java 9
id: '4032'
categories:
  - - Java
date: 2019-09-02 12:01:05
---

![](https://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

W dzisiejszym wpisie wykorzystamy **funkcjonalność**, która pojawiła się wraz z wydaniem **Javy 9**. Jest to funkcjonalność o nazwie **Multi-Release Jar**. Pozwala ona na dostarczenie jednego **artefaktu** z plikami w różnych wersjach. Zapraszam do wpisu po więcej szczegółów.
<!-- more -->
### Problem

Bardzo często **migracja** do nowej wersji **Javy** wiąże się z **utrzymywaniem** starej wersji dla klientów, którzy się jeszcze nie **zmigrowali**. Jest to związane także z wydawaniem różnych wersji co komplikuje proces **CI** i **CD**. **Java** w teorii zapewnia kompatybilność wsteczną, ale nie zawsze działa to tak jakbyśmy zakładali. Wydawanie aplikacji w kilku wersjach prowadzi również do **problemów** na środowiskach **developerski** oraz **spowalnia** proces wytwarzania **oprogramowania**. Przykładowo mamy **dwójkę** klientów, jeden z nich korzysta z **Javy 8**, a drugi z **Javy 9**. W **Javie 9** pojawił się **feature X**, który może bardzo przyśpieszyć działanie kodu. Niestety poprzez jedną bazę kodu, nie dostosowujemy aplikacji, aby korzystała z nowego feature, ponieważ prowadziłoby to do wydania ekstra wersji dla klienta z **Java 8**. Nasz **development** jest ograniczony.

### Rozwiązanie - Multi-Release Jar

Rozwiązaniem powyższego problemu jest wykorzystanie funkcjonalności **Multi-Release Jar**. Pozwala ona dostarczyć jeden **artefakt**, który posiada przygotowane pliki dla różnych wersji **Javy**.

### Dwa pliki

W naszym przykładzie przygotujemy **dwa** pliki. Każdy z nich będzie wypisywał tekst z przekazanej listy **jednoelementowej**. Listy te będą tworzone na dwa sposoby:

*   z wykorzystaniem "**starego API**" czyli `Arrays.asList`
*   z wykorzystaniem **API** dostępnego od Javy 9 czyli `List.of`

public class Runner {

    public static void main(String\[\] args) {
        System.out.println(Arrays.asList("Java 8"));
    }

}

public class Runner {

    public static void main(String\[\] args) {
        System.out.println(List.of("Java 9"));
    }

}

Tutaj należy zwrócić uwagę jakich zmian **dokonaliśmy**. Zgodnie z **dokumentacją** możemy zmieniać tylko **logikę** wewnątrz **metody**. Wszystkie nagłówki i wygląd metod musi być taki sam. Nie możemy dokładać kolejnych **publicznych** metod.

### Struktura folderów

Następnie musimy przechowywać te pliki w uporządkowanej **strukturze**. Najczęściej przygotowuje się nowy folder z **numerem** wersji w nazwie:

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

### Kompilacja

Tak jak pisałem we wstępie funkcjonalność ta pojawiła się wraz z **Javą 9**. Po instalacji Javy i ustawieniu folderu `/bin` w zmiennych środowiskowych powinniśmy mieć dostęp do kompilatora **Javy**. Dostępny jest on pod poleceniem `javac`. Od wersji **Javy 9** pojawiło się kilka nowych **przełączników** w tym narzędziu. Dla nas najistotniejszy jest przełącznik `--release`:

javac --release <release>
Compile for a specific VM version. Supported targets: 6, 7, 8, 9

**Skompilujmy** więc nasze źródła dla **dwóch** wersji korzystając z tego przełącznika (przełącznik `-d` służy do wskazania **folderu**, gdzie mają znaleźć się **skompilowane** źródła. Można do tego wykorzystać też **Maven'a**):

javac --release 8 -d classes src\\main\\java\\pl\\codecouple\\Runner.java

Oraz źródła dla **Javy 9** z użyciem `List.of`:

javac --release 9 -d classes-9 src\\main\\java9\\pl\\codecouple\\Runner.java

### Budujemy multi-release jar

Udało nam się skompilować **kod źródłowy** w dwóch wersjach, teraz pora na przygotowanie **paczki** zawierającej obie **wersje**. Zrobimy to wykorzystując polecenie `jar`, które podobnie jak `javac` pochodzi z folderu `/bin`. Użyjemy także dodatkowego przełącznika `--release`, w którym wskazujemy **folder** ze **skompilowanymi** plikami w odpowiedniej wersji:

jar --release VERSION Places all following files in a versioned directory
of the jar (i.e. META-INF/versions/VERSION/)

Wszystkie te pliki zostaną umieszczone w folderze `META-INF/version/WERSJA/`:

jar --create --file multi-release.jar --main-class pl.codecouple.Runner -C classes . --release 9 -C classes-9 .

### Zawartość

Jak pisałem powyżej po wydaniu **polecenia** powinien pojawić się nowy plik `multi-release.jar`. **Zawartość** tego pliku prezentuje się następująco:

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

Wewnątrz folderu `versions/9` znalazł się **skompilowany** przez nas plik w wersji **Javy 9**. Ponadto w pliku `MANIFEST.MF`, który jest plikiem zawierającym dodatkowe informacje o **archiwum** pojawił się wpis:

Multi-Release: true

Jest to **wpis**, który świadczy o tym, iż to archiwum występuje w wersji **Multi-Release**. Jeśli chcielibyśmy **przetestować** nasz kod w działaniu wystarczy przygotować **środowisko** z dwiema wersjami **Javy** (polecam [SDKMAN](https://sdkman.io/)):

java -version
java version "9"
Java(TM) SE Runtime Environment (build 9+178)
Java HotSpot(TM) 64-Bit Server VM (build 9+178, mixed mode)

java -jar multi-release.jar
\[Java 9\]

java -version
java version "1.8.0\_144"
Java(TM) SE Runtime Environment (build 1.8.0\_144-b01)
Java HotSpot(TM) 64-Bit Server VM (build 25.144-b01, mixed mode)

java -jar multi-release.jar
\[Java 8\]

Jak widzicie powyżej, funkcjonalność **Multi-Release Jar** pozwoliła nam stworzyć jeden **artefakt** działający na obu wersjach **Javy**.