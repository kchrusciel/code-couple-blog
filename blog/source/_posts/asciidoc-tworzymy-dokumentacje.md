---
title: AsciiDoc - Tworzymy dokumentacje
tags:
  - asciidoc
  - asciidoctor
  - documentation
  - spring rest docs
id: '2121'
categories:
  - - Documentation
date: 2017-09-08 12:05:40
---

[![](http://codecouple.pl/wp-content/uploads/2017/09/documentation.png)](http://codecouple.pl/wp-content/uploads/2017/09/documentation.png)Artykuł ten powiązany jest z [poprzednim wpisem](http://codecouple.pl/2017/08/25/18-spring-boot-tddocumentation-spring-rest-docs/) na temat **Spring Rest Docs,** czyli automatycznego generowania dokumentacji na podstawie testów. Dzięki **Spring Rest Docs** generowane były snippety, czyli fragmenty dokumentacji, które następnie umieszczało się w pliku zbiorczym z rozszerzeniem `adoc`. Na końcu należało te fragmenty ładnie opakować korzystając ze składni **AsciiDoc'a**.
<!-- more -->
### DocGist

Nam sam początek polecam wam **[ten edytor online](http://gist.asciidoctor.org)**, w którym można pobawić się na żywo z **AsciiDoc'iem**. Jest to fajne miejsce do sprawdzenia możliwości tego narzędzia.

### Live preview via Chrome

Możemy zacząć teraz tworzenie naszej dokumentacji. Utwórzmy plik z rozszerzeniem `adoc`. i dodajmy do niego treść:

\= To jest tytuł dokumentacji

Witajcie na CodeCouple.pl!

== To jest pierwszy nagłówek

Teraz aby podejrzeć zmiany najlepiej jest zainstalować sobie plugin do przeglądarki. Ja korzystam z **Chrome** także polecam wam [ten dodatek](https://chrome.google.com/webstore/detail/asciidoctorjs-live-previe/iaalpfgpbocpdfblpnhhgllgbdbchmia). Od teraz wystarczy odpalić plik w przeglądarce (via Drag and Drop) i powinniście widzieć efekt:

[![](http://codecouple.pl/wp-content/uploads/2017/09/asciiDoc1.png)](http://codecouple.pl/wp-content/uploads/2017/09/asciiDoc1.png)

**Uwaga!** Aktualnie plugin ma błąd związany z datą: [https://github.com/asciidoctor/asciidoctor-chrome-extension/issues/32](https://github.com/asciidoctor/asciidoctor-chrome-extension/issues/32)

### Budowanie

Naszą dokumentację można zbudować na kilka sposób. Najpopularniejszym sposobem jest zainstalowanie **Rubiego** i pobranie paczki z **AsciiDoc'iem**. Opis [tutaj](http://asciidoctor.org/docs/install-toolchain/).

W moim projekcie, korzystam z **Mavena**, dzięki temu mogłem wykorzystać specjalny plugin do budowania dokumentacji.

Korzystając z tego rozwiązania nie ma potrzeby instalowania **Rubiego**, ponieważ korzysta on z implemetancji **JRuby**.

W `pom.xml` umieszczamy następujące linijki:

<build>
    <plugins>
        <plugin>
            <groupId>org.asciidoctor</groupId>
            <artifactId>asciidoctor-maven-plugin</artifactId>
            <version>1.5.5</version>
            <executions>
                <execution>
                    <id>output-html</id>
                    <phase>generate-resources</phase>
                    <goals>
                        <goal>process-asciidoc</goal>
                    </goals>
                    <configuration>
                        <backend>html</backend>
                        <doctype>book</doctype>
                    </configuration>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>

Domyślną lokalizacją, w której powinniśmy przechowywać pliki `adoc` jest `src\main\asciidoc`. Natomiast wygenerowany plik znajdziemy w `target`. Możemy oczywiście to skonfigurować wedle uznania:

<configuration>
    <backend>html</backend>
    <doctype>book</doctype>
    <sourceDirectory>src/docs/asciidoc</sourceDirectory>
    <outputDirectory>src/docs/html</outputDirectory>
</configuration>

Resztę przydatnych konfiguracji znajdziecie tutaj: [https://github.com/asciidoctor/asciidoctor-maven-plugin](https://github.com/asciidoctor/asciidoctor-maven-plugin).

### Składnia

Składnia jest bardzo podobna do **markdown'a**, jednakże posiada dużo więcej funkcji. Poniżej podstawowe elementy:

\= To jest tytuł dokumentacji
CodeCouple.pl <codecouple@outlook.com>
v1.0, 2017-09-08
:someVariable: 1.0.0
:toc: left
:icons: font
:source-highlighter: highlightjs

Witajcie na CodeCouple.pl!

TIP: Tip! Naprawdę fajny feature.

== Sekcja

Linia plus oznacza nową linię, +
Nowa linia.

NOTE: Notatka z ikoną.

.Tytuł listy
\* Punkt
\*\* Podpunkt
\* Kolejny

Aktualna wersja aplikacji: {someVariable}.

Tutaj link link:https://codecouple.pl\[do mojego bloga\]

Tutaj link bez opisu link:https://CodeCouple.pl\[\]

== Kolejna

IMPORTANT: Coś tam jako wykrzyknik!

. Punkt
.. Podpunkt
. Kolejny

== Spring Rest Docs

Ten \*text\* jest pogrubiony.

Ten \_text\_ jest pochylony.

Ten \`text\` jest jako mono.

\[source,java\]
----
public SomeClass {
   void someMethod(String someText){  # <1>
       //Some logic here
    }
}
----
<1> Jakieś wyjaśnienie

- \[x\] Check lista 1
- \[x\] Check lista 2
- \[x\] Check lista 3
- \[ \] Nie

Teraz puszczamy `mvn clean install`.

### Wynik

[![](http://codecouple.pl/wp-content/uploads/2017/09/asciidoc2.png)](http://codecouple.pl/wp-content/uploads/2017/09/asciidoc2.png)

Bardzo dużą zaletą takiej dokumentacji jest to, że w repozytorium trzymamy tylko plik tekstowy a nie binarny. Dzięki temu mamy informację o zmianach. Kolejna zaleta to wsparcie dla **Mavena**. Można nawet przekazywać parametry z **Mavena**, co może być przydatne przy wstawianiu numeru wersji dokumentu. W dokumentacji oraz na internecie bardzo często można spotkać dwa pojęcia, **AsciiDoc** oraz **AsciiDoctor**. **AsciiDoc** jest składnią dla tworzenia dokumentacji, natomiast **AsciiDoctor** jest zbiorem narzędzi do budowania dokumentacji.

### Więcej

Polecam bardzo nagranie z **Toruńskiego JUG'a**, na którym **Kuba Marchwicki** przedstawił **AsciiDoc'a**.

https://www.youtube.com/watch?v=JGFBG22mHcs