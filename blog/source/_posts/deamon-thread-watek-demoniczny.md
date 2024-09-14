---
title: Daemon Thread - wątek demoniczny
tags:
  - concurrent
  - java
  - thread
id: '3387'
categories:
  - - Java
date: 2018-12-21 12:01:23
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

Chociaż tytuł wpisu brzmi bardzo **złowieszczo** to nie zapowiada on niczego złego. Pojęcie wątków **demonicznych** pojawiło się już we [wpisie związanym z ThreadFactory](http://codecouple.pl/2018/03/31/threadfactory-czyli-pool-n-thread-m/), natomiast dziś chciałbym przedstawić wam jak tworzyć takie wątki. Ponadto odpowiemy sobie na pytanie kiedy warto stosować ten typ zadań.
<!-- more -->
### Różnice

W naszych aplikacjach mamy dwa typy **wątków**. Jednym z nich są wątki **klienckie** (na przykład wątek **main**), natomiast drugim typem są wątki **demoniczne**. Maszyna wirtualna (**JVM**) kończy swoją pracę wtedy, gdy zakończy się ostatni wątek kliencki (**niedemoniczny**). Oznacza to, że jeśli w naszej aplikacji mamy wątki typu **demon**, aplikacja zamknie się pomimo tego, że jest wykonywana tam jakaś praca. Znając tą cechę, należy pamiętać, aby nie umieszczać tam żadnych zadań związanych z **I/O**!

### Zastosowanie

Najczęściej w takich **wątkach** realizowane są zadania niezwiązane ściśle z logiką biznesową. **Demony** wykorzystywane są przez **JVM** do odśmiecania pamięci czy też do przechowywania **referencji** obiektów do usunięcia. W naszym przypadku możemy umieszczać tam zadania związane z **monitoringiem** aplikacji, który może być zakończony w dowolnym momencie.

### Tworzenie

Określenie czy wątek ma być **demoniczny** musi odbyć się przed jego utworzeniem:

Thread daemonThread = new Thread(job);
daemonThread.setDaemon(true);
daemonThread.start();

Jeśli natomiast spróbujemy to zrobić po uruchomieniu wątku, dostaniemy wyjątek `IllegalThreadStateException`:

@Test
void shouldThrowIllegalThreadStateException() {
    // Given
    Thread thread = new Thread(() -> {
        try {
            Thread.sleep(10);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    });
    // When
    thread.start();
    // Then
    assertThrows(IllegalThreadStateException.class, () -> thread.setDaemon(true));
}

Typ **wątku** **dziedziczony** jest z **wątku** z jakiego został stworzony. Głównym **wątkiem** jest **wątek** **main**, który jest **wątkiem** klienckim. Oznacza to, że każdy tworzonym **wątek** jest domyślnie **wątkiem** klienckim:

@Test
void shouldCreateClientThread() {
    // Given
    Thread thread = new Thread(() -> {});
    thread.start();
    // When
    boolean daemon = thread.isDaemon();
    // Then
    assertThat(daemon).isFalse();
}

### Testowanie

Dodajmy jeszcze prosty **test** sprawdzający czy **wątek** na pewno został utworzony jako **demoniczny**:

@Test
void shouldCreateDaemonThreadFromDaemonThread() throws InterruptedException {
    // Given
    DaemonThread thread = new DaemonThread();
    thread.setDaemon(true);
    thread.start();
    thread.join();
    // When
    boolean daemon = thread.getDaemon().isDaemon();
    // Then
    assertThat(daemon).isTrue();
}

@Test
void shouldCreateDaemonThread() {
    // Given
    Thread thread = new Thread(() -> {});
    thread.setDaemon(true);
    thread.start();
    // When
    boolean daemon = thread.isDaemon();
    // Then
    assertThat(daemon).isTrue();
}

### Pula wątków

Jak pisałem we wstępie, kiedyś pojawił się już artykuł o [ThreadFactory](http://codecouple.pl/2018/03/31/threadfactory-czyli-pool-n-thread-m/). Dzięki tej klasie, możemy określić, aby została utworzona **pula** **wątków**, w której każdy **wątek** jest **demoniczny**:

ThreadFactory factory = new ThreadFactoryBuilder()
        .setNameFormat("task-name-%d")
        .setDaemon(true)
        .build();

ExecutorService executorService = Executors.newFixedThreadPool(numberOfThread, factory);

### Github

Całość jak zawsze na [GitHubie](https://github.com/kchrusciel/CodeCouple/tree/master/DaemonThread).