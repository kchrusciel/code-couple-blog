---
title: Java 15 - JEP 360 Sealed Classes
tags:
  - java
  - java 15
  - JEP 360
  - sealed
id: '4338'
categories:
  - Java
date: 2020-09-25 12:00:00
author: 'Krzysztof Chruściel'
---

![](https://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

15\. sierpnia została wydana nowa wersja **Javy**, okraszona numerem **15**. Wraz z pojawieniem się kolejnej **wersji** dostaniemy **pakiet** kilku nowych usprawnień i funkcjonalności. Jedną z nich (w trybie **preview**) są "zapieczętowane" klasy czy **JEP 360 Sealed Classes**. Zapraszam do wpisu, aby dowiedzieć się jakie problemy próbuje rozwiązać **JEP 360**.
<!-- more -->
### JEP 360

**JEP 360** jest nową funkcjonalnością wprowadzoną w trybie **preview**. Dostarcza ona możliwość **ograniczenia** dziedziczenia jak i implementowania naszych interfejsów. Dzięki niej możemy w lepszy sposób przygotować **hierarchię** klas w modułach. Ponadto funkcjonalność ta bardzo dobrze współpracuje z kolejnymi nadchodzącymi dodatkami jak **Records** czy **Pattern Matching** ze **switch expression**.

#### Hierarchia

Głównym powodem, dla którego został zaproponowany **JEP 360** jest lepsza **organizacja** hierarchii klas na poziomie **modułu**. Do tej pory jeśli chcieliśmy sprawić, aby nikt nie mógł **dziedziczyć** po naszej klasie korzystaliśmy ze słowa kluczowego `final`:

```java
public final class Player {
}

class ExtendsPlayer extends Player {
  //compilation error
  //cannot inherit from final
}
```

Jednakże korzystając z dobrodziejstw **OOP** chcemy wykorzystać **dziedziczenie** na przykład, aby wskazać innym dostępne egzemplarze klasy `Player` lub **podziedziczyć** cechy po rodzicach:

```java
public class Player {
}

class Mp3Player extends Player {
}

class Mp4Player extends Player {
}
```

No dobra, ale **Java** do tej pory pozwalała wszystkim **dziedziczyć** po mojej klasie co mogło prowadzić do takiej nieoczekiwanej sytuacji:

```java
public class Player {
}

class Mp3Player extends Player {
}

class Mp4Player extends Player {
}

class SpanishInquisition extends Player {
}
```

Niestety, klasa **domenowa** odpowiedzialna za odtwarzanie muzyki, może być "dowolnym" odtwarzaczem (implementacja `SpanishInquisition`). Ponadto użytkownicy naszego **API** dostają jasny sygnał, że **hierarchia** klas może być niespójna **domenowo**. Rozwiązaniem tego problemu jest **JEP 360**. Od teraz na poziomie implementacji (jako autorzy klasy lub interfejsu) możemy określić kto jest uprawniony do dziedziczenia po naszej klasie. Realizujemy to za pomocą nowych słów **kluczowych**:

*   `sealed`
*   `non-sealed`
*   `permits`

#### Intencje

Kolejny powodem wprowadzenia **JEP 360** jest przekazanie **intencji**. Pamiętacie jeszcze te czasy, kiedy dowiadywaliśmy się na konferencjach, że kod powinno pisać się jak **prozę**? Jak przekazać innym: "_Słuchajcie, po tej klasie mogą dziedziczyć tylko określone klasy_"?. Z wykorzystaniem nowych słów kluczowych oprócz poprawnego zamodelowania **hierarchii** klas, możemy także (jako autorzy) przekazać nasze intencje i przeznaczenie klasy (oczywiście możemy to zrobić za pomocą **JavaDoc'a**, no ale tutaj mamy dodatkowo **compilation check**).

#### Pattern Matching

Ostatnim istotnym powodem wprowadzenia tej funkcjonalności jest **Pattern Matching**. Po "zapieczętowaniu" naszej klasy, mówimy wprost kompilatorowi i **JVM**, że tylko dane klasy mogą dziedziczyć po klasie bazowej. Dzięki tej informacji, można wprowadzać kolejne funkcjonalności. Skoro wiemy jakie klasy mogą dziedziczyć po klasie bazowej to jednocześnie wiemy też, że należą one do jednego **skończonego** zbioru. Prowadzi nas to do kolejnego pojęcia jakim jest **Algebric Data Type**. Nie będę rozwijał tego tematu bardzo dogłębnie, jednakże wiedza o skończonym zbiorze pozwoli nam na usprawnienia w kodzie. Przykłady połączenia **JEP 360** i **Pattern Matching** znajdują się poniżej.

### Enable preview

Standardowo, aby uruchomić wszystkie **preview feature** musimy dodać dodatkowy **przełącznik**. Można to zrobić za pomocą **Maven'a**:

```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-compiler-plugin</artifactId>
      <version>3.8.0</version>
      <configuration>
        <release>15</release>
        <compilerArgs>
          --enable-preview
        </compilerArgs>
      </configuration>
    </plugin>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-surefire-plugin</artifactId>
      <version>3.0.0-M3</version>
      <configuration>
        <argLine>--enable-preview</argLine>
      </configuration>
    </plugin>
  </plugins>
</build>
```

### Kodzik

Poniżej znajduje się kilka przykładów jak poradzić sobie z **JEP 360**. Pamiętajcie, że aby móc zacząć **korzystać** z tej funkcjonalności musicie mieć najnowszą **Javę** w wersji **15**.

#### Sealed

Słowa kluczowego `sealed` można używać tylko na **klasach** i **interfejsach**. Po dodaniu słowa `sealed` do klasy pojawia się błąd:

```java
public sealed class Player {
    //Sealed class must have subclasses
}
```

Błąd jak najbardziej ma sens skoro zdecydowaliśmy się, że po naszej klasie będą mogły **dziedziczyć** tylko określone klasy to musimy je podać z wykorzystaniem słowa `permits` (jeśli nie chcemy, aby ktoś dziedziczył po naszej klasie to używamy do tego starego dobrego `final`).

#### Permits

Po określeniu, że nasza klasa będzie "zapieczętowana" musimy określić kto będzie mógł po niej **dziedziczyć**. Realizujemy to za pomocą słowa kluczowego `permits`:

```java
public sealed class Player permits Mp3Player, Mp4Player {

}

public class Mp3Player extends Player {
    //sealed, non-sealed or final modifiers expected
}

public class Mp4Player extends Player {
   // sealed, non-sealed or final modifiers expected
}

public class SpanishInquisition extends Player {
    //SpanishInquisition is not allowed in the sealed hierarchy
}
```

Dzięki temu, ograniczyliśmy to, kto może **dziedziczyć** po naszej klasie i tym samym rozwiązaliśmy problem z `SpanishInquisition` (co jest w tym przypadku pożądane). Jednakże, nadal mamy błąd w naszej implementacji. `sealed, non-sealed or final modifiers expected`, jeśli zdecydowaliśmy się na modelowanie **hierarchii** z wykorzystaniem słowa `sealed`, to jest to też propagowane "w dół". Wszystkie klasy dziedziczące po klasie `sealed`, muszą być oznaczone jako jedna z opcji:

*   `sealed` - jeśli chcemy dalej ograniczać dziedziczenie (dalsze modelowanie hierarchii klas)
*   `non-sealed` - jeśli chcemy, aby każdy mógł dziedziczyć po naszej klasie (powrót do poprzedniej wersji Javy)
*   `final` - jeśli chcemy zakazać dalszego dziedziczenia  (zakończenie gałęzi hierarchii)

W moim przykładzie nie chcę, aby ktoś mógł dziedziczyć po moich klasach więc wykorzystam `final`:

```java
public sealed class Player permits Mp3Player, Mp4Player {

}

public final class Mp3Player extends Player {
}

public final class Mp4Player extends Player {
}
```

#### Klasy wewnętrzne

Ponadto, jeśli nasze implementacje są **zwięzłe** (posiadają bardzo krótkie implementacje) możemy umieścić je w tej **samej** klasie (w tym samym pliku) co klasa oznaczona jako `sealed`. W takim podejściu nie musimy pisać słowa kluczowego `permits`:

```java
public sealed class Player {

}

final class Mp3Player extends Player {
}

final class Mp4Player extends Player {
}
```

#### Pakiet lub moduł

Elementy użyte przy słowie `permits` muszą pochodzić z tego samego pakietu lub z tego samego modułu co klasa bazowa. Dodatkowo klasy wypisane na liście muszą dziedziczyć **bezpośrednio** po "zapieczętowanej" klasie.

#### Pattern matching

W przyszłości planowane jest połączenie **JEP 360** ze **switch expression**. Switch expression dało nam możliwość wywołania funkcjonalności wewnątrz bloku `switch`:

```java
switch(value) {
case 1 -> System.out.println("1");
case 2 -> System.out.println("2");
default -> System.out.println("default");
}
```

Wyobraźmy sobie teraz przykład, w którym chcemy wypisać nazwę odtwarzacza w zależności od jego typu:

```java
void printPlayer(Player player) {
  switch(player) {
  case Mp3Player -> System.out.println("Mp3Player");
  case Mp4Player -> System.out.println("Mp4Player");
  default -> System.out.println("default");
  }
}
```

Niestety, dotychczasowa konstrukcja wymusza na nas przygotowanie wartości **domyślnej**. Ale czy w naszym przypadku może być inny typ? Nie, ponieważ klasy oznaczone jako `sealed` gwarantują nam obecność wszystkich typów (i wiemy, że nowy typ nie może się pojawić) więc możemy usprawnić powyższy kod do formy:

```java
void printPlayer(Player player) {
  switch(player) {
  case Mp3Player -> System.out.println("Mp3Player");
  case Mp4Player -> System.out.println("Mp4Player");
  }
}

//Lub
void printPlayer(Player player) {
  switch(player) {
  case Mp3Player mp3 -> System.out.println(mp3.logic());
  case Mp4Player mp4 -> System.out.println(mp4.logic());
  }
}
```

### Class

Dodatkowo do klasy bazowej `Class` zostały dodane **dwie** metody:

*   `isSealed()` - która zawraca informacje czy klasa jest oznaczona jako `sealed` lub nie
*   `permittedSubclasses()` - która zwraca tablicę z klasami, które wymienione są w `permits`

### JVM

Wirtualna maszyna **Javy** rozpoznaje w **runtime** czy nasza klasa lub interfejs oznaczone są jako `sealed`. Realizowane jest to za pomocą nowego wpisu przechowywanego w skompilowany pliku .**class**:

```
PermittedSubclasses\_attribute {
    u2 attribute\_name\_index;
    u4 attribute\_length;
    u2 number\_of\_classes;
    u2 classes\[number\_of\_classes\];
}
```

Po **dekompilacji** widzimy, że rzeczywiście taki wpis się pojawił:

```
SourceFile: "Player.java"
PermittedSubclasses:
  pl/codecouple/Mp3Player
  pl/codecouple/Mp4Player
```

### Przyszłość

Jak do tej pory nie ma żadnych **informacji** na kiedy planowane jest **oficjalne** wydanie tej funkcjonalności. Zakładam, że większość "ciekawych" featurów planowana jest na **Javę** w wersji **17**, ponieważ będzie to **LTS**, a tym samym większość firm "przepnie" się na tą wersję. Na pewno **JEP 360** pozwoli na nam lepsze projektowanie **hierarchii**, ale czy będziemy z tego korzystać? Z tym pytanie was zostawiam ;)