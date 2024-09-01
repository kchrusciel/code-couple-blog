---
title: Interfejsy funkcyjne
tags:
  - java
id: '950'
categories:
  - - Java
date: 2016-10-08 11:36:48
---

Mała odskocznia od artykułów na temat Spring Boot'a, które ostatnio zdominowały nasz blog. Interfejsy funkcyjne są jednym z wielu nowych elementów w Javie 8. Wszystkie interfejsy funkcyjne znajdują się w pakiecie `java.util.function`.
<!-- more -->
Interfejsy funkcyjne wykorzystywane są przy współpracy z wyrażeniami Lambda. Możemy przygotować zachowania, które będziemy wykorzystywać podczas przetwarzania danych. W pakiecie `java.util.function` znajdziemy wiele bardzo użytecznych interfejsów funkcyjnych. Do tych najbardziej podstawowych należą:

*   `Function <T, R>` - przyjmuje dowolny obiekt i zwraca dowolny obiekt (T, R),
*   `Consumer <T>` - przyjmuje dowolny obiekt, ale nic nie zwraca (T, void),
*   `Supplier <T>` - nic nie przyjmuje, ale zwraca dowolny obiekt (void, T),
*   `Predicate <T>` - przyjmuje dowolny obiekt, ale zwraca boolean (T, boolean),
*   `UnaryOperator <T, T>` - przyjmuje oraz zwraca obiekt dowolnego typu, ale muszą być takie same (T, T) szczególny przypadek `Function`,

# Interfejs Function

Zacznijmy od implementacji tego intefejsu:

@FunctionalInterface
public interface Function<T, R> {
     R apply(T t);
     ...
}

Czyli tak jak napisałem powyżej, przyjmuje on oraz zwraca dowolny typ. Najważniejszą metodą w tym interfejsie jest metoda `R apply(T t).` Wywołuje ona pożądaną dla nas akcję.

Function<Integer, String> showCodeCouple = x -> x + " CodeCouple";
System.out.println(showCodeCouple.apply(10));
//"10 CodeCouple"

Własną logikę interfejsów funkcyjnych można wykorzystywać w strumieniach np. w metodzie `map(),` która jako parametr przyjmuje interfejs funkcyjny:

Function<String, Integer> createIntegerAndAddTen = x -> Integer.parseInt(x) + 10;
Stream.of("10", "20", "30")
          .map(createIntegerAndAddTen)
          .forEach(System.out::println);
//20, 30, 40

Po za metodą `apply(T t)` interfejs `Function` posiada metody `compose()`, `andThen()` oraz `identity()`. Dwie pierwsze metody służą do tworzenia łańcucha wywołań. Jeśli chcemy wykonać jakąś akcję przed wywołaniem naszego interfejsu korzystamy z `compose()`, natomiast jeśli chcemy wykonać jakąś akcję po, to korzystamy z `andThen()`.

Function<String, Integer> createIntegerAndAddTen = x -> Integer.parseInt(x) + 10;
Function<Integer, Integer> multiplyByTen = x -> x \* 10;
Function<String, String> addZero = x -> x + "0";

Stream.of("10", "20", "30")
        .map(createIntegerAndAddTen.andThen(multiplyByTen))
        .forEach(System.out::println);
//200, 300, 400

Stream.of("10", "20", "30")
        .map(createIntegerAndAddTen.compose(addZero))
        .forEach(System.out::println);
//110, 210, 310

Można oczywiście dodawać kolejne elementy łańcucha. Ostatnia metoda tak naprawdę nie robi nic. Czyli przyjmuje dowolny typ i też go zwraca bez żadnych modyfikacji. Wykorzystywana jest ona podczas testowania, gdy nie mamy zaimplementowanej żadnej logiki, a docelowo będziemy gdzieś ten interfejs wykorzystywać.

Stream.of("10", "20", "30")
        .map(Function.identity())
        .forEach(System.out::println);
//10, 20, 30

Function<Object, Object> doNothing = x -> x;

Stream.of("10", "20", "30")
        .map(doNothing)
        .forEach(System.out::println);
//10, 20, 30

# Interfejs Consumer

Zacznijmy od implementacji tego intefejsu:

@FunctionalInterface
public interface Consumer<T> {
     void accept(T t);
     ...
}

Według definicji najważniejszą metodą jest metoda `accept(),` która przyjmuje dowolny typ, natomiast nic nie zwraca. Nasz interfejs `Consumer` wywołujemy poprzez:

Consumer<String> showCodeCouple = text -> System.out.println(text);
showCodeCouple.accept("CodeCouple");
//CodeCouple

Ten typ interfejsu może być wykorzystywany wszędzie tam, gdzie wymagany jest interfejs `Consumer`:

Consumer<String> showCodeCouple = text -> System.out.println(text);
Stream.of("show", "Code", "Couple")
        .forEach(showCodeCouple);
