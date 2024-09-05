---
title: CompletableFuture - dlaczego, po co, jak?
tags:
  - async
  - completablefuture
  - java
id: '2838'
categories:
  - - Java
date: 2018-04-06 12:01:17
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

Klasa **CompletableFuture** jest z nami od dłuższego czasu, jednakże ostatnimi czasy stosowałem ją bardzo często. Podczas swojej pracy postanowiłem spisać między innymi na co warto zwrócić szczególną uwagę stosując **CompletableFuture**, jak działają poszczególne transformacje oraz jak obsłużyć sytuacje wyjątkow, zapraszam!
<!-- more -->
## CompletableFuture

 \* @author Doug Lea
 \* @since 1.8
 \*/
public class CompletableFuture<T> implements Future<T>, CompletionStage<T> {
CompletableFuture jest to operacja, która zaczęła się gdzieś w tle, ale jeszcze się potencjalnie nie skończyła. Podobnie jak Callable operacja ta ma określony typ zwracany, na przykład String lub Integer. Ponadto implementuje dwa interfejsy Future i CompletionStage.

CompletableFuture<String> task = CompletableFuture.completedFuture("42");
Operacja ta, może zakończyć się poprzez zwrócenie wartości lub wyjątku.

CompletableFuture<String> taskWithValue = CompletableFuture.supplyAsync(() -> {
    return "Value"; //zwraca wartość
});

CompletableFuture<String> taskWithException = CompletableFuture.supplyAsync(() -> {
    throw new IllegalArgumentException(); //zwraca wyjątek
});

W przeciwieństwie do rozwiązania `Future`, `CompletableFuture` pozwala nam składać transformacje w nieblokujący sposób.

Callable<String> blocking = () -> "toChange";
String resultOfCall = blocking.call(); //blokujące
resultOfCall.toUpperCase();

CompletableFuture<String> nonBlocking = CompletableFuture.supplyAsync(() -> "toChange");
nonBlocking.thenApply(String::toUpperCase); //nieblokujące
nonBlocking.get();

Jeśli nie określimy, aby nowa transformacja odbyła się asynchronicznie, odbędzie się ona na tym samym wątku, który wykonywał pierwszą transformację. Dzięki takiemu rozwiązaniu zyskujemy optymalizację czasową związaną z brakiem potrzeby zmiany wątku.

### Tworzenie

Klasa `CompletableFuture` dostarcza statyczne metody do tworzenia samej siebie:

*   `supplyAsync(suppiler)` - zwraca `CompletableFuture`, który zostanie wywołany w `ForkJoinPool`
*   `supplyAsync(suppiler, executors)` - zwraca `CompletableFuture`, który zostanie wywołany w podanej puli wątków executors
*   `runAsync(runnable)` - zwraca `CompletableFuture`, który zostanie wywołany w `ForkJoinPool`
*   `runAsync(runnable, executors)` - zwraca `CompletableFuture`, który zostanie wywołany w podanej puli wątków executors
*   `completedFuture(value)` - zwraca `CompletableFuture`, który jest już zakończony i posiada wartość
*   `allOf(CompletableFuture<?>…​ cfs)` - zwraca `CompletableFuture` **UWAGA!** typu `<Void>` po zakończeniu wszystkich przekazanych `CompletableFuture`
*   `anyOf(CompletableFuture<?>…​ cfs)` - zwraca `CompletableFuture` **UWAGA!** typu `<Object>` po zakończeniu dowolnego przekazanego `CompletableFuture`

Ponadto `CompletableFuture` można tworzyć przez wykonywanie tranformacji.

### Metody

**CompletableFuture** oferuje trzy podstawowe metody:

*   `complete` - oznaczamy `CompletableFuture` jako skończony
*   `completedFuture` - zwracam wartość od razu (na przykład z cache)
*   `completeExceptionally` - opakowujemy wyjątek w `CompletableFuture`

String getStringFromWebService() {
    String stringFromCache = getStringFromCache();

    if (StringUtils.isNotBlank(stringFromCache)) {
        return stringFromCache;
    }

    try {
        return WebService.readString();
    } catch (Exception e) {
        return "Default Value";
    }
}

//Asynchroniczna metoda
CompletableFuture<String> getStringFromWebServiceAsync() {
    String stringFromCache = getStringFromCache();

    if (StringUtils.isNotBlank(stringFromCache)) {
        //oznaczamy \`CompletableFuture\` jako skończony
        return CompletableFuture.completedFuture(stringFromCache);
    }

    try {
        CompletableFuture<String> async = new CompletableFuture<>();
        String stringFromWebService = WebService.readString();

        //oznaczamy \`CompletableFuture\` jako skończony
        async.complete(stringFromWebService);

        return async;
    } catch (Exception e) {
        CompletableFuture<String> async = new CompletableFuture<>();

        //opakowujemy wyjątek w \`CompletableFuture\`
        async.completeExceptionally(e);

        return async;
    }
}

Oczywiście nie korzystamy z `CompletableFuture` w sposób jaki jest pokazany powyżej. Wykorzystujemy do tego celu tranformacje.

### Transformacje

Klasa `CompletableFuture` dostarcza około **50 metod**. Pomimo tak dużej ilości większość metod stworzonych jest według wzorców:

*   **apply** metoda, która przyjmuje `Function`
*   **accept** metoda, która przyjmuje `Consumer`
*   **run** metoda, która przyjmuje `Runnable`

Nowa pula wątków:

*   **async** oznacza uruchomienie wykonywania w `ForkJoinPool`
*   **async(Executors)** oznacza uruchomienie wykonywania na innej puli wątków

Więcej wzorców:

*   **then** - służy do łączenia tranformacji - na przykład `thenApply` lub `thenAccept`
*   **either** - wybierz pierwszy wynik - na przykład z dwóch `CompletableFuture`
*   **both** - wykonaj tranformację jeśli skończą się oba wcześniejsze `CompletableFuture`
*   **combine** - złącz pierwszy wynik z drugim, aby powstał kolejny wynik, działa jak operator `zip`
*   **compose** - działa jak operator `flatMap`

### thenApply i thenApplyAsync

Są to metody, które służą do dodania kolejnych tranformacji. Transformacje te są typu `Function`, czyli przyjmują i zwracają wartość. Wersja **async** przyjmuje własną pulę wątków.

CompletableFuture<String> task = CompletableFuture.supplyAsync(() -> "some task");

task.thenApply((String someString) -> "Value returned");
task.thenApplyAsync((String someString) -> "ForkJoinPool");
task.thenApplyAsync((String someString) -> "Value returned", executors);

### thenAccept i thenAcceptAsync

Są to metody, które służą do dodania kolejnych tranformacji. Transformacje te są typu `Consumer`, czyli przyjmują wartość, natomiast nic nie zwracają. Wersja **async** przyjmuje własną pulę wątków.

CompletableFuture<String> task = CompletableFuture.supplyAsync(() -> "some task");

task.thenAccept((String someString) -> System.out.println("Value consumed"));
task.thenAcceptAsync((String someString) -> System.out.println("ForkJoinPool"));
task.thenAcceptAsync((String someString) -> System.out.println("Value consumed"), executors);

### thenRun i thenRunAsync

Są to metody, które służą do dodania kolejnych tranformacji. Transformacje te są typu `Runnable`, czyli nie przyjmują wartość oraz nie zwracają wartości. Wersja **async** przyjmuje własną pulę wątków.

CompletableFuture<String> task = CompletableFuture.supplyAsync(() -> "some task");

task.thenRun(()->{
    String threadName = Thread.currentThread().getName();
    System.out.println("Thread name: " + threadName);
});

task.thenRunAsync(()->{
    String threadName = Thread.currentThread().getName();
    System.out.println("ForkJoinPool: " + threadName);
});

task.thenRunAsync(()->{
    String threadName = Thread.currentThread().getName();
    System.out.println("Thread name: " + threadName);
}, executors);

### either

Transformacja zawarta w `*Either` wykonywana jest na pierwszym zakończonym wyniku. Metoda ta dostępna jest dla wszystkich wzorców: `acceptEither`, `applyToEither` oraz `runAfterEither`.

CompletableFuture<String> task = CompletableFuture.supplyAsync(() -> "some task");
CompletableFuture<String> otherTask = CompletableFuture.supplyAsync(() -> "some other task");

task.acceptEither(otherTask, x -> {
    String threadName = Thread.currentThread().getName();
    System.out.println(threadName + " " + x);
});

### both

Transformacja zawarta w `*Both` wykonywana jest na wynikach dwóch wcześniejszych `CompletableFuture`. Metoda ta dostępna jest dla wzorców: `thenAcceptBoth` oraz `runAfterBoth`.

CompletableFuture<String> task = CompletableFuture.supplyAsync(() -> "some task");
CompletableFuture<String> otherTask = CompletableFuture.supplyAsync(() -> "some other task");

task.thenAcceptBoth(otherTask, (x, y) -> System.out.println(x + " " + y));

### combine

Transformacja zawarta w `thenCombine` podobnie jak `*Both` wykonywana jest na wynikach dwóch wcześniejszych `CompletableFuture`. Różnicą w stosunku do `*Both` jest to, iż zwracana jest wartość, ponieważ drugim paramterem jest `BiFunction`.

CompletableFuture<String> task = CompletableFuture.supplyAsync(() -> "some task");
CompletableFuture<String> otherTask = CompletableFuture.supplyAsync(() -> "some other task");

CompletableFuture<String> combine = task.thenCombine(otherTask, (x, y) -> x + " " + y);

### compose

Transformacja zawarta w `thenCompose` działa na zasadzie operatora `flatMap`. Potrafi ona "spłaszczyć" wywołanie innego `CompletableFuture`. Dzięki tej tranformacji unikamy **Callback Hell**.

...
CompletableFuture<String> task = CompletableFuture.supplyAsync(() -> "some task");
task.thenCompose(otherString -> doOtherTask(otherString));
task.join();
...
}

