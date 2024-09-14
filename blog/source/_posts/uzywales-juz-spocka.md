---
title: Używałeś już Spocka?
tags:
  - groovy
  - java
  - spock
  - testing
id: '2035'
categories:
  - - Java
  - - Testing
date: 2017-08-11 12:05:04
author: 'Krzysztof Chruściel'
---

[![](http://codecouple.pl/wp-content/uploads/2017/05/testingLogo.png)](http://codecouple.pl/wp-content/uploads/2017/05/testingLogo.png)

JUnity, JUnity, i jeszcze raz JUnity. Tak do jakiegoś czasu wyglądało moje testowanie. Na konferencjach coraz częściej pojawiał się skrót **BDD**, czyli **Behavior Driven Development** oraz kojarzące się ze Star Trekiem słowo **Spock**. Spock jest frameworkiem do testowania kodu w języku **Java** jak i **Groovy**, który został wydany w wersji **1.0** w roku **2015**. Znacznie różni się on od testów jednostkowych, które korzystają z biblioteki **JUnit**. Framework ten jest zbiorem wszystkich dobrych bibliotek stosowanych dotychczas razem!
<!-- more -->
### Given When Then

Parę lat temu usłyszałem o konwencji **Given When Then** (można stosować zamiennie z **Arrange Act Assert**), który dzieli kod testu na trzy logiczne sekcje:

*   **Given** - tutaj znajdują się wartości, dla których będzie wykonywany test
*   **When** - tutaj znajduje się akcja, której wynik będziemy testować
*   **Then** - w tej sekcji, testujemy wynik akcji z sekcji **When**

Następnie postanowiłem stosować tę konwencję w swoich testach **JUnitowych**, niestety są to tylko komentarze. Stosowanie ich poprawia czytelność dla kogoś kto czyta ten test po raz pierwszy oraz zna konwencję **GivenWhenThen**:

@Test
public void shouldReturnFizzWhenNumberIsDividedByThree(){
    //Given
    int number = 3
    //When
    String result = fizzBuzz.check(number)
    //Then
    assertThat(result).contains("Fizz")
}

Następnie pojawił się problem konwencji **nazewniczej** testów. Każdy programista ma swój styl nazywania testów i czasami ciężko było zrozumieć co tak naprawdę ten test testuje. Jednym ze sposobów rozwiązania problemu sztucznych komentarzy oraz różnych stylów nazewnictwa jest **Spock**. Jak pisałem we wstępie, **Spock** jest frameworkiem do testowania, w którym piszemy używając **Grooviego**. Jak będzie wyglądał nasz test w **Spocku**:

def "'check' method should return 'Fizz' for number which is divided by three" () {
    given: "The customer gave us the number"
        def number = 3
    when: "The customer runs 'check' method"
        def result = fizzBuzz.check(number)
    then: "result should be 'Fizz'"
        result == "Fizz"
}

Od razu w oczy rzuca się to, iż nazwa metody może być opisowa (mamy tę możliwość dzięki **Grooviemu**), dzięki temu nie musimy się zastanawiać jak najlepiej nazwać test. Nazwa metody może być opisana językiem naturalnym co dla nas jest bardziej czytelne niż camelCase. Sekcje **GWT** są także integralną częścią **Spocka**, przez co udało nam się wyeliminować nadmiarowe komentarze. Testy w **Spocku** są bardziej deskryptywne, musimy pamiętać o zasadzie **pareto 20/80** \- 20% kodu piszemy, 80% czytamy. Tutaj czytelność jest bardzo dobra!

### Od czego zacząć?

Aby móc zacząć testować w **Spocku** wystarczy dodać jedną zależność do **Mavena** lub **Gradle**, w zależności  od tego jakiego narzędzia do budowania używamy:

<dependency>
   <groupId>org.spockframework</groupId>
   <artifactId>spock-core</artifactId>
   <version>0.7-groovy-2.0</version>
</dependency>

Wszystkie testy w **Spocku**, piszemy w **Groovym**. Klasy testowe są **specyfikacją** w rozumieniu **Spocka**, ponieważ testujemy specyfikację, która opisuje featury związane z systemem. Wszystkie nasze klasy testowe muszą dziedziczyć po klasie `Specification` (w tej klasie znajdują się też różne użyteczne metody) :

import spock.lang.Specification

class TodoSpec extends Specification{

}

Każda specyfikacja może mieć cztery elementy:

*   **fields**
*   **fixture methods**
*   **feature methods**
*   **helper methods**

### Fields

W tej sekcji definiujemy pola, które będą używane w naszych testach. Podobnie jak w **JUnitach**, pole zainicjalizowane w klasie będzie przed każdym testem ustawiane na nowo. Jest to równoważne z tym jakbyśmy umieścili inicjalizowanie w metodzie `setup`. Jeśli jednak potrzebujemy współdzielić zmienną pomiędzy testami, możemy wykorzystać adnotację `@Shared`.

```
class MyFirstSpecification extends Specification {
    @Shared
    veryExpensive = new SomeClass() // shared between tests
    reNew = new SomeSecondClass() // renew between tests
}
```

### Fixture methods

Podobnie jak w **JUnitach**, dostępne są metody do ustawienia elementów przed oraz po testowaniu.

*   **setup** - metoda uruchamiana przed każdym testem (`@Before` w JUnitach)
*   **cleanup** - metoda uruchamiana po każdym teście (`@After` w JUnitach)
*   **setupSpec** - metoda uruchamiana przed wszystkim testami (`@BeforeClass` w JUnitach)
*   **cleanupSpec** - metoda uruchamiana po wszystkich testach (`@AfterClass` w JUnitach)

### Feature methods

"Feature methods", pod taką nazwą w dokumentacji występują nasze metody testowe. Koncepcyjnie podzielone są one na cztery **fazy**:

*   **Setup** - ustawiamy nasz test
*   **Stimulus** - definiujemy akcje
*   **Response** - sprawdzamy wynik
*   **Cleanup** - sprzątamy po teście

Wewnątrz tych faz, korzystamy z **blocków**, które najlepiej przedstawia ten obrazek (oryginalny z dokumentacji):

![](http://spockframework.org/spock/docs/1.1/images/Blocks2Phases.png)

##### Setup

W bloku setup ustawiamy wartości do naszego testu. Dodatkowo istnieje blok `given` zwiększający czytelność, który jest ekwiwalenty do bloku `setup`.

##### When i Then

Blok `when` zawsze występuję z blokiem `then`. W `when` definiujemy nasze akcje, których wyniki będziemy sprawdzać w teście. `then` natomiast jest blokiem, w którym sprawdzamy wynik. Ale jak to, bez asercji? Tak! Wystarczy napisać warunek logiczny zwracający `boolean`.

##### Expect

Te dwa bloki mogą być zastąpione jednym blokiem `expect`.

##### Cleanup

`cleanup` powinien służyć do zamykania plików, strumieni i innych elementów.

##### Where

W ostatnim bloku, czyli `where` ustawiamy parametry do testu.

##### And

Oprócz bloku `given` zwiększającego czytelność istnieje blok `and`. Możemy go używać w połączeniu z innymi, aby zwiększyć czytelność.

### Helper methods

Gdy nasze testy zaczynają "puchnąć", czasem warto coś wyciągnąć do innej metody.

def "helper method example" () {
    when: "Todo is created"
        def todo = todoFactory.createTodo()
    then: "Todo contains default fields"
        checkDefaultFields(todo)
}

def checkDefaultFields(todo) {
    assert todo.title == "default title"
    assert todo.description == "default description"
}

### Mockowanie

Jak napisałem we wstępie, Spock jest połączeniem wielu bardzo dobrych bibliotek. Dobre testy jednostkowe, a raczej te, które pisane są poprawnie powinny być wykonywane w kompletnej izolacji. **Unit testy** nie mogą zależeć od innych elementów. Do zapewniania izolacji w testach użyjemy **mockowania**. Nie musimy ściągać dodatkowo **Mockito**, czy innych bibliotek do mockowania, ponieważ mechanizm ten jest wbudowany w **Spocka**.

### Testy parametryzowane

W **JUnitach** 4 testy parametryzowane były w niezbyt przyjemny dla developerów sposób. Powstało kilka bibliotek ułatwiających parametryzację testów, jedną z nich jest propozycja [Pragmatists](https://github.com/Pragmatists/JUnitParams). W **Spocku** testy parametryzować można na dwa sposoby:

*   **data tables**
*   **data pipes**

### Data tables

**Data tables** jest mechanizmem preferowanym przeze mnie jeśli chodzi o testy parametryzowane. Przygotowujemy tabelę, w której nagłówki to pola, które chcemy uzupełnić, natomiast pod nagłówkami umieszczamy wartości tych pól. Pola rozdzielamy pipem . Dla lepszej czytelności możemy także rozdzielić dane wejściowe od oczekiwanego wyniku podwójnym pipem .

def "data table example" () {
    when: "The customer runs 'check' method"
        def result = fizzBuzz.check(number)
    then: "result should be as #expectedResult"
        result == expectedResult
    where:
        number  expectedResult
        1       ""
        3       "Fizz"
        5       "Buzz"
        15      "FizzBuzz"
}

### Data pipes

Drugi sposób rzadziej przeze mnie używany to **Data Pipes**:

def "data pipes example" () {
    when: "The customer runs 'check' method"
        def result = fizzBuzz.check(number)
    then: "result should be as #expectedResult"
        result == expectedResult
    where:
        number << \[1, 3, 5, 15\]
        expectedResult << \["", "Fizz", "Buzz", "FizzBuzz"\]
}

### Wyjątki

**JUnity** nie do końca radziły sobie z wyjątkami w poprawny sposób. Gdy korzystaliśmy z `ExpectedException` musieliśmy definiować jakiego typu wyjątek ma wystąpić przed wywołaniem sekcji when, co traciło na czytelności. W **Spocku** jest to już zaimplementowane w lepszy sposób. Aby sprawdzić czy wyjątek wystąpił, korzystamy z metody `thrown(YourExceptionClass)`.

def "exception example" (){
    when: "user get a Todo which not exists"
        def todo = todoFacade.get(10)
    then: "exception TodoNotFound should be thrown"
        thrown(TodoNotFound)
}

Możemy także przypisać **wyjątek** do zmiennej, jeśli chcemy sprawdzić `message` lub inne właściwości tego wyjątku:

def "exception example" (){
    when: "user get a Todo which not exists"
        def todo = todoFacade.get(10)
    then: "exception TodoNotFound should be thrown"
        def exception = thrown(TodoNotFound)
        exception.message == "Todo not found"
}

### Więcej

W tym wpisie opisałem tylko część featurów występujących w Spocku. Bardzo mocno zachęcam do [przeczytania dokumentacji](http://spockframework.org/spock/docs/1.1/index.html), aby sięgnąć po więcej!