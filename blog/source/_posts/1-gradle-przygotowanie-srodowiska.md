---
title: '#1 Gradle - przygotowanie środowiska'
tags:
  - gradle
id: '1275'
categories:
  - - Gradle
date: 2017-01-13 14:00:54
author: 'Krzysztof Chruściel'
---

[![gradlelogo](http://codecouple.pl/wp-content/uploads/2017/01/GradleLogo.png)](http://codecouple.pl/wp-content/uploads/2017/01/GradleLogo.png)

**Maven** z wielu względów cały czas jest dla mnie narzędziem do budowania numer jeden. Jednakże mam tylko porównanie do **Ant'a** z **Ivy**. Od kilku lat na rynku bardzo mocno przebija się **Gradle**. Wykorzystywany jest on jako podstawowe narzędzie do budowania na platformę **Android**.
<!-- more -->
Na początek jeden wykres, który pokazuje, że **Maven** ciągle jest narzędziem do budowania numer jeden:

\[caption id="attachment\_1278" align="aligncenter" width="622"\][![https://zeroturnaround.com/rebellabs/java-tools-and-technologies-landscape-2016/](http://codecouple.pl/wp-content/uploads/2017/01/GradleWykres.png)](http://codecouple.pl/wp-content/uploads/2017/01/GradleWykres.png) _źródło: https://zeroturnaround.com/rebellabs/java-tools-and-technologies-landscape-2016/_\[/caption\]

Brakuje mi wiedzy, aby określić, który tool bardziej mi odpowiada, a miałem ochotę pobawić się **Groovy'm**, dlatego też zakupiłem książkę "_Introducing Gradle_" autorstwa **Balaji Varanasi** i **Sudha Belida** (w najbliższym czasie napiszę recenzję tej książki).

### 1. Minimum JDK 6

Aby móc korzystać z **Gradle** wymagane jest **JDK** w wersji minimum 6. Należy też mieć dodaną Javę do zmiennych środowiskowych.

**JAVA\_HOME** = ścieżka do naszego folderu z Javą,

**PATH** = %JAVA\_HOME%\\bin;

### 2. Instalacja Gradle

Instalacje **Gradle** zacznijmy od pobrania najnowszej wersji narzędzia. Wersja wykorzystana we wpisie to **3.3**. Link: [https://gradle.org/gradle-download/](https://gradle.org/gradle-download/). Najlepiej wybrać wersję **Complete distribution,** otrzymujemy dzięki temu między innymi dokumentację off-line, która może się przydać szczególnie na początku naszej przygody z **Gradle**. Po pobraniu źródeł i rozpakowaniu musimy zrobić to samo co z **Javą**. Należy dodać nową zmienną środowiskową **GRADLE\_HOME** i dodać ją do zmiennej **PATH**:

**GRADLE\_HOME** = ścieżka do naszego folderu z Gradle,

**PATH** = %GRADLE\_HOME %\\bin;

Od teraz po wydaniu polecenia `gradle -v` widzimy, że mamy zainstalowanego **Gradle**.

you\_run\_path>gradle -v

------------------------------------------------------------
Gradle 3.3
------------------------------------------------------------

Build time: 2017-01-03 15:31:04 UTC
Revision: 075893a3d0798c0c1f322899b41ceca82e4e134b

Groovy: 2.4.7
Ant: Apache Ant(TM) version 1.9.6 compiled on June 29 2015
JVM: 1.8.0\_101 (Oracle Corporation 25.101-b13)
OS: Windows 7 6.1 amd64

Jeśli nie możemy z jakiś przyczyn zainstalować **Gradle** na naszym środowisku możemy skorzystać z **Gradle Wrappera**. O samym **Wrapperze** w następnych wpisach.

### 3. Instalacja Groovy'ego

**Groovy** nie jest wymaganym elementem do pracy z **Gradle**, natomiast dobrze jest go zainstalować by móc poćwiczyć sobie składnie **Groovy'iego,** która jest wykorzystywana do budowania plików **Gradlowych**. Podobnie jak **Java** oraz **Gradle** należy pobrać najnowsze źródła. Wersja wykorzystana we wpisie to **2.4.7** Link: [http://groovy-lang.org/download.html](http://groovy-lang.org/download.html). Kroki postępowania są takie same jak dla **Javy** i **Gradle**. Czyli po pobraniu źródeł należy je rozpakować i dodać nową zmienną środowiskową **GROOVY\_HOME**, a następnie dodać ją do zmiennej **PATH**:

**GROOVY\_HOME** = ścieżka do naszego folderu z **Groovy'm**,

**PATH** = %GROOVY\_HOME %\\bin;

Od teraz po wydaniu polecenia `groovy -v` widzimy, że mamy zainstalowanego **Groovy'ego**.

you\_run\_path>groovy -v
Groovy Version: 2.4.7 JVM: 1.8.0\_101 Vendor: Oracle Corporation OS: Windows 7

Możemy teraz skorzystać z shella wbudowanego w **Groovy'ego**. W folderze `\bin` naszej instalacji znajduje się plik wykonywalny `groovysh.bat,` który uruchomi interaktywną konsolę języka **Groovy**. Możemy napisać teraz polecenie `println 'CodeCouple.pl'` i korzystać z możliwości **Groovy'ego.**

you\_run\_path>groovysh.bat
Groovy Shell (2.4.7, JVM: 1.8.0\_101)
Type ':help' or ':h' for help.
--------------------------------------------------
groovy:000> println 'CodeCouple.pl'
CodeCouple.pl
===> null
groovy:000>

### 4. Pierwszy skrypt

W dowolnym folderze utwórzmy teraz plik `build.gradle`. Rozszerzenie **\*.gradle** jednoznacznie identyfikuje pliki **Gradlowe**. Natomiast nazwa **build** jest nazwą domyślną. Oznacza to, że w momencie wydania polecenia `gradle nazwa_taska`, **task** czyli nasze zadanie będzie szukane w tym pliku. Natomiast nie jest to nazwa obowiązkowa. Można utworzyć pliki z dowolnymi nazwami jak na przykład **build-dev.gradle.** Jedyną różnicą w przypadku zmiany nazwy jest uruchamianie. Należy dodać wtedy dodatkową flagę -b (`gradle -b build-dev.gradle`).

Do pliku **build.gradle** dodajemy następującą treść:

task showCodeCouple << {
   println 'CodeCouple.pl'
}

Aby uruchomić nasz plik, należy uruchomić komendę `gradle nazwa_taska` (komendę należy uruchomić w tym samym folderze, gdzie znajduje się nasz plik **build.gradle**), czyli w naszym przypadku:

you\_run\_path>gradle showCodeCouple
:showCodeCouple
CodeCouple.pl

BUILD SUCCESSFUL

Total time: 1.072 secs

Możemy także uruchomić nasz skrypt z flagą `-q`, dzięki temu mamy tryb "cichy", czyli bez zbędnego **boilerplate'u**:

you\_run\_path>gradle -q showCodeCouple
CodeCouple.pl

Zapraszam do kolejnych wpisów po kolejną dawkę **Gradlowych** informacji!