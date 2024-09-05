---
title: Executors - tworzymy własną pulę wątków
tags:
  - executors
  - java
  - threadpool
id: '2843'
categories:
  - - Java
date: 2018-04-13 12:01:58
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

Podczas tworzenia **zadań asynchronicznych** możemy wskazać własną **pulę wątków**. Takie rozwiązanie jest lepsze niż operowanie na domyślnej **puli wątków**, ponieważ pozwala nam kontrolować jej parametry. **Java** dostarcza przyjazny mechanizm `Executors`, który umożliwia tworzenie **puli wątków**.
<!-- more -->
### Executors

Aby ułatwić tworzenie wątków, od **Javy 1.5** pojawiła się klasa `Executors`, która posiada metody statyczne do tworzeni puli wątków.

### Pojedynczy wątek

Metodą ułatwiającą stworzenie nowego, pojedynczego wątku jest `newSingleThreadExecutor`:

Executors.newSingleThreadExecutor()

### Określona ilość

Jeśli potrzebujemy pulę wątków o określonej wielkości możemy wykorzystać metodę `newFixedThreadPool`, która jako parametr przyjmuje ilość wątków:

Executors.newFixedThreadPool(int numberOfThreads)

### Bierz ile chcesz

Kolejną ciekawą pulą wątków jest `newCachedThreadPool`. Jest to **pula**, która nie ma **określonego rozmiaru.** Jeśli potrzebuje ona kolejnych wątków, po prostu je tworzy. Jeśli któryś z wątków zakończył swoją prace, będzie on użyty ponownie. Jeśli jakiś wątek jest "bezrobotny" powyżej **60 sekund**, jest zamykany i usuwany z puli. Dzięki temu mamy pewność, iż w odpowiedni sposób wykorzystujemy zasoby. **Pula** ta idealnie nadaje się do **krótkich zadań**, ponieważ nowe wątki nie są tworzone, a jedynie reużywane z istniejącej już puli:

Executors.newCachedThreadPool()

### Uruchom później

Jeśli istnieje powód, dla którego chcemy odpalić nasze zadania z opóźnieniem, możemy zastosować metodę `newScheduledThreadPool`, która jako parametr przyjmuje ilość wątków, a w wyniku zwraca `ScheduledExecutorService` :

ScheduledExecutorService scheduledExecutorService = Executors.newScheduledThreadPool(10);
ScheduledFuture<String> schedule = scheduledExecutorService.schedule(myTask, 10, TimeUnit.SECONDS);
schedule.get(); // result after 10 seconds

### Nowa abstrakcja dla ForkJoinPool

Nowością od **Javy 8** jest metoda do tworzenia puli wątków `newWorkStealingPool`.

Executors.newWorkStealingPool()

Jest to **pula**, która korzysta z algorytmu **work-stealing**. Algorytm ten rozdziela pracę na mniejsze podzadania, które trafiają na kolejkę. Podzadania te wykonywane są w innych wątkach, które jak skończą swoją pracę, "kradną" pracę innych wątków z kolejki i ją wykonują. Jeśli zastanowimy się na sposobem działania tej **puli wątków** od razu na myśl przychodzi nam `ForkJoinPool`. Dobrze, sprawdźmy więc implementację:

/\*\*
 \* Creates a work-stealing thread pool using all
 \* {@link Runtime#availableProcessors available processors}
 \* as its target parallelism level.
 \* @return the newly created thread pool
 \* @see #newWorkStealingPool(int)
 \* @since 1.8
 \*/
public static ExecutorService newWorkStealingPool() {
    return new ForkJoinPool
        (Runtime.getRuntime().availableProcessors(),
         ForkJoinPool.defaultForkJoinWorkerThreadFactory,
         null, true);
}

Rzeczywiście, pod spodem pula ta korzysta z `ForkJoinPool`, jednakże dostarcza nam o wiele bardziej przyjazne **API** do tworzenia **puli** takiego rodzaju. **Pulę** tę warto stosować wtedy, gdy mamy do wykonania pracę, którą można łatwo podzielić na mniejsze podzadania.

### ThreadFactory

Większość **metod fabrykujących** występuje w dwóch wersjach, podstawowej opisanej powyżej oraz wersji, która przyjmuje `ThreadFactory`. Więcej o `ThreadFactory` można [przeczytać w moim poprzednim artykule](http://codecouple.pl/2018/03/31/threadfactory-czyli-pool-n-thread-m/).