---
title: PyCharm
tags:
  - Clean Code
  - IDE
  - PEP8
  - PyCharm
  - python
id: '183'
categories:
  - - Clean Code
  - - Python
date: 2016-02-28 18:29:07
author: 'Krzysztof Chruściel'
---

Mam dla was kolejną dawkę JetBrains'owych **IDE**. Ten wpis będzie dotyczył **PyCharm'a**, który jest dedykowany dla **Pythona**. O IntelliJ IDEA możecie przeczytać w [artykule Krzyśka](http://codecouple.pl/2016/02/23/intellij-idea-poprawa-wydajnosci-pracy/). Przygotowałam dla Was krótki opis samego **IDE** oraz zestawienie ciekawych skrótów, które warto zapamiętać, żeby ułatwić sobie życie i przyspieszyć pisanie kodu.
<!-- more -->
Zaczynając pracę z **PyCharm'em** pojawia się okno ze wskazówkami (_**Help -> Tip of the day**_), które ułatwiają pracę. Domyślnie zaznaczone jest, że wskazówki pojawiają się przy każdym uruchomieniu **IDE**. Jest to ciekawy dodatek, dzięki któremu możemy się dowiedzieć jak jeszcze lepiej wykorzystać nasze środowisko. **1\. PEP8 w PyCharm** **PyCharm** sprawdza, czy kod pisany jest według konwencji **PEP8** (więcej o **PEP8** [TUTAJ](http://codecouple.pl/2016/02/16/pep8-2/)). Wyłapywane są między innymi takie błędy jak zbędne puste linie, spacje i tabulatory, złe nazewnictwo klas, metod, zmiennych. Miejsce, w którym znaleziony jest błąd jest zaznaczane w kodzie oraz na pasku nawigacji, gdzie możemy po rozwinięciu zobaczyć dokładny opis. ![pyCharm1](http://codecouple.pl/wp-content/uploads/2016/02/pyCharm1.jpg) Domyślnie błędy związane z **PEP8** są ustawione jako _Weak Warning._ W kodzie zaznaczane jest to poprzez podkreślenie miejsca, w którym znaleziony jest błąd. Jeśli konwencja **PEP8** jest dla nas wyjątkowo ważna możemy zmienić w ustawieniach wagę tego typu błędów. _**Settings (CTRL + ALT + S) -> Inspections.**_ W pasku wyszukiwania wpisujemy "pep8" i powinny pojawić nam się dwie pozycje. Jedna dotyczy stylu kodowania, a druga konwencji nazewnictwa. Wybieramy je i zmieniamy _**Severity**_ z _Weak Warning_ na _Warning_. ![pyCharm2](http://codecouple.pl/wp-content/uploads/2016/02/pyCharm2.jpg) Teraz błędy oprócz podkreślenia będą się zaznaczały na żółto jak na screenie poniżej. Jest to bardziej widoczne niż samo podkreślenie. ![pyCharm3](http://codecouple.pl/wp-content/uploads/2016/02/pyCharm3.jpg) **2\. Skróty, które warto znać**

*   CTRL + ALT + S - ustawienia
*   CTRL + ALT + L - autoformatowanie kodu
*   CTRL + ALT + O - autoformatowanie importów, czyli ich pogrupowanie i poukładanie alfabetycznie oraz usunięcie nieużywanych
*   CTRL + ALT + T - surround with, czyli otoczenie wybranego fragmentu kodu blokiem np. _**if, while, try-catch, comment**_
*   CTRL + SPACE - podpowiedzi słów kluczowych, metod, nazw zmiennych itp.
*   CTRL + W - zaznaczanie kolejnych sekcji kodu (np. zmienna -> wyrażenie -> cała linia -> metoda...)
*   CTRL + Y - usunięcie linii, w której znajduje się kursor
*   CRTL + D - skopiowanie linii, w której znajduje się kursor
*   CTRL + P - podpowiedź parametrów
*   CTRL + / - zakomentowanie linii kodu
*   SHIFT + F10 - Run
*   SHIFT + F9 - Debug
*   F7 - Step Into
*   SHIFT + F6 - zmiana nazwy pliku
*   ALT + INSERT - dodanie nowego źródła

To tylko kilka według mnie ważniejszych skrótów, całe mnóstwo innych znaleźć możecie w ustawieniach (**CTRL + ALT + S -> Keymap**). Należy pamiętać, że skróty te są skrótami domyślnymi. Wszystkie można edytować dla własnych potrzeb  (**Ustawienia -> Wybór skrótu + Enter**). Dobrze jest mieć zainstalowaną jedną z wtyczek:

*   **Key Promoter** (więcej [TUTAJ](http://codecouple.pl/2016/02/23/intellij-idea-poprawa-wydajnosci-pracy/))
*   **Presentation Assistant** 

**Presentation Assistant** w przeciwieństwie do **Key Promoter**, przypomina skróty nawet jeśli wpisujemy je z klawiatury. Dzięki temu skróty utrwalają się bardziej w pamięci i przy programowaniu w parach lub na prezentacji, nie musimy tłumaczyć w jaki sposób uzyskaliśmy daną funkcjonalność, ponieważ komunikat wyświetla się na dole ekranu. ![pyCharm4](http://codecouple.pl/wp-content/uploads/2016/02/pyCharm4.jpg)