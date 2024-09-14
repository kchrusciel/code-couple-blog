---
title: '#1 Java Performance - Stackless Exceptions'
tags:
  - java
  - JIT
  - jvm
  - performance
id: '1384'
categories:
  - - Java
  - - JVM
date: 2017-02-03 13:39:04
author: 'Krzysztof Chruściel'
---

[![java-logo](http://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)](http://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

Dziś krótszy wpis jednakże pierwszy z serii "**Java Performance**", w której będę opisywał rozwiązania związane z wydajnością **JVM'a** oraz **Javy**. Pierwszy wpis dotyczy optymalizacji stosu wywołań (ang. _stack trace_), który jest wywoływany w momencie wystąpienia **wyjątku**.
<!-- more -->
Do testów posłużyłem się **JMH.** Niebawem opiszę jak wykorzystywać go do przeprowadzania **benchamarków,** dzięki którym można się dowiedzieć, które rozwiązanie jest szybsze. Jak wspominałem we wstępie w momencie wystąpienia wyjątku wywoływany jest stos wywołań:

Exception in thread "main" benchmarks.ExampleException: CodeCouple.pl - Exception
 at Test.main(Test.java:10)
 at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
 at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
 at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
 at java.lang.reflect.Method.invoke(Method.java:498)
 at com.intellij.rt.execution.application.AppMain.main(AppMain.java:147)

Znajdują się tu wpisy **ramek** (ang. _frames_), które przechowywane są na **stosie** (ang. _stack_) JVM. Wyświetlane są one w takiej kolejność w jakiej przechowywane są na stosie czyli **FIFO** (ang. _first in first out_). Sam stos wywołań jest przydatny w momencie, gdy chcemy dowiedzieć się jaka była ścieżka wystąpienia błędu. Jedna z informacji, która jest dla nas przydatna to **exception message**:

Exception in thread "main" org.openjdk.jmh.runner.RunnerException:

**CodeCouple.pl - Exception**

W klasie `Exception` znajduję się metoda `fillInStackTrace`, która odpowiedzialna jest za wypełnianie stosu wywołań. Tworząc nasz wyjątek możemy tą metodę nadpisać:

public class ExampleException extends Exception {
    public ExampleException(String message) {
        super(message);
    }

    @Override
    public synchronized Throwable fillInStackTrace() {
        return this;
    }
}

Dzięki temu podczas wywołania wyjątku dostaniemy tylko **exception** **message** bez stosu wywołań co jest pożądanym zachowaniem jeśli chcemy poprawić wydajność:

Exception in thread "main" benchmarks.ExampleException:

**CodeCouple.pl - Exception**

Dla porównania czasów wykonań użyłem narzędzia **JMH**. Testy prezentowały się w następujący sposób:

@Warmup(iterations = 5, time = 1000, timeUnit = TimeUnit.MILLISECONDS)
@Measurement(iterations = 10, time = 1000, timeUnit = TimeUnit.MILLISECONDS)
@BenchmarkMode(Mode.AverageTime)
@OutputTimeUnit(TimeUnit.MICROSECONDS)
@Fork(1)
@State(Scope.Benchmark)
public class MyBenchmark {

    @Benchmark
    public void withoutStacktrace() {
        try {
            throw new ExampleException( "CodeCouple" );
        } catch (ExampleException e) {

        }
    }

    @Benchmark
    public void withStacktrace() {
        try {
            throw new SimpleException( "CodeCouple" );
        } catch (SimpleException e) {

        }
    }
}

Natomiast nas interesują same wyniki:

\[table\] Benchmark,Mode,Cnt,Score,Error,Units MyBenchmark.withStacktrace,avgt,10,**1.612**,0.044,us/op MyBenchmark.withoutStacktrace,avgt,10,**0.018**,0.001,us/op \[/table\]

Na podstawie tych wyników można określić, iż wywołanie wyjątku, który jest **Stackless** jest około **90** razy szybsze.

Warto wspomnieć że twórcy **JIT'a** (kompilator wbudowany w **JVM**), przewidzieli tą optymalizację (jest włączona domyślnie) i w przypadku bardzo częstego występowania danego wyjątku niweluje ona stos wywołań. Opcje tą można wyłączyć wykorzystując flagę `-XX:-OmitStackTraceInFastThrow`.  Na czas testów flaga ta została wyłączona.

> The compiler in the server VM now provides correct stack backtraces for all "cold" built-in exceptions. For performance purposes, when such an exception is thrown a few times, the method may be recompiled. After recompilation, the compiler may choose a faster tactic using preallocated exceptions that do not provide a stack trace. To disable completely the use of preallocated exceptions, use this new flag: `-XX:-OmitStackTraceInFastThrow`.