//show
//Code
//Couple

Podobnie jak interfejs `Function` posiada on metodę `andThen(Consumer<? super T>),` która działa tak samo. Służy do tworzenia łańcuchów wywołań kolejnych `Consumerów`.

# Interfejs Supplier

Zacznijmy od implementacji tego intefejsu:

@FunctionalInterface
public interface Supplier<T> {
    T get();
}

Jedyną metodą w tym interfejsie jest `get()`. `Supplier` możemy wykorzystać jako "dostawce", przykład:

Supplier<String> returnCodeCouple = () -> "CodeCouple";
System.out.println(returnCodeCouple.get());
//CodeCouple

Interfejs ten nie ma żadnych dodatkowych metod.

# Interfejs Predicate

Zacznijmy od implementacji tego intefejsu:

@FunctionalInterface
public interface Predicate<T> {
    boolean test(T t);
    ...
}

Ponieważ `Predicate` zwraca `boolean` nazwanie metody `test()` jest bardzo intuicyjne. Metoda ta przyjmuje dowolny obiekt, ale musi zwrócić `true` lub `false`. Jest to bardzo przydany interfejs, gdy chcemy tworzyć metody "utilowe": sprawdzanie zawierania lub występowania jakiegoś warunku.

Predicate<String> checkCodeCoupleIsTheBest = text -> text.contains("best");
System.out.println("Is Code Couple the best? " + checkCodeCoupleIsTheBest.test("CodeCouple is the best"));
//Is Code Couple the best? true

Interefejs ten z racji na swoją zero-jedynkową naturę posiada użyteczne metody `and()`, `or()` oraz `negate()`.

Predicate<String> containsCode = textToCheck -> textToCheck.contains("Code");

Stream.of("showCode", "Code", "Couple")
        .filter(containsCode)
        .forEach(System.out::println);
//showCode
//Code

Predicate<String> containsCode = textToCheck -> textToCheck.contains("Code");

Stream.of("showCode", "Code", "Couple")
        .filter(containsCode.negate())
        .forEach(System.out::println);
//Couple

Predicate<String> containsCode = textToCheck -> textToCheck.contains("Code");
Predicate<String> containsCouple = textToCheck -> textToCheck.contains("Couple");

Stream.of("showCode", "Code", "CodeCouple")
        .filter(containsCode.and(containsCouple))
        .forEach(System.out::println);
//CodeCouple

Predicate<String> containsCode = textToCheck -> textToCheck.contains("Code");
Predicate<String> containsCouple = textToCheck -> textToCheck.contains("Couple");

Stream.of("showCode", "Code", "CodeCouple")
        .filter(containsCode.or(containsCouple))
        .forEach(System.out::println);
//CodeCouple
//showCode
//Code

Posiada także wbudowaną metodę statyczną `isEqual(),` która porównuje dwa obiekty:

Stream.of("showCode", "Code", "CodeCouple")
         .filter(Predicate.isEqual("Code"))
         .forEach(System.out::println);
//Code

# Interfejs UnaryOperator

Zacznijmy od implementacji tego intefejsu:

@FunctionalInterface
public interface UnaryOperator<T> extends Function<T, T> {
    static <T> UnaryOperator<T> identity() {
        return t -> t;
    }
}

Ponieważ interefejs `UnaryOperator` rozszerzany jest przez `Function`, metodą którą będziemy wywoływać jest `apply()`.

UnaryOperator<String> getCodeCouple = text -> text + " is the best";
System.out.println(getCodeCouple.apply("CodeCouple"));
//CodeCouple is the best

Podobnie jak `Function` posiada on metodę `indentity()`. Tak jak pisałem we wstępie, jest to szczególny przypadek interfejsu `Function` z tą różnicą, że musi przyjąć oraz zwrócić obiekt tego samego typu.

# Własny interfejs

Jedynym warunkiem, który musi być spełniony aby móc nazwać interfejs interefejsem funkcyjnym to posiadanie tylko jednej metody (może mieć więcej metod, jednakże muszą to być metody typu `default` lub `static`).

@FunctionalInterface
public interface PersonChecker {
    boolean checkNameContainsJan(Person person);
}

W powyższym przykładzie stworzyłem interfejs funkcyjny `PersonChecker,` który będzie sprawdzał czy obiekt `Person` zawiera imię Jan. Sama adnotacja `@FunctionalInterface` nic nie wnosi w naszym kodzie. Jest użyteczna, gdy używamy **IntelliJ,** ponieważ podpowiada zachowania dla interfejsu funkcyjnego. Aby użyć tego interfejsu należy go zaimplementować i wywołać naszą metodę:

PersonChecker personChecker = (p) -> p.getName().contains("Jan");
System.out.println("Check: " + personChecker.checkNameContainsJan(Person.JAN));
//Check: true

[GITHUB](https://github.com/kchrusciel/CodeCouple/tree/master/FunctionalInterface)