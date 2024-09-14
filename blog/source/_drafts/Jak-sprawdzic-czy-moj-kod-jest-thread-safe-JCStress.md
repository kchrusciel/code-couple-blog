---
title: Jak sprawdzić czy mój kod jest thread safe - JCStress
tags: []
id: '4304'
categories:
  - - Java
---

**JCStress** jest kolejnym narzędziem po [**Java Microbenchmark Harness**](https://openjdk.java.net/projects/code-tools/jmh/) stworzony przez [Alekseya Shipileva](https://shipilev.net/). JCStress pozwala nam na sprawdzenie naszego kody pod względem wielowątkowości. Todo
<!-- more -->
### JCStress

asasa

<dependency>
  <groupId>org.openjdk.jcstress</groupId>
  <artifactId>jcstress-core</artifactId>
  <version>0.5</version>
</dependency>

### Piszemy test

Na początku musimy zastanowić się co chcemy **sprawdzić**, w tym wpisie chciałbym sprawdzić czy klasa `AtomicLong` z pakietu `java.util.concurrent` jest rzeczywiście **thread-safe** oraz **atomowa** pod względem operacji **inkrementacji**:

AtomicLong atomicLong = new AtomicLong(5);
atomicLong.incrementAndGet();

#### @JCStressTest

Następnie tworzymy nowy plik z testem. Każda klasa testowa musi być oznaczona adnotacją `@JCStressTest`:

@JCStressTest
public class AtomicLongTest {

   AtomicLong atomicLong = new AtomicLong(5);

}

#### @Outcome

Po przygotowaniu pliku dla **testu**, pora na określenie **oczekiwanych** wartości (możemy to rozumieć jako **asercje**). Oczekiwane wartości określamy za pomocą adnotacji `@Outcome`:

@JCStressTest
@Outcome(id = "6", expect = Expect.FORBIDDEN, desc = "Tylko jeden aktor dokonal inkrementacji")
@Outcome(id = "7", expect = Expect.ACCEPTABLE, desc = "Oboje aktorzy dokonali inkrementacji")
public class AtomicLongTest {

   AtomicLong atomicLong = new AtomicLong(5);

}

**Dodatkowo** z wykorzystaniem adnotacji `@Outcome` możemy ustawić takie rzeczy jak:

*   `id` - wartość pożądana lub nie
*   `expect` - tutaj określamy czy dana wartość jest pożądana lub nie (`ACCEPTABLE`, `ACCEPTABLE_INTERESTING`, `FORBIDDEN`)
*   `desc` - tekst wyświetlony w raporcie

#### @State

Kolejny punkt to określenie, że nasz test będzie przechowywał i wykorzystał stan:

@JCStressTest
@Outcome(id = "6", expect = Expect.FORBIDDEN, desc = "Tylko jeden aktor dokonal inkrementacji")
@Outcome(id = "7", expect = Expect.ACCEPTABLE, desc = "Oboje aktorzy dokonali inkrementacji")
@State
public class AtomicLongTest {

   AtomicLong atomicLong = new AtomicLong(5);

}

#### @Actor

Pora na zlecenie pracy do wykonania. Realizujemy to za pomocą adnotacji `@Actor`, którą możemy rozumieć jako jeden wątek, czyli każda metoda oznacza adnotacją `@Actor` zostanie wykonana w jednym wątku:

@JCStressTest
@Outcome(id = "6", expect = Expect.FORBIDDEN, desc = "Tylko jeden aktor dokonal inkrementacji")
@Outcome(id = "7", expect = Expect.ACCEPTABLE, desc = "Oboje aktorzy dokonali inkrementacji")
public class AtomicLongTest {

   AtomicLong atomicLong = new AtomicLong(5);

   @Actor
   public void actor\_1() {
  atomicLong.incrementAndGet();
   }

   @Actor
   public void actor\_2() {
  atomicLong.incrementAndGet();
   }

}

#### @Arbiter

Jeszcze jedna adnotacja i jesteśmy w domu :D. Adnotacja @Arbiter służy do oznaczenia metody, która zostanie wywołana gdy wszyscy aktorzy zakończą swoją pracę związana ze stanem (w naszym przypadku dokonają inkrementacji):

@JCStressTest
@Outcome(id = "6", expect = Expect.FORBIDDEN, desc = "Tylko jeden aktor dokonal inkrementacji")
@Outcome(id = "7", expect = Expect.ACCEPTABLE, desc = "Oboje aktorzy dokonali inkrementacji")
@State
public class AtomicLongTest {

  AtomicLong atomicLong = new AtomicLong(5);

  @Actor
  public void actor\_1() {
    atomicLong.incrementAndGet();
  }

  @Actor
  public void actor\_2() {
    atomicLong.incrementAndGet();
  }

  @Arbiter
  public void result(L\_Result r) {
    r.r1 = atomicLong.get();
  }

}

### Uruchomienie

Udało nam się napisać test, teraz pora na jego uruchomienie.