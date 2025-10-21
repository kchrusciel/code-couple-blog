---
title: Stos operandów i tablica zmiennych lokalnych
tags:
  - java
  - jvm
  - operand stack
id: '3496'
categories:
  - - Java
date: 2019-01-11 12:01:13
author: 'Krzysztof Chruściel'
---

![](https://raw.githubusercontent.com/kchrusciel/code-couple-blog-assets/main/2017/02/java-logo.png)

Aby zrealizować obietnicę "_Write Once Run Everywhere_", autorzy **Javy** musieli rozwiązać kilka problemów. Jednym z nich była zmienna liczba **rejestrów** procesora. Rozwiązaniem tego problemu było zastosowanie **stosu** jako struktury danych do wykonywania operacji na **operandach**. Aby przekonać się, jak to działa "pod spodem", zapraszam do wpisu!
<!-- more -->
### Tablica zmiennych lokalnych

Tablica zmiennych lokalnych, jak nazwa wskazuje, służy do przechowywania **zmiennych lokalnych**. Są to zmienne widoczne w ramach jednej **metody** i jednego **wątku**. Rozmiar tej tablicy wyliczany jest w trakcie **kompilacji**, dlatego podczas jej tworzenia jej rozmiar jest znany z góry. Pozwala to na optymalizowanie programu, ponieważ w przeciwnym razie tablica ta musiałaby być alokowana **dynamicznie**. Po stworzeniu tablicy zmiennych, na pierwszym indeksie znajduje się referencja do aktualnej instancji (`this`) – w przypadku metody statycznej nie mamy żadnej instancji. Na kolejnych indeksach znajdują się parametry metody, jeśli takowe występują:

```java
public class First {
    
    void method(String first, int second) {
        // empty
    }
    
}
```

Gdzie:

* `start` - offset początkowy (od którego bytekodu zmienna ta jest widoczna)
* `length` - długość (przez jak wiele bytekodów zmienna ta jest widoczna)
* `slot` - pozycja w tablicy numerowana od 0
* `name` - nazwa zmiennej
* `signature` - sygnatura zmiennej (zapis **JVM**)

W tej tablicy znajdują się również zmienne lokalne zainicjalizowane w ramach **metody**:

```java
public class First {
    
    void method(String first, int second) {
        int third = 100;
        boolean flag = true;
    }
    
}
```

Tablica poniżej reprezentuje informacje przechowywane w **tablicy zmiennych lokalnych**:

Skoro wiemy już, jak przechowywane są **zmienne lokalne**, spróbujmy wykonać na nich jakieś operacje. Do tego potrzebna będzie nam znajomość **stosu operandów**.

### Stos operandów

Jak napisałem we wstępie, **Java** wewnętrznie oparta jest na strukturze **stosu**. Wszystkie operacje wykonywane w ramach jednej metody polegają na "żonglowaniu" danymi na stosie. W **Javie** jest to tak zwany **stos operandów**. Sprawdźmy, jak zachowuje się **stos operandów** dla operacji dodawania dwóch liczb:

```java
public class Add {

  void methodB() {
    methodC(120);
  }

  int methodC(int value) {
    return value + 30;
  }

}
```

Na samym dole **stosu** zostało załadowane pole `this`. Pole to zostało załadowane z **tablicy zmiennych lokalnych** widoczne pod `LocalVariableTable`. Ładowanie to odbyło się poprzez instrukcję `aload_0`, gdzie `a` reprezentuje typ obiektowy (`this` to referencja do obiektu), a `0` to numer indeksu w **tablicy zmiennych lokalnych**:

Następnie na górę stosu wrzucamy **stałą**. Dzieje się to przy udziale metody `bipush 120`, gdzie `bi` reprezentuje typ `byte`, a `120` **stałą**:

Gdy na stosie znajdują się już dwa elementy, pora na wywołanie metody **wirtualnej**. Metoda `invokevirtual` pobiera obie wartości ze stosu: pierwsza przekazywana jest jako parametr, a druga to wskaźnik na obiekcie, na "którym" ta metoda ma być wywołana:

Po wykonaniu metody, wynik jej działania odkładany jest na górze **stosu**. Aby metoda zakończyła swoje działanie, **stos operandów** musi być pusty. Nasza metoda nigdzie nie używa wyniku wywołania metody `methodC(120)`, więc możemy usunąć ramkę ze stosu, korzystając z metody `pop`:

Dla Wirtualnej Maszyny **Javy** koniec metody oznaczany jest poprzez wywołanie metody `return`. Zauważmy, że kompilator sam dodał instrukcję `return` do naszej metody:

### Ramka

Na stosie operandów odkładane są ramki, z których każda ma rozmiar **czterech bajtów** (32 bity). Oznacza to, że jeśli mamy **zmienne lokalne** typu `byte`, `short`, `char` czy `boolean`, to są one **dopełniane** do **czterech bajtów**. Jeśli ktoś z was zastanawiał się nad optymalizacją zmiennych lokalnych, to teraz ma odpowiedź, że nie warto tego robić dla oszczędności pamięci. Poniżej znajduje się tabela prezentująca, jak **JVM** reprezentuje poszczególne typy:

### Long i double

Skoro wiemy, że ramka posiada rozmiar **czterech bajtów**, to w jaki sposób przechowywane są typy `long` i `double`? Potrzebują one **dwóch slotów** (ramek). Rozmiar tych typów zmiennych determinuje fakt, że operacje na zmiennych typu `long` i `double` zdejmują cztery ramki ze stosu zamiast dwóch. Czy próbowaliście kiedyś zrobić coś takiego i zastanawialiście się, czemu jest to niedozwolone:

```shell
100L + 100
```

Otóż w tym przypadku na stosie znajdowałyby się tylko trzy ramki (dwa sloty na `long` i jeden na `int`). A metoda `ladd` ściąga cztery, co prowadzi do błędu kompilacji:![](https://raw.githubusercontent.com/kchrusciel/code-couple-blog-assets/main/2019/01/operand_stack_long_int-1024x315.png)
