---
title: ThreadFactory, czyli pool-n-thread-m
tags:
  - java
  - thread factory
  - threadpool
id: '2823'
categories:
  - - Java
date: 2018-03-31 10:07:24
---

![](http://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

Jestem zdania, że nie ma co na siłę dorzucać wielowątkowości do każdej tworzonej aplikacji, jednakże czasem dostajemy zadanie, w którym musimy zrównoleglić wykonywanie zadań. "Dobra" wielowątkowość może poprawić wydajność i czas przetwarzania naszej aplikacji, jednakże taki przywilej niesie ze sobą także różne utrudnienia takie jak choćby debugowanie. Czy możemy to jakoś uprościć?
<!-- more -->
### ExecutorService

Aby zrównoleglić wykonywanie zadań musimy przygotować pulę wątków. Najczęściej robimy to dzięki wykorzystaniu klasy **Executors**:

ExecutorService executorService = Executors.newFixedThreadPool(numberOfThreads);

### pool-n-thread-m

Wyobraźmy sobie teraz sytuację, w której nasz kod zachowuje się w "dziwny" sposób. Mamy kilka sposobów znajdowania błędów, jednym z nim jest **zrzut wątków**:

pool-1-thread-2
pool-2-thread-3
pool-1-thread-0
pool-3-thread-1
pool-3-thread-2
pool-1-thread-1

Niestety, przeglądanie takiego zrzutu wątków nic nam nie mówi. Rozwiązaniem tego problemu jest `ThreadFactory`.

### ThreadFactory

`ThreadFactory` jak sama nazwa mówi jest fabryką pomocniczą do tworzenia wątków. Jeśli przyjrzymy się metodzie `Executors.newFixedThreadPool`, okazuje się, że istnieje ona także w wersji, która przyjmuje `ThreadFactory`. Samo tworzenie `ThreadFactory` jest bardzo uciążliwe w kodzie, jednakże biblioteka **Guava** dostarcza bardzo fajny builder `ThreadFactoryBuilder`. Wykorzystajmy teraz tego **builder'a**:

ThreadFactory factory = new ThreadFactoryBuilder()
        .setNameFormat("task-name-%d")
        .setDaemon(true)
        .build();

ExecutorService executorService = Executors.newFixedThreadPool(numberOfThread, factory);

W `ThreadFactory` ustawiliśmy format dla nazwy wątku, który domyślnie wygląda tak: `pool-n-thread-m`, gdzie `n` to numer **puli,** a `m` to numer **wątku**. Ponadto, ustawiliśmy naszemu **factory** flagę **Deamon** na wartość **true**. Wątek, który jest **demoniczny** zarządza innymi wątkami w tym samym procesie.

/\*\*
 \* Sets daemon or not for new threads created with this ThreadFactory.
 \*
 \* @param daemon whether or not new Threads created with this ThreadFactory will be daemon threads
 \* @return this for the builder pattern
 \*/
public ThreadFactoryBuilder setDaemon(boolean daemon) {
  this.daemon = daemon;
  return this;
}

> Flaga daemon wyznacza moment wyłączenia **JVM'a** - gdy kończy się ostatni wątek **non-daemon**

Teraz jeśli zrobimy **zrzut wątków** (z już ustawionymi nazwami zadań w `setNameFormat(String)`) to zyskujemy na czytelności:

importing-logs-2
some-operation-3
importing-logs-0
reading-from-db-1
reading-from-db-2
importing-logs-1