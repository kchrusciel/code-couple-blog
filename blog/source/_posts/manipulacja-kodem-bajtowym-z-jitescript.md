---
title: Manipulacja kodem bajtowym z JiteScript
tags:
  - bytecode
  - java
id: '3468'
categories:
  - Java
date: 2018-12-28 12:01:05
author: 'Krzysztof Chruściel'
---

![](https://raw.githubusercontent.com/kchrusciel/code-couple-blog-assets/main/2017/02/java-logo.png)

Praca z **kodem bajtowym** zawsze uczy mnie czegoś nowego. Postanowiłem dodać ten wpis, aby zachęcić was do eksperymentów. Aktualnie kompilator oraz **JIT** (Just-In-Time Compiler) wykonują za nas całą robotę. Prowadzi to do sytuacji, w których bardzo wiele aspektów języka przyjmujemy na zasadzie "no bo tak jest". Odczarujmy trochę ten **kod bajtowy**!
<!-- more -->
### JiteScript

Na rynku istnieje kilka popularnych bibliotek do manipulacji **kodem bajtowym**. Jedną z nich jest biblioteka **JiteScript**. Patrząc na statystyki **Mavena**, projekt przestał być rozwijany około 2016 roku. Jednakże moim zdaniem nadal jest to narzędzie godne uwagi. **JiteScript** wewnętrznie wykorzystuje **ASM**, o którym wpis na pewno ukaże się w przyszłości.

### Maven

Dodajemy zależność do biblioteki **JiteScript**:

```xml
<dependency>
    <groupId>me.qmx.jitescript</groupId>
    <artifactId>jitescript</artifactId>
    <version>0.4.1</version>
</dependency>
```

### Zaczynamy

Zaczniemy od stworzenia klasy. Wykorzystamy do tego klasę `JiteClass`, która w **konstruktorze** może przyjąć nazwę klasy, nazwę klasy bazowej (po której ma dziedziczyć) oraz nazwy interfejsów, jeśli takowe implementuje:

```java
JiteClass someClass = new JiteClass("SomeClass");
```

W naszym przypadku tworzymy klasę `SomeClass`, która dziedziczy po klasie `Object`. Następnie musimy dodać domyślny konstruktor. Normalnie robi to za nas kompilator, ale w tym przypadku musimy go stworzyć wprost:

```java
someClass.defineDefaultConstructor();
```

Po dodaniu **konstruktora** pora stworzyć nową instancję tej klasy. Aby to zrobić, musimy najpierw stworzyć własny `ClassLoader`:

```java
class CustomClassLoader extends ClassLoader {
    
    public Class<?> defineClass(String name, byte[] data) {
        return super.defineClass(name, data, 0, data.length);
    }

}
```

Po utworzeniu **ClassLoadera** możemy stworzyć naszą instancję na podstawie kodu **bajtowego**:

```java
byte[] bytes = someClass.toBytes(JDKVersion.V1_8);
CustomClassLoader customClassLoader = new CustomClassLoader();
Class<?> clazz = customClassLoader.defineClass("SomeClass", bytes);
clazz.newInstance();
```

### HelloWorld

Poprzedni przykład był mało efektowny. Stworzyliśmy tam prostą klasę z domyślnym **konstruktorem**. Tym razem w konstruktorze chciałbym wypisać słynne "HelloWorld". Ponownie wykorzystujemy klasę `JiteClass`:

```java
JiteClass helloWorld = new JiteClass("HelloWorld");
```

Tym razem nie dodajemy domyślnego konstruktora, tylko sami go tworzymy. Możemy wykorzystać do tego zwykłe API i tak zwane "fluent API". W tym przykładzie przedstawię przykład "zwykłego" API:

```java
CodeBlock constructor = new CodeBlock();
constructor.aload(0); // Ładuje 'this' na stos
constructor.invokespecial(p(Object.class), "<init>", sig(void.class)); // Wywołuje konstruktor klasy bazowej (super())
constructor.getstatic(p(System.class), "out", ci(PrintStream.class)); // Ładuje System.out na stos
constructor.ldc("HelloWorld"); // Ładuje stałą "HelloWorld" na stos
constructor.invokevirtual(p(PrintStream.class), "println", sig(void.class, Object.class)); // Wywołuje System.out.println()
constructor.voidreturn(); // Koniec metody (return)
```

Zaczynamy od metody `aload(0)`, która ładuje na stos referencję do obiektu `this`. Następnie na referencji obiektu wywołujemy metodę `<init>`. Jest to nazwa **konstruktora**, ponieważ konstruktor sam w sobie nie ma nazwy. Bardzo często zapominamy, że w naszym konstruktorze pod spodem dodawane jest `super()`. Tym razem nie mamy kompilatora, więc musimy zrobić to sami. Następnie na stos ładujemy statyczne pole `System.out` oraz stałą `"HelloWorld"`. Po załadowaniu danych uruchamiamy metodę `println`, która pobiera wartości ze stosu. Na koniec musimy wywołać metodę `return`. Po stworzeniu **konstruktora** musimy dodać go do klasy `HelloWorld`:

```java
helloWorld.defineMethod("<init>", JiteClass.ACC_PUBLIC, sig(Void.TYPE), constructor);
```

Ponownie tworzymy nową instancję. Tym razem powinniśmy ujrzeć na konsoli napis "HelloWorld":

```java
byte[] bytes = helloWorld.toBytes(JDKVersion.V1_8);
CustomClassLoader customClassLoader = new CustomClassLoader();
Class<?> clazz = customClassLoader.defineClass("HelloWorld", bytes);
clazz.newInstance();
```

### Konstruktor z Parametrem

W tym przykładzie ponownie stworzymy **konstruktor**. Tym razem jednak będzie on przyjmował parametr typu `String`, który następnie zostanie wypisany. Zaczynamy od dodania klasy:

```java
JiteClass helloText = new JiteClass("HelloText");
```

Po dodaniu klasy dodajemy **konstruktor** (tym razem korzystając z fluent API):

```java
helloText.defineMethod("<init>", JiteClass.ACC_PUBLIC, sig(Void.TYPE, String.class),
        newCodeBlock()
                .aload(0)
                .invokespecial(p(Object.class), "<init>", sig(void.class))
                .getstatic(p(System.class), "out", ci(PrintStream.class))
                .aload(1) // Ładowanie pierwszego argumentu (String)
                .invokevirtual(p(PrintStream.class), "println", sig(void.class, Object.class))
                .voidreturn());
```

W metodzie `sig()` dodaliśmy parametr typu `String.class`. Tym razem nie ładowaliśmy stałej, korzystając z `ldc()`, tylko załadowaliśmy zmienną z tak zwanej **tablicy zmiennych lokalnych**. Referencja do obiektu `this` zawsze jest pod indeksem `0`, dlatego pierwszy argument metody (String) znajduje się pod indeksem `1` (`aload(1)`).

Teraz możemy wywołać nasz nowy **konstruktor**:

```java
byte[] bytes = helloText.toBytes(JDKVersion.V1_8);

CustomClassLoader customClassLoader = new CustomClassLoader();
Class<?> clazz = customClassLoader.defineClass("HelloText", bytes);
// Musimy użyć getConstructors()[...] bo konstruktor domyślny nie jest dodawany automatycznie
clazz.getConstructors()[0].newInstance("CodeCouple");
```

A na konsoli powinien pokazać się napis "CodeCouple".

### Github

Całość jak zawsze na [GitHubie](https://github.com/kchrusciel/CodeCouple/tree/master/JiteScript)