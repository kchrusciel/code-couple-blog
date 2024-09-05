---
title: '#Kata - IntelliJ + macOS/Windows + Shortcuts'
tags:
  - Intellij Idea
  - kata
  - shortcuts
id: '3236'
categories:
  - - Kata
date: 2018-10-26 20:34:19
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/08/katas.png)

Zmiana systemu operacyjnego może okazać się początkowo bolesnym doświadczeniem. Ostatnimy czasy zmieniłem system operacyjny z Windows na macOS, a to wiąże się to ze zmianą nawyków (w tym skrótów). Od zawsze uważam, iż znajomość skrótów narzędzi, z których korzystamy na co dzień jest pozycją obowiązkową. Aby móc nadal w efektywny sposób wykorzystywać IDE przygotowałem kata ze skrótami.
<!-- more -->
### Kata

Poniżej znajduje się lista poleceń, które należy wykonać (na dole jest link do **GitHuba,** gdzie znajdują się dwie wersje z i bez podpowiedzi):

*   Create new project (Maven will be ok)
*   Right now you can use only keyboard
*   Create new class "Dojo" with psvm
*   Add sout with "message" message
*   Duplicate five times line created before
*   Change last "message" to "last"
*   Move the last line to the top
*   Extract "message" to const
*   Move cursor on the beginning and end
*   Move cursor between whitespaces
*   Extract one of "message" line to other method
*   Add JUnit dependency
*   Create the test for this class
*   Show all tests for this class
*   Copy and paste the code below to DojoTest class:

@Test
public void dojoTest() {
    assertEquals("First", dojoMethod(1));
    assertEquals("Second", dojoMethod(2));
    assertEquals("Other", dojoMethod(3));
}

private String dojoMethod(int value) {
    if (value == 1) {
        return "First";
    } else if (value == 2) {
        return "Second";
    }
    return "Other";
}

*   Run tests for a first time
*   Run tests for a second time
*   Add a breakpoint on first and second assertion and line with "Other"
*   Go to assertEquals definition
*   On assertEquals definition show usages
*   Run tests on debug
*   Go inside
*   Step over
*   Switch to another breakpoint
*   Evaluate "dojoMethod(2)"
*   Switch to another breakpoint
*   Increase font size
*   Close active test editor
*   Find "message" in Dojo class file
*   Find "Second" in the path
*   Show Dojo class hierarchy
*   Copy and paste the code below to Dojo class:

private String dojoSurround(int value) {
    return "Message";
}

*   Surround return statement with if/else
*   Go to line number 20 in DojoTest class
*   Make the shrink selection for a few times
*   Back to previous file cursor position
*   Go to **settings**
*   Change **theme**
*   Go to project **settings** and change the project name
*   Enter the presentation mode
*   Exit presentation mode
*   Open **project** view
*   Open **structure** view
*   Make full screen on active editor
*   Switch recent files
*   Switch card tabs
*   Go to settings
*   Change theme once again

### Jak ćwiczyć?

Najlepiej jest powtarzać raz lub dwa razy dziennie powyższe ćwiczenia, aby osiągnać płynność. Gdy podstawowy zestaw nie będzie sprawiał nam już problemów możemy dopisać swoje kolejne pozycje ;)

### KeyPromoter X

[Pisałem już o tym dodatku do IntelliJ jakiś czas temu](http://codecouple.pl/2016/02/23/intellij-idea-poprawa-wydajnosci-pracy/). Przy nauce skrótów warto go zainstalować.

### Github

[Tutaj znajdziecie link do GitHuba](https://github.com/kchrusciel/Katas/tree/master/IntelliJ), gdzie umieszczone są dwie wersje katy - z podpowiedziami i bez.