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

![](http://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

Aby zrealizować obietnicę "_Write Once Run Everywhere_" autorzy **Javy** musieli rozwiązać kilka problemów. Jednym z nich była zmienna liczba **rejestrów** procesora. Rozwiązaniem tego problemu było zastosowanie **stosu** jako struktury danych do wykonywania operacji na **operandach**. Aby przekonać się jak to działa "pod spodem" zapraszam do wpisu!
<!-- more -->
### Tablica zmiennych lokalnych

Tablica zmiennych lokalnych jak nazwa wskazuje służy do przechowywania **zmiennych lokalnych**. Są to zmienne widoczne w ramach jednej **metody** i jednego **wątku**. Rozmiar tej tablicy wyliczany jest w trakcie **kompilacji**, dlatego podczas tworzenia tej tablicy jej rozmiar znany jest z góry. Pozwala to na optymalizowanie naszego programu, ponieważ w przeciwnym wypadku tablica ta musiałaby być alokowana **dynamicznie**. Po stworzeniu tablicy zmiennych na pierwszym indeksie znajduje się referencja do aktualnej instancji (w przypadku metody statycznej nie mamy żadnej instancji). Na kolejnych indeksach znajdują się parametry metody jeśli takowe występują:

public class First {
    
    void method(String first, int second) {
        // empty
    }
    
}

![](https://codecouple.pl/wp-content/uploads/2019/01/local_variable_table_second-1024x363.png)

Gdzie:

*   `start` - offset początkowy (od którego bytekodu zmienna ta jest widoczna)
*   `length` - długość (przez jak wiele bytekodów zmienna ta jest widoczna)
*   `slot` - pozycja w tablicy numerowana od 0
*   `name` - nazwa zmiennej
*   `signature` - sygnatura zmiennej (zapis **JVM**)

W tej tablicy znajdują się również zmienne lokalne zainicjalizowane w ramach **metody**:

public class First {
    
    void method(String first, int second) {
        int third = 100;
        boolean flag = true;
    }
    
}

Tablica poniżej reprezentuje informacje przechowywane w **tablicy zmiennych lokalnych**:

![](https://codecouple.pl/wp-content/uploads/2019/01/local_variable_table-1024x516.png)

Jak wiemy już jak przechowywane są **zmienne lokalne** to spróbujmy wykonać na nich jakieś operacje. Do tego potrzebna będzie nam znajomość **stosu operandów**.

### Stos operandów

Jak napisałem we wstępnie, **Java** wewnętrznie oparta jest na strukturze **stosu**. Wszystkie operacje wykonywane w ramach jednej metody polegają na "żonglowaniu" danymi na stosie. W **Javie** jest to tak zwany **stos operandów**. Sprawdźmy jak zachowuje się **stos operandów** dla operacji dodawania dwóch liczb:

public class Add {

  void methodB() {
    methodC(120);
  }

  int methodC(int value) {
    return value + 30;
  }

}

Na samym dole **stosu** zostało załadowane pole `this`. Pole to zostało załadowane z **tablicy zmiennych lokalnych** widocznych pod `LocalVariableTable`. Ładowanie to odbyło się poprzez instrukcję `aload_0`, gdzie `a` reprezentuje typ obiektowy (`this` to referencja do obiektu), a 0 to numer indeksu w **tablicy zmiennych lokalnych**:

![](https://codecouple.pl/wp-content/uploads/2019/01/method_b_operand_stack-1024x659.png)

Następnie na górę stosu wrzucamy **stałą**. Dzieje się to przy udziale metody `bipush 120` gdzie `bi` reprezentuje typ `byte` a `120` **stałą**:

![](https://codecouple.pl/wp-content/uploads/2019/01/method_b_operand_stack_1-1024x659.png)

Gdy na stosie znajdują się już dwa elementy pora na wywołanie metody **wirtualnej**. Metoda `invokevirtual` pobiera obie wartości ze stosu, pierwsza przekazywana jest jako parametr a druga to wskaźnik na "kim" ta metoda ma być wywołana:

![](https://codecouple.pl/wp-content/uploads/2019/01/method_b_operand_stack_2-1024x659.png)

Po wykonaniu metod wynik jej odkładany jest na górze **stosu**. Aby metoda zakończyła swoje działanie **stos operandów** musi być pusty. Nasza metoda nigdzie nie używa wyniku wywołania metody `methodC(120)`, więc możemy usunąć ramkę ze stosu korzystając z metody `pop`:

![](https://codecouple.pl/wp-content/uploads/2019/01/method_b_operand_stack_3-1024x659.png)

Dla wirtualnej maszyny **Javy** koniec metody oznaczany jest poprzez wywołanie metody `return`. Zauważmy, iż kompilator sam dodał instrukcję `return` do naszej metody:

![](https://codecouple.pl/wp-content/uploads/2019/01/method_b_operand_stack_4-1024x659.png)

### Ramka

Na stosie operandów odkładane są ramki, których rozmiar wynosi **cztery bajty**. Ale jak to cztery bajty? Oznacza to, że jeśli mamy **zmienne lokalne** typu `byte`, `short`, `char` czy `boolean` to **dopełniane** są one do **czterech bajtów**. Jeśli ktoś z was zastanawiał się nad optymalizacją zmiennych lokalnych to teraz ma odpowiedź, że nie warto ;). Poniżej znajduje się tabela prezentująca jak **JVM** reprezentuje poszczególne typy:

![](https://codecouple.pl/wp-content/uploads/2019/01/jvm_bytecode_table-1024x574.png)

### Long i double

Skoro wiemy, iż ramka posiada rozmiar **czterech bajtów** to w jaki sposób przechowywane są `long` i `double`? Potrzebują one dwóch slotów (ramek). Rozmiar tych typów zmiennych determinuje fakt, iż operacje na zmiennych typu `long` i `double` zdejmują cztery ramki ze stosu zamiast dwóch. Czy próbowaliście kiedyś zrobić coś takiego i zastanawialiście się czemu jest to niedozwolone:

100L + 100

Otóż w tym przypadku na stosie znajdowały by się tylko trzy ramki. A metoda `ladd` ściąga cztery:![](https://codecouple.pl/wp-content/uploads/2019/01/operand_stack_long_int-1024x315.png)