CompletableFuture<String> doOtherTask(String string) {
    return CompletableFuture.completedFuture(string);
}

### Pobranie wartości

Pobranie wartości odbywa się w sposób blokujący, tak samo jak w `Future` przy wykorzystaniu metody `get`.

*   `get()` - blokujące wywołanie, które rzuca checked exceptions takie jak `ExecutionException` oraz `InterruptedException`
*   `get(timeout, timeunit)` - blokujące wywołanie, które rzuca checked exceptions takie jak `ExecutionException`, `InterruptedException` oraz `TimeoutException`, jeśli zostanie przekroczony czas zadeklarowany w metodzie
*   `getNow(valueIfAbset)` - blokujące wywołanie, które rzuca unchecked exceptions takie jak `CompletionException` oraz `CancellationException`. Zwraca wartość domyślną jeśli dany `CompletableFuture` jeszcze się nie zakończył
*   `join()` - działa jak `get()`, jednakże rzuca unchecked exception `CompletionException`

### Przerwanie pracy

Jeśli chcemy przerwać działanie `CompletableFuture` możemy zakończyć pulę wątków. Innym rozwiązaniem, bardziej związanym z `CompletableFuture` jest wywołanie metody `cancel`. Przerywa ona działanie aktualnego `CompletableFuture`, który w następstwie zwróci `CancellationException`. Jeśli istnieją inne zależne tranformacje kończą się one z wyjątkiem `CompletionException` spowodowanym poprzednim `CancellationException`.

