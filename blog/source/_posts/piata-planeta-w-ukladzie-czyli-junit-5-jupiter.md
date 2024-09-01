---
title: Piąta planeta w układzie czyli JUnit 5 Jupiter
tags:
  - junit
  - jupiter
  - testing
id: '1673'
categories:
  - - Java
  - - Testing
date: 2017-09-22 12:05:57
---

[![](http://codecouple.pl/wp-content/uploads/2017/05/testingLogo.png)](http://codecouple.pl/wp-content/uploads/2017/05/testingLogo.png)

**10-tego** września miało miejsce oficjalne wydanie **JUnitów** w wersji **5**. Autorzy wprowadzili rozwiązania, które sprawdziły się w innych bibliotekach łącząc to w jedną całość. Zmieniło się także podejście do architektury biblioteki. Czy warto już zacząć migrować się do najnowszej wersji?
<!-- more -->
### Migracja

Autorzy biblioteki dołożyli wszelkich starań, aby proces migracji odbył się bezboleśnie. Nowa architektura pozwala w bardzo łatwy sposób na uruchamianie starych testów na nowej wersji, dzięki wykorzystaniu modułu **vintage**. Dzięki temu możemy migrować nasze testy przyrostowo. Aby zacząć tworzenie nowych testów dodajmy zależność:

<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter-api</artifactId>
    <version>5.0.0</version>
    <scope>test</scope>
</dependency>

### Uruchamianie

Jeśli macie problem z uruchomieniem testów w **IntelliJ** to polecam sprawdzić, [którą wersję artefaktu należy użyć](http://junit.org/junit5/docs/current/user-guide/#running-tests-ide-intellij-idea). U mnie wystąpił wyjątek:

Exception in thread "main" java.lang.NoSuchMethodError: org.junit.platform.commons.util.ReflectionUtils.getDefaultClassLoader()Ljava/lang/ClassLoader;
at org.junit.platform.launcher.core.ServiceLoaderTestEngineRegistry.loadTestEngines(ServiceLoaderTestEngineRegistry.java:30)
at org.junit.platform.launcher.core.LauncherFactory.create(LauncherFactory.java:53)
at com.intellij.junit5.JUnit5IdeaTestRunner.createListeners(JUnit5IdeaTestRunner.java:39)
at com.intellij.rt.execution.junit.IdeaTestRunner$Repeater.startRunnerWithArgs(IdeaTestRunner.java:49)
at com.intellij.rt.execution.junit.JUnitStarter.prepareStreamsAndStart(JUnitStarter.java:242)
at com.intellij.rt.execution.junit.JUnitStarter.main(JUnitStarter.java:70)

Z racji, że aktulanie korzystam z wersji **IntelliJ 2017.1.4** musiałem użyć wersji `5.0.0-M4`. Po tej zmianie wszystko działa poprawnie.

### Podział na moduły

**JUnit 5** został podzielony na trzy moduły:

*   **platform** - launchery i inne elementy związane z infrastrukturą
*   **jupiter** - tutaj znajdują się nowe funkcjonalności
*   **vintage** - do uruchamiania testów napisanych w **JUnit 3** i **JUnit 4**

### Pierwszy test

Nasz pierwszy test niczym nie różni się od testów pisanych we wcześniejszych wersjach, należy jedynie wybrać importy z najnowszej wersji (we wszystkich przykładach używam **AssertJ** do asercji).

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class FirstTest {

    @Test
    void someTest(){
        assertThat("CodeCouple is the best!").contains("best");
    }

}

### Nowy lifecycle

Zmienił się także **lifecycle**, od teraz:

*   `@BeforeAll` - zastępuje `@BeforeClass`
*   `@AfterAll` - zastępuje `@AfterClass`
*   `@BeforeEach` - zastępuje `@Before`
*   `@AfterEach` - zastępuje `@After`

### Informacje o teście

Aby dostać informacje o teście wystarczy do testowej metody przekazać obiekt typu `TestInfo`:

@Test
void someTest(TestInfo testInfo){
    assertThat(testInfo.getTestMethod().get().getName()).isEqualTo("someTest");
}

### AssertThat

`assertThat` nie jest już częścią **JUnitów**. Aby korzystać z tego matchera należy użyć zewnętrznej biblioteki

### Wiele asercji

Wiele asercji w jednym teście jest teraz możliwe dzięki `assertAll.` pierwszy parametr jest nagłówkiem dla testów, następnie przekazujemy lambdy z naszą logiką:

@Test
void someTest(){
    assertAll("CodeCouple",
            () -> assertThat("Code").contains("e"),
            () -> assertThat("Couple").contains("e"));
}

### Wyjątki

Oprócz problemu z nazwami, obsługa wyjątków w testach była problematyczna. Zdarzało się, iż występował inny wyjątek niż oczekiwano, przez co test nie wykonywał się dalej. `ExpectedException` rozwiązywał ten problem, jednakże oczekiwany wyjątek definiowaliśmy w sekcji given, a powinno to być w sekcji then. W wersji 5 otrzymujemy nowy mechanizm do testowania wyjątków -  `assertThrows`.

@Test
void someTest(){
    //When
    IllegalArgumentException exception = assertThrows(IllegalArgumentException.class,
            this::someMethod);

    //Then
    assertThat(exception).isInstanceOf(IllegalArgumentException.class);
    assertThat(exception).hasMessage("Assert Throws");
}

void someMethod(){
    throw new IllegalArgumentException("Assert Throws");
}

### Tagi -> filtrowanie

Testy, które są ze sobą powiązane możemy od teraz złączyć razem korzystając z **tagów**. Następnie podczas uruchamiania testów możemy wybrać tylko te, które należą do danego **tagu**. Przydatne rozwiązanie na oddzielenie testów integracyjnych od jednostkowych:

@Test
void someUnitTest(){
    //Some logic
}

@Test
@Tag("integration")
void someIntegrationTest(){
    //Some logic
}

### Meta-annotations

Jeśli mamy powtarzalne fragmenty z adnotacjami możemy je w prosty sposób spiąć razem używając **meta-annotations**:

@Target({ ElementType.TYPE, ElementType.METHOD })
@Retention(RetentionPolicy.RUNTIME)
@Tag("integration")
@Tag("CodeCouple")
public @interface CodeCouple {
}

@Test
@CodeCouple
void someTest(){
    assertThat("CodeCouple").contains("Code");
}

@Test
@Tag("integration")
@Tag("CodeCouple")
void someSecondTest(){
    assertThat("CodeCouple").contains("Code");
}

### DisplayName

Feature, którego bardzo mi brakowało w poprzedniej wersji. Za każdym razem trzeba było zastanowić się nad nazwą dla testu, aby była na tyle jednoznaczna. Od teraz możemy korzystać z adnotacji `@DisplayName`, która może być użyta na klasie jak i na metodzie:

@DisplayName("FirstTest")
class FirstTest {

    @Test
    @DisplayName("First test method")
    void someTest(){
        assertThat("CodeCouple").contains("Code");
    }

}

### @ParameterizedTest

Największą bolączką **JUnitów** w wersji 4 były testy parametryczne, które były deklarowane w niezbyt intuicyjny sposób. Od teraz zostało to uproszczone, dzięki zastosowaniu adnotacji `@ParametrizedTest` oraz `@ValueSource`. Pierwsza adnotacja oznacza test jako parametryczny, natomiast w drugiej definiujemy parametry do testu. Dane do testu mogą być przekazane na wiele sposobów:

*   `@ValueSource` - wartości wprost
*   `@EnumSource` - wskazujemy klasę enumeratora
*   `@MethodSource` - podajemy nazwę metody
*   `@CsvSource` - dane w formacie CSV
*   `@CsvFileSource` - ścieżka do pliku CSV
*   `@ArgumentsSource` - specjalnie przygotowany provider, który implementuje `ArgumentsProvider`

@ParameterizedTest
@ValueSource(strings = { "Code", "Couple" })
void someTest(String value){
    //Some logic
}

### @RepeatedTest

Jeśli z jakiś powodów potrzebujemy uruchomić test kilkukrotnie, możemy wykorzystać adnotację `@RepeatedTest`:

@RepeatedTest(10)
void someTest(){
    //Some logic
}

### Więcej

W tym wpisie przedstawiłem ciekawsze zmiany z mojego punktu widzenia, oczywiście jest dużo więcej zmian. Więcej można przeczytać [TUTAJ](http://junit.org/junit5/docs/current/user-guide/). Przykłady oczywiście na [GitHubie](https://github.com/kchrusciel/CodeCouple/tree/master/JUnit5).