---
title: IntelliJ IDEA - poprawa wydajności pracy
tags:
  - Clean Code
  - IDE
  - Intellij Idea
id: '174'
categories:
  - - Clean Code
date: 2016-02-23 18:56:23
author: 'Krzysztof Chruściel'
---

**IDE** (ang. _Integrated Development Environment_) - czyli zintegrowane środowisko programistyczne. Jest to aplikacja, która służy do tworzenia, modyfikowania i testowania kodu. Chodź **IntelliJ IDEA** nie znalazł się na liście najbardziej popularnych **IDE** na [stackoverflow](http://stackoverflow.com/research/developer-survey-2015#tech-editor), jest on coraz częściej wykorzystywanym środowiskiem developerskim. Jeśli zdecydowaliśmy się na korzystanie z tego **IDE**, warto poświęcić niewiele czasu, aby usprawnić swoją prace w **IntelliJ IDEA**.
<!-- more -->
**1\. Pluginy** Istnieje wiele pluginów, które usprawniają pracę z **IntelliJ IDEA**. Wszystkie pluginy dostępne są w aplikacji **settings -> plugins -> browse repository**. Wybieramy interesujący nas dodatek, a następnie go instalujemy. Po instalacji należy zrestartować **IDE,** a następnie można korzystać z nowego pluginu. Pluginy polecane przeze mnie to:

*   **Key promoter** - przypominanie nazwy skrótów
*   **Ace Jump** - usprawnia poruszanie się po kodzie
*   **Atlassian Connector for IntelliJ IDE** - wtyczka do integracji z produktami Atlassian

**1.1** **Key promoter** jest pluginem, który przypomina nazwy skrótów. Robi to w sposób dyskretny, dzięki czemu nie przeszkadza w codziennej pracy. [![keypromoter](http://codecouple.pl/wp-content/uploads/2016/02/keypromoter.png)](http://codecouple.pl/wp-content/uploads/2016/02/keypromoter.png) **1.2** **Ace Jump** jest kolejnym proponowanym przeze mnie dodatkiem. Usprawnia on poruszanie się po kodzie. Usprawnienie polega na tym, że wybieramy fragment kodu, do którego chcemy przenieść kursor. Aby wybrać to miejsce naciskamy **ctrl + ;**. Pojawi nam się pole do wpisywania. Umieszczamy tam znak, od którego zaczyna się miejsce, do którego chcemy się przenieść. [![acejump](http://codecouple.pl/wp-content/uploads/2016/02/acejump.png)](http://codecouple.pl/wp-content/uploads/2016/02/acejump.png) Po wybraniu odpowiedniej litery, w moim przypadku jest to "t", pojawiają się litery we wszystkich miejscach, w których występuje znak "t". Następnie wpisujemy odpowiedni znak, który nas interesuje i nasz kursor zostaje przeniesiony w to miejsce. [![acejump2](http://codecouple.pl/wp-content/uploads/2016/02/acejump2.png)](http://codecouple.pl/wp-content/uploads/2016/02/acejump2.png) **2\. Skróty** Jak najmniej korzystaj z myszki! Ta myśl przewodnia powinna Ci towarzyszyć przez cały czas, gdy tworzysz kod w swoim **IDE**. Aby jak najbardziej ograniczyć pracę z myszką należy skorzystać ze skrótów. Istnieje wiele skrótów, które można podejrzeć w ustawieniach **(ctrl + alt + s) -> keymap**. [![shortcut](http://codecouple.pl/wp-content/uploads/2016/02/shortcut.jpg)](http://codecouple.pl/wp-content/uploads/2016/02/shortcut.jpg) Najbardziej użyteczne skróty dla mnie:

*   ctrl + w - zaznaczanie obszaru, postaw kursor na zmiennej, a następnie naciśnij ctrl+w, masz teraz zaznaczoną całą zmienną. Kolejne kliknięcia spowoduję zaznaczenie większego obszaru. Zaznaczanie obszaru jest inteligentne i zaznacza coraz większy obszar zgodnie z budową kodu,
*   ctrl + y - usuwa linie,
*   ctrl + / - dodaje/usuwa komentarz,
*   ctrl + alt + s - ustawienia,
*   shift + F10 - uruchomienie kodu,
*   shift + F9 - uruchomienie debugowania,
*   shift + F6 - rename - zmiana nazwy,
*   ctrl + alt + m - extract method - pomocne przy refactoringu,
*   ctrl + shift + j - usuwa zbędne linie,
*   ctrl + d - powielenie linii,
*   ctrl + F11 - dodanie bookmarka.

Użytecznych skrótów jest wiele więcej, dokładniejszy opis znajdziecie w artykule o **PyCharm,** który już niebawem pojawi się na naszej stronie. Z racji, iż **PyCharm** jest produktem bazującym na **IntelliJ**, skróty są takie same. **3\. Usprawnienia** **3.1 Live Template** jest mechanizmem, który przyspiesza pisanie kodu. Definiujemy kod, który ma zostać wygenerowany automatycznie, gdy wpiszemy słowo kluczowe, a następnie jeden ze zdefiniowanych klawiszy (zazwyczaj tabulator) [![liveTemplate](http://codecouple.pl/wp-content/uploads/2016/02/liveTemplate.jpg)](http://codecouple.pl/wp-content/uploads/2016/02/liveTemplate.jpg) W polu **Abbreviation** ustawiamy skrót, który będzie odpowiadał naszemu generatorowi.  Następnie w **Template text** ustawiamy treść, która ma się generować. Jeśli chcemy określić ustawienie kursora po wygenerowaniu kodu dodajemy znacznik **$END$**. W menu **options** wybieramy po jakim znaku ma generować się kod (domyślnie tabulator). Na końcu musimy ustalić jakiego języka ma to dotyczyć, ustawiamy to na dole (**applicable**). Po pomyślnym ustawieniu wystarczy kliknąć **apply,** aby zatwierdzić zmiany i możemy teraz korzystać z naszego generatora! **3.2** **Bookmarks**, czyli ustawienie miejsca, do którego się często odwołujemy. Aby dodać punkt, do którego będziemy się odwoływać wystarczy ustawić kursor na interesującej nas linii, następnie wciskamy **crtl + F11** i wybieramy numer od 0-9 lub literę od A-Z, która będzie przypisana do tego miejsca. [![bookmark](http://codecouple.pl/wp-content/uploads/2016/02/bookmark.png)](http://codecouple.pl/wp-content/uploads/2016/02/bookmark.png) Następnie wystarczy nacisnąć **ctrl + odpowiednio\_przydzielony\_symbol** i przeniosła nas do naszego zadeklarowanego miejsca. Jest to bardzo użyteczne gdy często odwołujemy się do jednego miejsca. **4\. VCS** Kolejnym usprawnieniem w **IntelliJ IDEA** jest współpraca z systemami kontroli wersji ([VCS](http://codecouple.pl/2016/02/05/system-kontroli-wersji-opis-oraz-definicje/)). Należy wejść w ustawienia (ctrl + alt + s), a następnie w zakładkę Version Control. [![vcs](http://codecouple.pl/wp-content/uploads/2016/02/vcs.jpg)](http://codecouple.pl/wp-content/uploads/2016/02/vcs.jpg) Ukaże nam się lista najbardziej popularnych dystrybucji **VCS'ów.** Wybieramy wykorzystywany przez nas system i odpowiednio konfigurujemy. Po pomyślnym ustawieniu możemy wykonywać szereg operacji na naszym projekcie ![vcs2](http://codecouple.pl/wp-content/uploads/2016/02/vcs2.png) To tylko najważniejsze usprawnienia dla mnie, w przyszłości postaram się napisać bardziej obszerny artykuł **Tips and Tricks** dla **IntelliJ Idea**.