CompletableFuture<String> task = CompletableFuture.supplyAsync(() -> "some task");
task.cancel(true);

### Wyjątki

Jeśli podczas wykonywania transformacji wystąpi wyjątek, podobnie jak w kodzie imperatywnym jest on propagowany do "samej góry" wywołania. Obsługa wyjątków odbywa się poprzez tranformację `exceptionally`:

CompletableFuture<String> task = CompletableFuture.supplyAsync(() -> "some task");

task.exceptionally((throwable -> "default value"));

Wyjątki możemy także obsłużyć przy pomocy metody `handle`:

CompletableFuture<String> task = CompletableFuture.supplyAsync(() -> "some task");

task.handle((x, throwable) -> {
    if (throwable != null) {
        return "default value";
    }
    return x + "some value";
});

Jeśli w przeciwieństwie do metody `handle` nie chcemy zwracać żadnej wartości możemy wykorzystać `whenComplete`:

CompletableFuture<String> task = CompletableFuture.supplyAsync(() -> "some task");

task.whenComplete((x, throwable) -> {
    if (throwable != null) {
        System.out.println("Exception occurs");
    }
    System.out.println(x);
});

### Więcej metod

Istnieje też kilka metod pomocniczych:

*   `obtrudeException(exception)` - ustawia wyjątek dla `CompletableFuture` niezależnie od tego, czy się zakończył, czy nie
*   `obtrudeValue(value)` - ustawia wartość dla `CompletableFuture` niezależnie od tego, czy się zakończył, czy nie
*   `toCompletableFuture()` - zwraca `CompletableFuture`
*   `getNumberOfDependents()` - oblicza liczbę niezakończonych jeszcze tranformacji na `CompletableFuture`
*   `isCancelled()` - sprawdza, czy `CompletableFuture` został przerwany
*   `isCompletedExceptionally()` - sprawdza, czy `CompletableFuture` został przerwany przez wyjątek
*   `isDone()` - sprawdza, czy `CompletableFuture` został zakończony