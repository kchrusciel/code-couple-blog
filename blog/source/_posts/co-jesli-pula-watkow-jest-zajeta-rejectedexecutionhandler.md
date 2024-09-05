---
title: Co jeśli pula wątków jest zajęta? - RejectedExecutionHandler
tags:
  - java
  - thread
id: '4233'
categories:
  - Java
date: 2020-03-20 12:02:01
author: 'Krzysztof Chruściel'
---

![](https://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

Aby **przyśpieszyć** wydajność naszych aplikacji bardzo często decydujemy się na **zrównoleglenie** pracy. Przy zmianie modelu pracy dostarczamy **pulę wątków**, która będzie odpowiedzialna za **równoległe** wykonywanie zadań. Czasami jednak przy pracy w **wielowątkowym** środowisku może zdarzyć się sytuacja, w której **wysycimy** całą **pulę wątków**. **Java** dostarcza mechanizmy (**polityki**), które instruują pulę jak ma się zachować w przypadku **wysycenia** zasobów.
<!-- more -->
### Tworzenie puli wątków

Najczęstszym sposobem tworzenia **puli** wątków jest wykorzystanie metod fabrykujących dostarczonych przez `Executors`. Przykładowo jeśli chcemy stworzyć pulę z 10 wątkami to wywołujemy metodę:

```java
Executors.newFixedThreadPool(10);
```

Jednakże pod spodem wywoływana jest klasa `ThreadPoolExecutor`:

```java
Executors.newFixedThreadPool(10);

public static ExecutorService newFixedThreadPool(int nThreads) {
    return new ThreadPoolExecutor(nThreads, nThreads,
                                  0L, TimeUnit.MILLISECONDS,
                                  new LinkedBlockingQueue<Runnable>());
}

public ThreadPoolExecutor(int corePoolSize,
                          int maximumPoolSize,
                          long keepAliveTime,
                          TimeUnit unit,
                          BlockingQueue<Runnable> workQueue) {
    this(corePoolSize, maximumPoolSize, keepAliveTime, unit, workQueue,
         Executors.defaultThreadFactory(), defaultHandler);
}

public ThreadPoolExecutor(int corePoolSize,
                              int maximumPoolSize,
                              long keepAliveTime,
                              TimeUnit unit,
                              BlockingQueue workQueue,
                              ThreadFactory threadFactory,
                              RejectedExecutionHandler handler) {
...
}
```

Jak widzicie powyżej, przekazaliśmy tylko wartość 10 mimo to dostaliśmy wiele domyślnych wartości w tym kolejkę, [thread factory](https://codecouple.pl/2018/03/31/threadfactory-czyli-pool-n-thread-m/) oraz **rejected execution handler**.

### Kolejka

Nie każdy o tym wie, ale większość **puli wątków** ma wbudowaną **kolejkę**. Jej zadaniem jest **kolejkowanie** zadań, które aktualnie nie mogą być wykonywane, ponieważ cała **pula** jest aktualnie zajęta. Jednakże należy się zastanowić co się stanie jeśli również **kolejka** jest już pełna?

![](https://codecouple.pl/wp-content/uploads/2020/03/ThreadPool-1024x425.png)

### Zlecanie zadania

Spójrzmy więc do **implementacji** w poszukiwaniu odpowiedzi na to pytanie. **Zlecenie** wykonania zadania wykonuje się za pomocą metody `execute`:

```java
public void execute(Runnable command) {
    if (command == null)
        throw new NullPointerException();
    int c = ctl.get();
    if (workerCountOf(c) < corePoolSize) {
        if (addWorker(command, true))
            return;
        c = ctl.get();
    }
    if (isRunning(c) && workQueue.offer(command)) {
        int recheck = ctl.get();
        if (! isRunning(recheck) && remove(command))
            reject(command);
        else if (workerCountOf(recheck) == 0)
            addWorker(null, false);
    }
    else if (!addWorker(command, false))
        reject(command);
}
```

Jak widzicie, jeśli **pula wątków** jest zamknięta (metoda `isRunning`) lub nie udało dodać się zadania (metoda `addWorker`) wywoływana jest metoda `reject`:

```java
final void reject(Runnable command) {
    handler.rejectedExecution(command, this);
}
```

 Metoda ta na typie implementującym `RejectedExecutionHandler` wywołuje metodę `rejectedExecution`.

### RejectedExecutionHandler

Wiemy już, że podczas zlecenia pracy może zdarzyć się sytuacja, w której nasze zadanie zostanie **odrzucone**. Obsługą tego zadania zajmuje się `RejectedExecutionHandler`:

```java
public interface RejectedExecutionHandler {

    void rejectedExecution(Runnable r, ThreadPoolExecutor executor);

}
```

W przypadku **puli wątków** tworzonych przez klasę `Executors` stosowana jest polityka `AbortPolicy`:

```java
Executors.newFixedThreadPool(10);

public static ExecutorService newFixedThreadPool(int nThreads) {
    return new ThreadPoolExecutor(nThreads, nThreads,
                                  0L, TimeUnit.MILLISECONDS,
                                  new LinkedBlockingQueue<Runnable>());
}

public ThreadPoolExecutor(int corePoolSize,
                          int maximumPoolSize,
                          long keepAliveTime,
                          TimeUnit unit,
                          BlockingQueue<Runnable> workQueue) {
    this(corePoolSize, maximumPoolSize, keepAliveTime, unit, workQueue,
         Executors.defaultThreadFactory(), defaultHandler);
}

private static final RejectedExecutionHandler defaultHandler =
    new AbortPolicy();
```

### AbortPolicy

Jak napisałem powyżej `AbortPolicy` to polityka, która stosowana jest jako domyślna polityka w przypadku tworzenia puli z wykorzystaniem klasy `Executors`. Jej jedynem zadaniem jest rzucenie wyjątku typu `RejectedExecutionException`:

```java
public static class AbortPolicy implements RejectedExecutionHandler {

    public void rejectedExecution(Runnable r, ThreadPoolExecutor e) {
        throw new RejectedExecutionException("Task " + r.toString() +
                                             " rejected from " +
                                             e.toString());
    }
}
```

Można bardzo łatwo to **przetestować**:

```java
@Test
void shouldThrowRejectedExecutionExceptionWithAbortPolicy() {
  // given
  final ThreadPoolExecutor threadPool = new ThreadPoolExecutor(
      1,
      1,
      0, TimeUnit.MILLISECONDS,
      new LinkedBlockingQueue<>(1),
      Executors.defaultThreadFactory(),
      new ThreadPoolExecutor.AbortPolicy()
  );
  // when
  threadPool.submit(() -> sleep(10_000));
  threadPool.submit(() -> sleep(10_000));
  // then
  assertThatExceptionOfType(RejectedExecutionException.class)
      .isThrownBy(() -> threadPool.submit(() -> sleep(10_000)));
}
```

### DiscardPolicy

Kolejną wbudowaną **polityką** (którą można ustawić w konstruktorze `ThreadPoolExecutor`) jest polityka `DiscardPolicy`. Jest ona przeciwieństwem `AbortPolicy` tzn. w przypadku, gdy nowe zadanie nie może być wykonane nie dzieje się nic:

```java
public static class DiscardPolicy implements RejectedExecutionHandler {

    public void rejectedExecution(Runnable r, ThreadPoolExecutor e) {
    }
}
```

A **test** do tej **polityki** mógłby wyglądać tak:

```java
@Test
void shouldNotThrowRejectedExecutionExceptionWithDiscardPolicy() {
  // given
  final ThreadPoolExecutor threadPool = new ThreadPoolExecutor(
      1,
      1,
      0, TimeUnit.MILLISECONDS,
      new LinkedBlockingQueue<>(1),
      Executors.defaultThreadFactory(),
      new ThreadPoolExecutor.DiscardPolicy()
  );
  // when
  threadPool.submit(() -> sleep(10_000));
  threadPool.submit(() -> sleep(10_000));
  // then
  assertThatCode(() -> threadPool.submit(() -> sleep(10_000)))
    .doesNotThrowAnyException();
}
```

### DiscardOldestPolicy

**Polityka** ta jest bardzo podobna do `DiscardPolicy` z tą różnicą, że **najstarsze** zlecone zadanie jest przerywane i w jego miejsce "wskakuje" nasze **najnowsze**:

```java
public static class DiscardOldestPolicy implements RejectedExecutionHandler {

    public void rejectedExecution(Runnable r, ThreadPoolExecutor e) {
        if (!e.isShutdown()) {
            e.getQueue().poll();
            e.execute(r);
        }
    }
}
```

Jest to dobra **polityka** jeśli zależy nam na tym, aby wykonywały się tylko **najnowsze** zadania i możemy sobie pozwolić na przerwanie tych **starszych**. Testy dla tej **polityki**:

```java
@Test
void shouldReturnNewestElementsWithDiscardOldestPolicy() throws InterruptedException {
  // given
  final ThreadPoolExecutor threadPool = new ThreadPoolExecutor(
      1,
      1,
      0, TimeUnit.MILLISECONDS,
      new LinkedBlockingQueue<>(2),
      new ThreadPoolExecutor.DiscardOldestPolicy()
  );
  // when
  threadPool.execute(() -> sleep(100));

  BlockingQueue<String> queue = new LinkedBlockingDeque<>();
  threadPool.execute(() -> queue.offer("Oldest"));
  threadPool.execute(() -> queue.offer("Job"));
  threadPool.execute(() -> queue.offer("Newest"));

  threadPool.awaitTermination(100, TimeUnit.MILLISECONDS);

  List<String> results = new ArrayList<>();
  queue.drainTo(results);

  // then
  assertThat(results).containsExactlyInAnyOrder("Job", "Newest")
      .doesNotContain("Oldest");
}
```

### Caller-Runs Policy

Kolejną wbudowaną **polityką** (którą można ustawić w konstruktorze `ThreadPoolExecutor`) jest polityka `CallerRunsPolicy`. Jest to bardzo ciekawe rozwiązanie, które może pozwolić nam na realizację **throttlingu**. Jest to technika, która pozwala na uniknięcie zbyt **intensywnego** zużycia zasobów, co może mieć swoje konsekwencje jak **spowolnienie** aplikacji lub jej całkowite **wyłączenie**. W przypadku, gdy zlecane jest nowe zadanie i pula jest przepełniona to zadanie wykonywane jest w tym wątku, który to zadanie zlecił. Tym samym blokujemy wątek zlecający zadanie, dzięki temu nowe zadania nie będą dorzucane do **puli**. W tym czasie pula wątków **skończy** część swoich zadań i zacznie przyjmować nowe:

```java
public static class CallerRunsPolicy implements RejectedExecutionHandler {

    public void rejectedExecution(Runnable r, ThreadPoolExecutor e) {
        if (!e.isShutdown()) {
            r.run();
        }
    }
}
```

Spróbujmy napisać do tego testy:

```java
@Test
void shouldBlockCallerThread() {
  final ThreadPoolExecutor threadPool = new ThreadPoolExecutor(
      1,
      1,
      0, TimeUnit.MILLISECONDS,
      new LinkedBlockingQueue<>(1),
      new ThreadPoolExecutor.CallerRunsPolicy());

  threadPool.submit(() -> sleep(1_000));
  threadPool.submit(() -> sleep(1_000));

  long startTime = System.currentTimeMillis();
  threadPool.submit(() -> sleep(1_000));

  long blockedDuration = System.currentTimeMillis() - startTime;

  assertThat(blockedDuration).isGreaterThanOrEqualTo(1_000);
}
```

### Własna polityka

Wiedza o tym jak **odrzucane** są zadania pozwala nam napisać swoją implementację `RejectedExecutionHandler`. Możemy przykładowo **zapisać** do bazy **odrzucone** zadania:

```java
class CustomRejectedExecutionHandler implements RejectedExecutionHandler {

  private final RejectedTasksRepository rejectedTasksRepository;

  CustomRejectedExecutionHandler(final RejectedTasksRepository rejectedTasksRepository) {
    this.rejectedTasksRepository = rejectedTasksRepository;
  }

  @Override
  public void rejectedExecution(final Runnable r, final ThreadPoolExecutor executor) {
    rejectedTasksRepository.save(r.toString());
  }
}
```

Ostatni **test** dotyczy naszej **polityki**:

```java
@Test
void shouldSaveRejectedTasksWithCustomPolicy() {
  // given
  RejectedTasksRepository repository = Mockito.mock(RejectedTasksRepository.class);
  final ThreadPoolExecutor threadPool = new ThreadPoolExecutor(
      1,
      1,
      0, TimeUnit.MILLISECONDS,
      new LinkedBlockingQueue<>(1),
      new CustomRejectedExecutionHandler(repository)
  );
  // when
  threadPool.submit(() -> sleep(10_000));
  threadPool.submit(() -> sleep(10_000));
  threadPool.submit(() -> sleep(10_000));

  // then
  verify(repository).save(anyString());
}
```

### Github

Całość jak zawsze na [Githubie](https://github.com/kchrusciel/CodeCouple/tree/master/RejectedExecutionHandler).