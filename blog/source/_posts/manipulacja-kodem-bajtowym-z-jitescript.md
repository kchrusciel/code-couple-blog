---
title: Manipulacja kodem bajtowym z JiteScript
tags:
  - bytecode
  - java
id: '3468'
categories:
  - - Java
date: 2018-12-28 12:01:05
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

W moim przypadku praca z **kodem bajtowym** zawsze uczy mnie czegoś nowego. Postanowiłem dodać ten wpis, aby zachęcić was do eksperymentów. Aktualnie kompilator oraz **JIT** wykonuje za nas całą robotę. Prowadzi to do sytuacji, w których bardzo wiele aspektów języka przyjmujemy na zasadzie "no bo tak jest". Odczarujmy trochę ten **kod bajtowy**!
<!-- more -->
### JiteScript

Na rynku istnieje kilka popularnych bibliotek do manipulacji **kodem bajtowym**. Jedną z nich jest biblioteka **JiteScript**. Patrząc na statystyki **Maven'a** projekt przestał być rozwijany koło 2016 roku. Jednakże moim zdaniem nadal jest to narzędzie godne uwagi. **JiteScript** pod spodem wykorzystuje **ASM**, o którym wpis na pewno ukaże się w przyszłości.

### Maven

Dodajemy zależności do bibloteki **JiteScript**:

<dependency>
    <groupId>me.qmx.jitescript</groupId>
    <artifactId>jitescript</artifactId>
    <version>0.4.1</version>
</dependency>

### Zaczynamy

Zaczniemy od stworzenia klasy. Wykorzystamy do tego klasę `JiteClass`, która w **konstruktorze** może przyjąć informację o nazwie klasy, nazwie klasy po której ma dziedziczyć oraz nazwach interfejsów jeśli takowe implementuje:

JiteClass someClass = new JiteClass("SomeClass");

W naszym przypadku tworzymy klasę `SomeClass`, która dziedziczy po klasie `Object`. Następnie musimy dodać domyślny konstruktor. Normalnie robi to za nas kompilator, ale w tym przypadku to my musimy stworzyć go wprost:

someClass.defineDefaultConstructor();

Po dodaniu **konstruktora** pora stworzyć nową instancję tej klasy. Aby to zrobić musimy najpierw stworzyć własny `ClassLoader`:

class CustomClassLoader extends ClassLoader {
    
    public Class<?> defineClass(String name, byte\[\] data) {
        return super.defineClass(name, data, 0, data.length);
    }

}

Po utworzeniu **ClassLoader'a**, możemy stworzyć naszą instancję na podstawie kodu **bajtowego**:

byte\[\] bytes = someClass.toBytes(JDKVersion.V1\_8);
CustomClassLoader customClassLoader = new CustomClassLoader();
Class<?> clazz = customClassLoader.defineClass("SomeClass", bytes);
clazz.newInstance();

### HelloWorld

Poprzedni przykład był mało efektowny. Stworzyliśmy tam prostą klasę z domyślnym **konstruktorem**. Tym razem w konstruktorze chciałbym wypisać słynne `HelloWorld`. Ponownie wykorzystujemy klasę `JiteClass`:

JiteClass helloWorld = new JiteClass("HelloWorld");

Tym razem nie dodajemy domyślnego konstruktora tylko sami go tworzymy. Możemy wykorzystać do tego zwykłe API i tak zwane fluent API. W tym przykładzie przedstawię przykład "zwykłego" API:

CodeBlock constructor = new CodeBlock();
constructor.aload(0);
constructor.invokespecial(p(Object.class), "<init>", sig(void.class));
constructor.getstatic(p(System.class), "out", ci(PrintStream.class));
constructor.ldc("HelloWorld");
constructor.invokevirtual(p(PrintStream.class), "println", sig(void.class, Object.class));
constructor.voidreturn();

Zaczynamy od metody `aload(0)`. Ładuje ona na stos referencje do obiektu `this`. Następnie na referencji obiektu wywołujemy metodę `<init>`. Jest to nazwa konstruktora, ponieważ konstruktor sam w sobie nie ma nazwy. Bardzo często zapominamy o tym, iż w naszym konstruktorze pod spodem dodawane jest `super()`. Tym razem nie mamy kompilatora, więc musimy zrobić to sami. Następnie na stos ładujemy statyczne pole `System.out` oraz stałą `"HelloWorld"`. Po załadowaniu danych na stosie uruchamiamy metodę `println`, która pobiera wartości ze stosu. Na koniec musimy wywołać metodę `return`. Po stworzeniu **konstruktora** musimy dodać go do klasy `HelloWorld`:

helloWorld.defineMethod("<init>", JiteClass.ACC\_PUBLIC, sig(Void.TYPE), constructor);

Ponownie tworzymy nową instancję, tym razem powinniśmy ujrzeć na konsoli napis `HelloWorld`:

byte\[\] bytes = helloWorld.toBytes(JDKVersion.V1\_8);

CustomClassLoader customClassLoader = new CustomClassLoader();
Class<?> clazz = customClassLoader.defineClass("HelloWorld", bytes);
clazz.newInstance();

### Konstruktor z parametrem

W tym przykładzie ponownie stworzymy **konstruktor**. Tym razem jednak będzie on przyjmował parametr typu `String`, który następnie zostanie wypisany. Zaczynamy od dodania klasy:

JiteClass helloText = new JiteClass("HelloText");

Po dodaniu klasy dodajemy **konstruktor** (tym razem korzystając z fluent API):

helloText.defineMethod("<init>", JiteClass.ACC\_PUBLIC, sig(Void.TYPE, String.class),
        newCodeBlock()
                .aload(0)
                .invokespecial(p(Object.class), "<init>", sig(void.class))
                .getstatic(p(System.class), "out", ci(PrintStream.class))
                .aload(1)
                .invokevirtual(p(PrintStream.class), "println", sig(void.class, Object.class))
                .voidreturn());

W metodzie `sig()` dodaliśmy parametr typu `String.class`. Tym razem nie ładowaliśmy stałej korzystając z `ldc()`, tylko załadowaliśmy zmienną z tak zwanej **tablicy zmiennych lokalnych**. Teraz możemy wywołać nasz nowy **konstruktor**:

byte\[\] bytes = helloText.toBytes(JDKVersion.V1\_8);

CustomClassLoader customClassLoader = new CustomClassLoader();
Class<?> clazz = customClassLoader.defineClass("HelloText", bytes);
clazz.newInstance();
clazz.getConstructors()\[1\].newInstance("CodeCouple");

A na konsoli powinien pokazać się napis `CodeCouple`.

### Github

Całość jak zawsze na [Github'ie](https://github.com/kchrusciel/CodeCouple/tree/master/JiteScript).