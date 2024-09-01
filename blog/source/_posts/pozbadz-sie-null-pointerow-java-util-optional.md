---
title: Pozbądź się null pointerów - java.util.Optional
tags:
  - java
  - optional
id: '427'
categories:
  - - Clean Code
  - - Java
  - - JVM
date: 2016-03-09 07:00:06
---

![](https://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

**Null pointer exception** jest chyba najbardziej rozpoznawalnym i najczęściej występującym wyjątkiem w **Javie**. Wyjątek ten może doprowadzać do wielu niepożądanych zachowań (w tym przerwanie działania aplikacji). **Java 8** dostarcza nam nową klasę **Optional** z pakietu `java.util.*`, która pozwala nam w lepszy sposób zabezpieczyć się przed tego typu **wyjątkiem**.
<!-- more -->
### Problem

Na początku przyjrzyjmy się jak to było po staremu. Nasza metoda odczytuje dane z bazy danych. W przypadku gdy dane nie wystąpią możemy to obsłużyć na kilka sposobów:

Product getValueBy(final String id) {
    return readFromDB(id);
}

Product getValueBy(final String id) {
    Product product = readFromDB(id);
    if (product == null) {
        throw new IllegalStateException();
    }
    return product;
}

Lub spróbować opakować wynik w nasz obiekt (przykładowo `DataBaseResult`, który przechowuje wartość jeśli istnieje). Od **Javy 8** sami już nie musimy tworzyć klasy opakowującej ponieważ, otrzymaliśmy klasę `Optional`.

### Tworzenie

Klasę `Optional` można stworzyć na kilka sposobów. Sposób tworzenia zależy od efektu jaki chcemy osiągnąć.

#### Metoda of

Metoda `of` służy do opakowania wartości jako typ `Optional`. Z metodą `of` należy uważać, jeśli wrzucimy do środka wartość `null` ponieważ, dostaniemy wyjątek typu `NullPointerException`:

@Test
void shouldThrowNullPointerExceptionWhenValueIsNullOnOf() {
    // When
    Executable optionalWithNull =
            () -> Optional.of(null);

    // Then
    assertThrows(NullPointerException.class, optionalWithNull);
}


@Test
void shouldReturnTrueWhenValueIsPresent() {
    // Given
    Optional<String> optional = Optional.of("");

    // When
    boolean isPresent = optional.isPresent();

    // Then
    assertThat(isPresent).isTrue();
}

#### Metoda ofNullable

Metoda `ofNullable` w przeciwieństwie do metody `of` służy do opakowania wartości, która może być `null'owa`. Tym razem jeśli wrzucimy wartość `null` to nie dostaniemy wyjątku:

@Test
void shouldNotThrowNullPointerExceptionWhenValueIsNullOnOfNullable() {
    // When
    Executable optionalWithNull =
            () -> Optional.ofNullable(null);

    // Then
    assertAll(optionalWithNull);
}

#### Metoda empty

Ostatnim sposobem stworzenia wartości `Optional` jest metoda `empty`. Tworzy ona pustego `Optional'a`. Może być on wykorzystywany jako wartość domyślna zwracana z metody:

Optional<Product> getValueBy(final String id) {
    if (StringUtils.isBlank(id)) {
        return Optional.empty();
    }
    return Optional.ofNullable(readFromDB(id));
}

### Sprawdź zanim pobierzesz

Wiemy już w jaki sposób opakować wartość jako opcjonalna. Teraz chcielibyśmy tą wartość odczytać. Jednakże, w przypadku `Optional` zawsze powinniśmy sprawdzić czy wartość istnieje. Do tego wykorzystujemy metodę `isPresent`:

@Test
void shouldReturnTrueWhenValueIsPresent() {
    // Given
    Optional<String> optional = Optional.of("");

    // When
    boolean isPresent = optional.isPresent();

    // Then
    assertThat(isPresent).isTrue();
}

@Test
void shouldReturnFalseWhenValueIsNotPresent() {
    // Given
    Optional<String> optional = Optional.empty();

    // When
    boolean isPresent = optional.isPresent();

    // Then
    assertThat(isPresent).isFalse();
}

Ponadto otrzymaliśmy bardziej funkcyjną metodę do wywołania logiki w przypadku wystąpienia danych. Jest to metoda `ifPresent`, która przyjmuje `Consumer`:

@Test
void shouldCallMethodWhenValueIsPresentOnIfPresent() {
    // Given
    Optional<String> optional = Optional.of("call");
    Slepper slepper = Mockito.mock(Slepper.class);
    doCallRealMethod().when(slepper).consumer("call");

    // When
    optional.ifPresent(slepper::consumer);

    // Then
    verify(slepper).consumer("call");
}

### Transformacje

Na samej wartości `Optional` możemy składać dodatkowe **transformacje** takie jak:

*   `filter` - filtruje dane
*   `map` - zmienia typ
*   `flatMap` - "spłaszczenie" danych

String getProductValueBy(final String id, final String productName) {
    return getValueBy(id)
            .filter(product -> product.productName.equals(productName))
            .flatMap(product -> getValueBy(product.productName))
            .map(product -> product.productName)
            .map(String::toUpperCase)
            .orElseGet(this::getDefaultValue);
}

### W przeciwnym wypadku

Pobranie wartości, która jest **opcjonalna** pozwala nam definiować **domyślne wartości** lub **zachowaniu** w przypadku gdy `Optional` jest pusty.

#### orElse

Jeśli chcemy zwrócić wartość domyślną w przypadku gdy `Optional` jest pusty to możemy do tego celu wykorzystać metodę `orElse`.

@Test
void shouldReturnDefaultWhenValueIsNotPresentOnOrElse() {
    // Given
    Optional<String> optional = Optional.empty();

    // When
    String value = optional.orElse("orElse");

    // Then
    assertThat(value).isEqualTo("orElse");
}

Jednakże z metodą `orElse` należy uważać. Jeśli zamiast zwracania wartości wywołamy metodę, to metoda ta zostanie wywołana nawet wtedy kiedy wartość w `Optional` istnieje:

@Test
void shouldCallMethodWhenValueIsPresentOnOrElse() {
    // Given
    Optional<String> optional = Optional.of("orElse");
    Slepper slepper = Mockito.mock(Slepper.class);
    when(slepper.getDefaultValue()).thenCallRealMethod();

    // When
    String value = optional.orElse(slepper.getDefaultValue());

    // Then
    verify(slepper).sleep();
    assertThat(value).isEqualTo("orElse");
}

class Slepper {

    String getDefaultValue() {
        sleep();
        return "default";
    }

    void sleep()  {
        
    }

}

#### orElseGet

Rozwiązaniem nadgorliwej metody `orElse` jest leniwa metoda `orElseGet`. Jako parametr przyjmuje ona `Suppiler`:

@Test
void shouldReturnDefaultWhenValueIsNotPresentOnOrElseGet() {
    // Given
    Optional<String> optional = Optional.empty();

    // When
    String value = optional.orElseGet(() -> "orElse");

    // Then
    assertThat(value).isEqualTo("orElse");
}

@Test
void shouldNotCallMethodWhenValueIsPresentOnOrElseGet()  {
    // Given
    Optional<String> optional = Optional.of("orElse");
    Slepper slepper = Mockito.mock(Slepper.class);
    when(slepper.getDefaultValue()).thenCallRealMethod();

    // When
    String value = optional.orElseGet(slepper::getDefaultValue);

    // Then
    verifyZeroInteractions(slepper);
    assertThat(value).isEqualTo("orElse");
}

#### orElseThrow

Czasami zakładamy, iż dane o które odpytujemy bazę danych muszą **wystąpić**. Jeśli natomiast nie wystąpią oznacza to dla nas sytuację wyjątkową. Sytuacje wyjątkowe najczęściej obsługujemy poprzez **wyjątki**. Jeśli w przypadku braku wartości chcemy rzucić **wyjątek**, to możemy zastosować metodę `orElseThrow` (podobnie jak `orElseGet` też jest **leniwa**):

@Test
void shouldThrowIllegalStateExceptionWhenValueIsEmpty() {
    // Given
    Optional<String> optional = Optional.empty();

    // When
    Executable optionalWhichThrowException =
            () -> optional.orElseThrow(() -> new IllegalStateException());

    // Then
    assertThrows(IllegalStateException.class, optionalWhichThrowException);
}

### Optional jako parametr metody

`Optional` powinien być wykorzystywany tylko do zwracania opcjonalnych danych. Nie **powinniśmy** stosować klasy `Optional` jako typ w **paramaterze** metody. Jeśli posiadamy metodę, w której jeden z parametrów jest opcjonalny to możemy taką metodę **przeciążyć** (OOP):

void methodWithOptional(
        final String value,
        final Optional<String> secondValue) {
    // some logic here
}

void methodOverload1(final String value) {
    // some logic here
}

void methodOverload2(
        final String value,
        final String secondValue) {
    // some logic here
}

### Optional a serializacja

Zdefiniowanie pola typu `Optional` może powodować problemy jeśli nasza klasa jest **serializowana**, ponieważ typ `Optional` nie jest **serializowalny**.

### GitHub

Całość jak zawsze na [GitHub'ie](https://github.com/kchrusciel/CodeCouple/tree/master/Optional).