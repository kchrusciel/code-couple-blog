---
title: '#3 Wzorce projektowe: Wstrzykiwanie zależności'
tags:
  - dependency injection
  - design pattern
  - IoC
id: '2525'
categories:
  - - Wzorce projektowe
date: 2017-12-29 12:02:32
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/03/designPatternArt.png)

Bardzo ciekawy wzorzec, który w środowisku **Javowym** wydaje się normalnością. **Wstrzykiwanie zależności** (ang. _Dependency Injection_) jest to wzorzec, którego stosowanie spowoduje, iż nasz kod stanie się mniej związany z innymi elementami, a tym samym będzie bardziej otwarty na rozszerzenia. Oczywiście w tematyce **DI** pojawić musi się również pojęcie **odwróconej kontroli** (ang. _Inversion of Control_). Zapraszamy!
<!-- more -->
### Inversion of Control

Pojęcie **odwróconej kontroli**, jest pojęciem najbardziej ogólnym. Przedstawia ono koncepcje, w której jakiś byt odpowiedzialny jest za tworzenie zależności, a nie jak do tej pory programista. Dlatego odwrócona kontrola, bo to jakiś byt przejmuje kontrole. Z jednej strony brzmi to niepokojąco, ponieważ tracimy kontrolę, jednakże z drugiej strony skupiamy się tylko na dostarczaniu wartości biznesowych (co powinno być głównym elementem programowania).

### Dependency Injection

**Wstrzykiwanie zależności** jest jednym ze sposobów realizacji **IoC** (mogą być to także **eventy**, czy **programowanie aspektowe**). W podejściu tym, obiekt nie tworzy obiektów, które wykorzystywane są wewnątrz. Dzięki temu, nie wiążemy się z konkretną implementacją (najlepiej operować na interfejsach), a także nie musimy znać parametrów konstruowanego obiektu. Operując na interfejsach stajemy się niezależni od konkretnej implementacji, a nasz kod zaczyna realizować **Open/Closed principle**. W podejściu bez stosowania odwróconej kontroli nasz kod wygląda następująco:

class Car {
    //Concrete class
    private WinterTire tire = new WinterTire(195);

    void drive() {
        tire.turn();
    }

}

Obiekt główny, czyli `Car`, odpowiedzialny jest za stworzenie obiektu, który wykorzystywany jest wewnątrz (klasa `WinterTire`). Ponadto musi znać jego parametry (wartość `195`) w momencie tworzenia. Wyobraźmy sobie teraz sytuację, w której chcemy stworzyć samochód z innymi oponami, musimy stworzyć nową klasę `Car` (na przykład `CarWithSummerTire`) i w niej tworzymy konkretną implementację. Natomiast po zastosowaniu **odwróconej kontroli**:

class Car {

    private Tire tire;

    Car(Tire tire) {
        this.tire = tire;
    }

    void drive() {
        tire.turn();
    }

}

W drugim fragmencie kodu zastosowaliśmy **wstrzykiwanie przez konstruktor** (o rodzajach wstrzykiwania niebawem na blogu). Teraz wyobraźmy sobie, że testujemy nasz kod. W bardzo prosty sposób w klasie testowej możemy wstrzyknąć implementację interfejsu `Tire`, która będzie działać jak **zaślepka** rzeczywistej klasy. Ponadto, jeśli zdecydujemy się dodać nową implementację interfejsu `Tire` nasza główna klasa nie ulegnie zmianie co oznacza, że nie jesteśmy związani z konkretną implementacją, a o to nam chodziło. Także została zastosowana **odwrócona kontrola**, ponieważ to nie my tworzymy obiekt typu `Tire`.

### Spring

Tak jak pisałem powyżej, **Inversion of Control** jest pojęciem ogólnym, **Dependency Injection** jest jednym ze sposobów realizacji **IoC**, natomiast samą implementację tego wzorca realizuje między innymi **Spring**. Oferuje on własny **kontener** do **wstrzykiwania zależności**, który odpowiedzialny jest za tworzenie i używanie **beanów**. W podejściu bez kontenera **IoC** sami w jakimś miejscu musimy użyć słówka `new`, czyli stworzyć instancję obiektu. Stosując **Spring'a**, wystarczy wskazać klasę **POJO** oraz **konfigurację** dla niej, a resztą zajmie się **kontener** (więcej o **Spring'u** w serii **Spring Basics**).