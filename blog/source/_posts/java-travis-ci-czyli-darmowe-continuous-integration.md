---
title: Java + GitHub + Travis CI czyli darmowe continuous integration
tags:
  - CD
  - ci
  - continuous delivery
  - java
  - travis ci
id: '3305'
categories:
  - - Java
date: 2019-02-08 12:01:05
author: 'Krzysztof Chruściel'
---

![](https://codecouple.pl/wp-content/uploads/2019/02/travisci.png)

W aktualnych czasach ciężko wyobrazić sobie proces wytwarzania oprogramowania bez **CI** (ciągła integracja). W środowisku **JVM** najpopularniejszymi narzędziami do ciągłej intergacji są **Jenkins** i **Bamboo**. Niestety przy **małych** projektach lub projektach typu **open source** nie chcemy wykupywać maszyn, aby uruchomić **proces CI**. Rozwiązaniem tego problemu jest **darmowe** narzędzie **Travis CI**, które jest cloud'owym **systemem ciągłej integracji**.
<!-- more -->
### Github

Zanim zaczniemy stawiać pierwsze środowisko **CI** musimy zaopatrzyć się w **repozytorium kodu**. Rozwiązaniem bardzo dobrze współpracującym z **Travis CI** jest **GitHub**. Po założeniu konta możemy stworzyć **repozytorium**, które będzie wykorzystywane przez **Travis'a**. Nadajmy mu nazwę `travis-example`:

![](https://codecouple.pl/wp-content/uploads/2019/02/github-travis-test.png)

### Projekt

Po stworzeniu nowego **repozytorium** możemy umieścić tam **źródła**. W naszym przykładzie dodamy prosty projekt **Maven**, który będzie zawierał dwie **klasy**. Jedną z tych klas będzie klasa `pl.codecouple.Calculator`:

class Calculator {
    
    int add(final int first, final int second) {
        return first + second;
    }
    
}

Natomiast w folderze `src/test/java/pl/codecouple` znajdzie się klasa testowa `CalculatorTest`:

class CalculatorTest {

    @Test
    void shouldReturnFive() {
        // Given
        Calculator calculator = new Calculator();
        // When
        int result = calculator.add(3, 2);
        // Then
        assertThat(result).isEqualTo(5);
    }

}

### Odpalamy testy

Jeśli stworzyliśmy nowy projekt **Maven** musimy pamiętać o dodaniu **pluginu**, który będzie odpalał testy:

<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <version>2.22.0</version>
        </plugin>
    </plugins>
</build>

### Włączamy integracje

Aby zacząć korzystać z **Travis CI** musimy założyć konto na [https://travis-ci.org/](https://travis-ci.org/):

![](https://codecouple.pl/wp-content/uploads/2019/01/travis-ci-1024x383.png)

Najlepiej połączyć nasze nowe konto **Travis CI** z **Github'em** klikając:

![](https://codecouple.pl/wp-content/uploads/2019/01/travis-ci-sign-in.png)

Po połączeniu naszego konta z **Travis'em** należy wskazać, które **repozytorium** chcemy wykorzystać w **procesie budowania**. Po wybraniu interesującego nas **repozytorium** przełączamy suwak obok:

![](https://codecouple.pl/wp-content/uploads/2019/02/travis-ci-travis-example.png)

Udało nam się włączyć **ciągłą integrację** dla naszego **repozytorium**. Teraz pora na wskazanie **Travis'owi** co i jak chcemy budować.

### .travis.yml

W głównym folderze naszego repozytorium umieszczamy plik `.travis.yml`. Jest to plik, w którym **konfigurujemy** proces budowania. W naszym przypadku wystarczy wskazać, iż budujemy projekt związany z językiem **Java**:

language: java

**Commitujemy** i **pushujemy** wszystkie wprowadzone przez nas zmiany. Jeśli wszystko wykonaliśmy pomyślnie to pierwszy **build** (proces budowania) powinien odpalić się **automatycznie**:

![](https://codecouple.pl/wp-content/uploads/2019/02/travis-ci-build-status.png)

### Benefit

Wprowadźmy teraz zmianę w naszym kodzie, która powinna zepsuć proces budowania:

class Calculator {

    int add(final int first, final int second) {
        return first \* second;
    }

}

 **Commit**, **push** i obserwujemy **Travis CI**:

![](https://codecouple.pl/wp-content/uploads/2019/02/travis-ci-build-failed.png)

Jak widzicie, **Travis CI** zwrócił nam informację o niepoprawnym **zbudowaniu** **aplikacji**.

### Badge

Mechanizm **Badge** pozwala nam umieścić grafikę informującą o statusie naszego **procesu budowania**:

![](https://codecouple.pl/wp-content/uploads/2019/02/travis-ci-badge.png)

 

Najczęstszym rozwiązaniem jest wstawienie poniższego wpisu do pliku `README.md` naszego **repozytorium**:

\[!\[Build Status\](https://travis-ci.org/kchrusciel/travis-example.svg?branch=master)\](https://travis-ci.org/kchrusciel/travis-example)

Gdzie w odpowiednie miejsca wstawiamy nazwę **repozytorium** oraz **brancha**.

### Więcej

Będzie! **Travis CI** posiada bardzo dużo ciekawych **funkcjonalności**. Zapraszam do kolejnych wpisów po następne **usprawnienia** w naszym **procesie budowania** korzystając z darmowego **Travis CI**.

### GitHub

Całość jak zawsze na [GitHub'ie](https://github.com/kchrusciel/travis-example).