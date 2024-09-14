---
title: '#4 Wzorce projektowe: Builder - zbudujmy to lepiej'
tags:
  - builder
  - Clean Code
  - design pattern
  - wzorce projektowe
id: '1651'
categories:
  - - Clean Code
  - - Java
  - - Wzorce projektowe
date: 2018-01-12 12:04:39
author: 'Krzysztof Chruściel'
---

![designPatternArt](http://codecouple.pl/wp-content/uploads/2017/03/designPatternArt.png)

**Builder**, czyli nasz polski **budowniczy** należy do wzorców kreacyjnych. Dzięki niemu możemy tworzyć złożone obiekty dzieląc jeden duży proces na kilka mniejszych etapów. Każdy z tych etapów może być implementowany na wiele różnych sposobów. Daje nam to możliwość tworzenia różnych reprezentacji tego samego obiektu.
<!-- more -->
### Diagram

Zacznijmy od diagramu z klasami, na przykładzie których przedstawię Wam wzorzec:

![](http://codecouple.pl/wp-content/uploads/2017/12/Untitled-Diagram.png)

### Produkt

To co nas najbardziej interesuje, czyli tworzony produkt. W naszym przypadku będzie to paczka świąteczna (`ChristmasPack`) jako, że jeszcze jesteśmy w tym świątecznym klimacie. Klasa składa się z prezentów oraz opakowania (pola `Present` oraz `Wrapping`) oraz settery do nich, które nie zostały przedstawione na diagramie, żeby nie zaciemniać rysunku.

### Builder

Kolejnym elementem wzorca jest sam **builder**. Jest to zazwyczaj interfejs lub klasa abstrakcyjna, w której mamy metody odpowiedzialne za tworzenie kolejnych części produktu. W naszym przypadku jest to interfejs `ChristmasPackBuilder` z dwoma metodami dodającymi do paczki prezenty oraz opakowanie.

### Konkretne implementacje buildera

Są to klasy implementujące opisany wyżej **builder**. Na diagramie widzimy, że są to klasy `NiceChristmasPackBuilder` oraz `NaughtyChristmasPackBuilder`. Tworząc dwie osobne klasy jesteśmy w stanie określić jakie prezenty chcemy spakować dla grzecznych dzieci, a jakie dla niegrzecznych. Klient nie musi znać parametrów, dla każdego typu paczki. Zdefiniowane są one w konkretnych implementacjach **buildera**.

### Director (zarządca)

Naszym zarządcą jest klasa `Packer`, która decyduje/zarządza według jakiej **instrukcji** ma być tworzony produkt. W metodzie `createChristmasPack()` wywoływane są metody z kolejnymi krokami pakowania paczki.

class Packer {
    private final ChristmasPackBuilder christmasPackBuilder;

    public Packer(ChristmasPackBuilder builder) {
        christmasPackBuilder = builder;
    }

    public ChristmasPack createChristmasPack() {
        christmasPackBuilder.addPresent();
        christmasPackBuilder.addWrapping();
        return christmasPackBuilder.getChristmasPack();
    }
}

### Uruchamiamy

W naszej klasie klienckiej tworzymy zarządcę (`Packer`), do którego przekazujemy konkretną implementację **buildera**, a tym samym instrukcję z odpowiednimi parametrami dla konkretnej paczki (naughty or nice).

Packer packer = new Packer(new NaughtyChristmasPackBuilder());
ChristmasPack christmasPack = packer.createChristmasPack();
System.out.println(christmasPack.toString());

packer = new Packer(new NiceChristmasPackBuilder());
christmasPack = packer.createChristmasPack();
System.out.println(christmasPack.toString());

### Podsumowanie

Nie ma co ukrywać, przykład nie jest skomplikowany, ale na takich najlepiej można zrozumieć sens **wzorca**. Wyobraźmy sobie teraz, że chcemy dodać jeszcze jeden typ paczki. Wystarczy przygotować instrukcję tworzenia obiektu z nowymi parametrami, tzn. nową implementację **buildera**. I to wszystko, potem tylko wywołujemy zarządcę przekazując w konstruktorze nowo stworzoną klasę.

Wzorzec **builder** pozwala nam całkowicie zakryć sposób tworzenia obiektów przed klientem. Otrzymuje on gotowy produkt, który w zależności od rodzaju jest tworzony w inny sposób. W naszym przykładzie zarówno tworzenie prezentu jak i opakowania wyglądało tak samo, czyli wywoływane były kolejne settery ustawiające odpowiednie wartości, ale równie dobrze możemy wykonać zupełnie inną logikę dla jednego typu paczki i inną dla drugiego.

Wzorzec builder ostatnio często mylony jest z wzorcem zwanym **Test Data Builder**, który nazywany jest również **Fluent Builder'em** lub **Appender'em**, ale o nim opowiem w kolejnym wpisie.

### GitHub

Całość znajdziecie na [GitHubie](https://github.com/apieszczek/DesignPatterns/).