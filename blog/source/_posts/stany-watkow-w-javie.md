---
title: Stany wątków w Javie
tags:
  - concurrent
  - java
  - threads
id: '3345'
categories:
  - - Java
date: 2018-12-07 12:01:46
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

Stany wątków są częstym pytaniem na rozmowie kwalifikacyjnej z działu wielowątkowości. W **Javie** wątki mogą znajdować się w sześciu stanach. Każda zmiana stanu poprzedzona jest jakimś zdarzeniem. Co to za zdarzenia? Zapraszam do wpisu, aby się o tym dowiedzieć!
<!-- more -->
### Stan

Aby pobrać stan wątku wykorzystujemy wbudowaną metodę `getState()`, która znajduje się w klasie `Thread`:

final Thread newThread = new Thread();
newThread.getState();

Jak napisałem we wstępie, wątek może znajdować się w jednym z sześciu stanów:

![](http://codecouple.pl/wp-content/uploads/2018/11/Screen-Shot-2018-11-14-at-12.39.37-1024x281.png)

### NEW

Wątek w stanie `NEW` znajduje się zaraz po utworzeniu. Posiada on ten stan dopóki nie uruchomimy metody `start()`:

@Test
void shouldReturnNewState() {
    // Given
    final Thread newThread = new Thread();
    // Then
    assertThat(newThread.getState()).isEqualTo(Thread.State.NEW);
}

### RUNNABLE

Po wywołaniu metody `start()` na wątku, zmienia on swój stan z `NEW` na `RUNNABLE`:

@Test
void shouldReturnRunnableState() throws InterruptedException {
    // Given
    final Thread runnableThread = new Thread(() -> {
        assertThat(Thread.currentThread().getState()).isEqualTo(Thread.State.RUNNABLE);
    });
    // When
    runnableThread.start();
    runnableThread.join();
}

### BLOCKED

Wątek w stanie `BLOCKED` może znaleźć się wtedy, kiedy dostęp do sekcji krytycznej jest aktualnie zajęty (znajduje się blokada na monitorze). Innymi słowy, kiedy wątek będzie próbował się dostać do synchronizowanej metody, a wewnątrz znajduje się już inny wątek, to stan zmieniany jest na `BLOCKED`:

@Test
void shouldReturnBlockedState() throws InterruptedException {
    // Given
    final Thread synchronizedThread = new Thread(this::synchronizedMethod);
    final Thread blockedThread = new Thread(this::synchronizedMethod);

    // When
    synchronizedThread.start();
    blockedThread.start();

    // Then
    Thread.sleep(10);
    assertThat(blockedThread.getState()).isEqualTo(Thread.State.BLOCKED);
}

### WAITING

Zmiana wątku na stan `WAITING` odbywa się wtedy, gdy wątek czeka na inne wątki. Nie jest to czekanie jak w sekcji krytycznej, tylko czekanie wywołane przykładowo metodą `wait()` czy `join()`:

@Test
void shouldReturnWaitingState() throws InterruptedException {
    // Given
    final Thread waitingThread = new Thread(this::synchronizedMethod);
    final Thread wrapperThread = new Thread(() -> {
        waitingThread.start();
        try {
            Thread.currentThread().join();
        } catch(InterruptedException e) {
            e.printStackTrace();
        }
    });

    // When
    wrapperThread.start();

    // Then
    Thread.sleep(10);
    assertThat(wrapperThread.getState()).isEqualTo(Thread.State.WAITING);
}

### TIMED\_WAITING

Każdemu z nas przydarzyło się przenieść wątek w stan uśpienia. Posiada on wtedy stan `TIMED_WAITING`. Ten stan pojawia się również, gdy używamy metod do czekania na inne wątki (jak `wait()` czy `join()`), które w parametrach przyjmują wartości czasowe:

@Test
void shouldReturnTimedWaitingState() throws InterruptedException {
    // Given
    final Thread timedWaitingThread = new Thread(() -> {
        try {
            Thread.sleep(1\_000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    });

    // When
    timedWaitingThread.start();

    // Then
    Thread.sleep(10);
    assertThat(timedWaitingThread.getState()).isEqualTo(Thread.State.TIMED\_WAITING);
}

### TERMINATED

Po zakończeniu swojej pracy (czyli po zakończeniu metody `run()`) wątek przechodzi w stan `TERMINATED`:

@Test
void shouldReturnTerminatedState() throws InterruptedException {
    // Given
    final Thread terminatedThread = new Thread(()->{});

    // When
    terminatedThread.start();
    terminatedThread.join();

    // Then
    assertThat(terminatedThread.getState()).isEqualTo(Thread.State.TERMINATED);
}

### Github

Całość jak zawsze na [Githubie](https://github.com/kchrusciel/CodeCouple/tree/master/ThreadState).