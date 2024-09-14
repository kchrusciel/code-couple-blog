---
title: CyclicBarrier - cykliczny synchronizator
tags:
  - concurrent
  - CyclicBarrier
  - synchronizer
id: '3327'
categories:
  - - Java
date: 2018-11-23 12:01:40
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

Ostatnio poznanym sychronizatorem pracy był `CountDownLatch`. Był to bezpieczny wątkowo mechanizm odliczania, który pozwala uruchomić zadanie, gdy licznik wynosi zero. Podobnym sposobem synchronizacji pracy jest `CyclicBarier`. Różni się on nieznacznie od `CountDownLatch`, ale po szczegóły zapraszam do wpisu.
<!-- more -->
### Problem

Podobnie jak w przypadku `CountDownLatch` posiadamy trzy serwisy zliczające sumę użytkowników. Po zliczeniu tej sumy chcielibyśmy policzyć jej średnią:

![](http://codecouple.pl/wp-content/uploads/2018/11/Screen-Shot-2018-11-13-at-19.03.39-1024x403.png)

Problemem w tym przypadku jest taki, iż chcielibyśmy zliczyć sumę dopiero, gdy wszystkie serwisy zakończą swoją prace. Dodatkowo nie chcemy, aby po wykonaniu zliczania sumy na naszym serwisie była wykonywana jakakolwiek praca (na przykład następne obliczanie użytkowników). Może ona się wykonać dopiero, gdy rozpocznie się obliczanie średniej.

### CyclicBarrier

Jednym z rozwiązań tego problemu może być synchronizator jakim jest `CyclicBarrier`. W konstruktorze przyjmuje on informacje ile zadań musi zostać wykonanych, aby dodatkowa logika została uruchomiona:

CyclicBarrier cyclicBarrier = new CyclicBarrier(3, avgCounter);

Tym razem to nasze zadanie po wykonaniu swojej pracy czeka na "barierze" na inne zadania:

cyclicBarrier.await();

Dopiero, gdy wszystkie zadania zakończyły pracę uruchamiane jest zadanie wskazane w konstruktorze `CyclicBarrier`. Zobaczymy to na przykładzie:

![](http://codecouple.pl/wp-content/uploads/2018/11/Screen-Shot-2018-11-14-at-09.21.42-1024x531.png)

Pierwsze zadanie się skończyło, wywoływana jest metoda `await()`, która czeka na pozostałe zadania:

![](http://codecouple.pl/wp-content/uploads/2018/11/Screen-Shot-2018-11-14-at-09.45.15-1024x534.png)

Drugie i trzecie zadanie również się zakończyły (po zakończeniu zostały wywołane metody `await()`), blokada na zadaniu `avgCounter` została zwolniona i uruchomiła się logika odpowiedzialna za zliczanie średniej:

![](http://codecouple.pl/wp-content/uploads/2018/11/Screen-Shot-2018-11-14-at-09.57.38-1024x425.png)

### Bezpieczeństwo

Podobnie jak w przypadku `CountDownLatch` powinniśmy używać metody `await()` z timeout. Może zdarzyć się sytuacja, w której zadanie nigdy się nie zakończy, a wtedy zablokujemy pozostałe wątki. Druga wersja metody, która przyjmuje maksymalny czas oczekiwania `boolean await(long timeout, TimeUnit unit)`.

### Różnica z CountDownLatch

Różnica pomiędzy tymi dwoma synchronizatorami jest taka, że w `CountDownLatch` to dodatkowy **wątek** (w naszym przykładzie `AvgCounter`) blokował się aż wszystkie **wątki** zakończą pracę.

W przypadku `CyclicBarrier` to **wątki**, które wykonały swoją pracę czekają (na "barierze") na pozostałe. Dopiero po zakończeniu wykonywania pracy przez wszystkie wątki uruchamiane jest nowe zadanie.

### Cykliczność

Nie bez przyczyny synchronizator ten ma w nazwie **cyclic**. Po wykonaniu jednego cyklu, którym jest zakończenie pracy przekazanej w konstruktorze, możemy ponownie tą cykliczną barierę wykorzystać.

### Github

Całość jak zawsze na [GitHubie](https://github.com/kchrusciel/CodeCouple/tree/master/CyclicBarrier).