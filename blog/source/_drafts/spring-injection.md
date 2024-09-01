---
title: '#1 Spring Basic - Różne typy wstrzykiwania w Springu'
tags: []
id: '2418'
categories:
  - - Spring
---

![](https://acntech.no/content/images/2016/10/logo-spring-103x60.png)

W dzisiejszym wpisie po raz kolejny nawiążemy do wzorca zwanego **wstrzykiwaniem zależności**, który został dokładnie wyjaśniony we wpisie [#3 Wzorce projektowe: Wstrzykiwanie zależności](http://codecouple.pl/2017/12/29/3-wzorce-projektowe-wstrzykiwanie-zaleznosci/). **Spring**, dostarcza własny kontener **DI**, który wykorzystywany jest do reliacji tego **wzorca**. Istnieje kilka sposób **wstrzykiwania zależności**, dziś postaramy się je wam przybliżyć, zapraszamy!
<!-- more -->
Aby móc korzystać z kontenera wstrzykiwania zależności dostarczonego przez **Spring'a** musi stworzyć konfigurację, w której określimy jak tworzone mają być **beany**. Konfigurację w **Springu** możemy tworzyć na dwa sposoby:

*   przez **XML**
*   przez **adnotacje**

### Maven

aaa

<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context</artifactId>
    <version>4.3.4.RELEASE</version>
</dependency>

### Konfiguracja poprzez XML

W pierwszych wersjach Spring'a do konfiguracji beanów wykorzystywany był głównie format XML. Aktualnie, konfiguracja w takiej formie trafia się tylko w starszych projektach. Istenieje kilka słów kluczowych, które należy zdefiniować w XML:

\[snippet\]

### Konfiguracja poprzez adnotacje

Najpopularniejszym sposobem tworzenia konfiguracji w **Spring'u** są **adnotacje**.

\[snippet\]

### Wstrzykiwanie przez konstruktor

Pierwszym sposobem wstrzykiwania zależności jest wstrzykiwanie przez konstruktor.

\[snippet\]

### Wstrzykiwanie przez pola/settery

Kolejny sposób wstrzykiwania zależności wykorzystuje settery.

\[snipper\]

### Testujemy!

Aby przetestować nasz kontener DI w działaniu dodajemy dwa testy. Pierwszy z nich korzysta z obiektu `ClassPathXmlApplicationContext` w którym wskazujemy ścieżkę do przygotowanego przez nas pliku **XML**. Drugi korzysta z obiektu `AnnotationConfigApplicationContext`, jako parametr konstruktora podajemy naszą klasę z konfiguracją.

### Dobre praktyki

Najlepszą praktyką stosowaną w **Dependency Injection** jest wstrzykiwanie poprzez konstruktor, ponieważ ułatwia to testowanie jednostkowe. Jeśli w naszych testach potrzebujmy zamocokować zachowanie klasy, którą wstrzykujemy, możemy to zrobić bardzo łatwy sposób. Ponadto, jeśli kiedyś zdecydujemy się zrezygnować ze Spring'a, będziemy musieli jedynie stworzyć gdzieś, zdefiniowane w konfiguracji klasy z użyciem słówka new.

### GitHub

Całość jak zawsze na GitHub'ie.