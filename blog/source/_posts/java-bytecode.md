---
title: Java - ByteCode
tags:
  - bytecode
  - java
  - jvm
id: '514'
categories:
  - - Java
  - - JVM
date: 2016-03-20 11:36:21
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

Schodzimy nisko, ale czy to coś złego? Według **IBM** developerWorks: „_Znajomość kodu bajtowego Javy pomaga programiście tak, jak znajomość asemblera pomaga programistom języków C i C++_” i ja z tym stwierdzeniem się zgadzam. W tym wpisie postaram się przybliżyć wam kod bajtowych.
<!-- more -->
### Cykl życia

Na początku zacznijmy od **przebiegu/cyklu** życia naszej aplikacji. Jako pierwszy mamy kod źródłowy, czyli kod napisany w jednym z języków, który ma zbudowany dla siebie kompilator. Następnie nasz kod źródłowy jest kompilowany do postaci **kodu bajtowego**.

kod źródłowy(java, scala, kotlin i inne języki JVM) - > kompilator (np. javac) - > kod bajtowy

Zatrzymamy się na **kodzie bajtowy,** bo o tym jest ten wpis. Czyli **kompilator** dostarcza nam kod w postaci kodu bajtów. Nie jest to jeszcze kod natywny tylko **postać pośrednia**. Dzięki temu, że generowana jest **postać pośrednia** można w łatwy sposób napisać swój własny język. Musimy "jedynie" zaprojektować gramatykę i kompilator, który generuje kod bajtowy **Javy**. Dzięki powstaniu tej **postaci pośredniej** nie martwimy się tym co jest dalej, bo to już załatwia za nas **JVM**.

### ByteCode

**Kod bajtowy** Javy to zbiór **instrukcji,** których aktualnie jest około [200 na 256 możliwych](https://en.wikipedia.org/wiki/Java_bytecode_instruction_listings) (jeden bajt to osiem bitów 2^8 = 256). Nowe **instrukcje** dodawane są bardzo rozważnie, zazwyczaj bardziej skomplikowane operacje zastępowane są szeregiem instrukcji już wbudowanych w **kod bajtowy**. Każda operacja ma długość jednego **bajta**. Przykład _hello world_ w kodzie bajtowym:

public class Main {
  public Main();
    Code:
       0: aload\_0
       1: invokespecial #1                  // Method java/lang/Object."":()V
       4: return

  public static void main(java.lang.String\[\]);
    Code:
       0: getstatic     #2                  // Field java/lang/System.out:Ljava/io/PrintStream;
       3: ldc           #3                  // String Hello World!
       5: invokevirtual #4                  // Method java/io/PrintStream.println:(Ljava/lang/String;)V
       8: return
}

### Javap

Aby samemu móc **skompilować** kod do postaci **kodu bajtowego** należy skorzystać z narzędzia **javap,** które jest dostępne w pakiecie **JDK**. Należy wskazać klasę \*.java (w Intellij, normalnie należy wskazać plik .class) i uruchomić **javap**. Fajnym rozwiązaniem w **Intellij** jest dodanie **External Tool**.

[![javap](http://codecouple.pl/wp-content/uploads/2016/03/javap.png)](http://codecouple.pl/wp-content/uploads/2016/03/javap.png) Dzięki temu możemy od razu podejrzeć sobie wynik w konsoli: [![javapResult](http://codecouple.pl/wp-content/uploads/2016/03/javapResult.png)](http://codecouple.pl/wp-content/uploads/2016/03/javapResult.png)

Od razu nasuwa się pytanie czy jest to rozwiązanie bezpiecznie, niestety nie. Można wziąć kod i zmienić dowolną instrukcję. Do czego można wykorzystać wiedzę o kodzie bajtowy? Możemy podejrzeć jak wykonywane są operacje "**od środka**".

### StringBuilder

Na przykład **kompilator** ma wbudowaną zmianę **Stringów** na **StringBuildery,** które są bardziej optymalne w operacji **konkatenacji**:

        String concatenation = "empty";
        concatenation+="not empty";
        concatenation+="not empty";
        concatenation+="not empty";
        concatenation+="not empty";
        concatenation+="not empty";

Wynik:

      8: ldc           #7                  // String empty
      10: astore\_1
      11: new           #8                  // class java/lang/StringBuilder
      14: dup
      15: invokespecial #9                  // Method java/lang/StringBuilder."":()V
      18: aload\_1
      19: invokevirtual #10                 // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
      22: ldc           #11                 // String not empty
      24: invokevirtual #10                 // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
      27: invokevirtual #12                 // Method java/lang/StringBuilder.toString:()Ljava/lang/String;