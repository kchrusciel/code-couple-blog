---
title: CountDownLatch - blokujące odliczanie
tags:
  - concurrent
  - countdownlatch
  - synchronizer
id: '3308'
categories:
  - - Java
date: 2018-11-16 12:01:41
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

Pakiet `java.util.concurrent` wprowadził wiele ciekawych i ułatwiających codzienną pracę rozwiązań. Jednym z nich jest klasa `CountDownLatch`, która jest tematem tego wpisu. Jest to implementacja, która może być wykorzystana do bezpiecznego wątkowo odliczania. Możecie się zastanawiać do czego może przydać się tak prosty mechanizm jak odliczanie, zapraszam więc do wpisu po wyjaśnienia.
<!-- more -->
### Problem

Wyobraźmy sobie sytuację, w której mamy trzy serwisy. Każdy z nich wykonuje asynchroniczną pracę polegającą na obliczaniu sumy użytkowników każdego z nich. Na koniec obliczeń każdego z tych serwisów chcielibyśmy zsumować ich wyniki i podać średnią liczbę użytkowników: ![](http://codecouple.pl/wp-content/uploads/2018/11/Screen-Shot-2018-11-13-at-19.03.39-1024x403.png)

Problemem w tej sytuacji jest to, iż w jakiś sposób chcielibyśmy uruchomić obliczanie średniej dopiero wtedy, gdy trzy asynchroniczne obliczenia się zakończą.

### CountDownLatch

Jednym z rozwiązań tego problemu jest zastosowanie klasy `CountDownLatch`. Jest to tak zwany "zatrzask", który otwiera się, gdy licznik osiągnie zero. Na początku poprzez konstruktor ustalamy do jakiej liczby ma odbywać się odliczanie (czyli w naszym przypadku ile będzie asynchronicznych zadań):

CountDownLatch cdl = new CountDownLatch(3);

Teraz możemy "zablokować" nasz serwis zliczający średnią. Blokowanie (metoda `await()`) będzie polegało na tym, iż praca nie zostanie odpalona, dopóki wartość licznika `CountDownLatch` nie będzie równa zero.

cdl.await();

Natomiast każdy serwis po wykonaniu swojej pracy ma za zadanie zmniejszyć ten licznik (metoda `countDown()`):

cdl.countDown();

No dobra, to ustawiamy licznik na trzy i uruchamiamy zadania: ![](http://codecouple.pl/wp-content/uploads/2018/11/Screen-Shot-2018-11-13-at-19.14.54-1024x448.png) Pierwsze zadanie się skończyło, wywoływana jest metoda `countDown()`, która zmniejsza licznik: ![](http://codecouple.pl/wp-content/uploads/2018/11/Screen-Shot-2018-11-13-at-19.15.26-1024x465.png)

Drugie i trzecie zadanie również się zakończyły (po zakończeniu zostały wywołane metody `countDown()`). Blokada na metodzie `await()` została zwolniona i uruchomiła się logika odpowiedzialna za zliczanie średniej:

![](http://codecouple.pl/wp-content/uploads/2018/11/Screen-Shot-2018-11-13-at-19.16.38-1024x386.png)

### Bezpieczeństwo

Należy pamiętać, aby umieszczać metodę `countDown()` w bloku `finally`. Ponadto dla bezpieczeństwa powinniśmy korzystać z metody `await()`, która przyjmuje maksymalny czas oczekiwania `boolean await(long timeout, TimeUnit unit)`. Dzięki temu unikniemy **dead lock'a** w przypadku, gdy w jednym z zadań coś pójdzie nie tak i wartość licznika nie zostanie zmniejszona.

### Github

Całość jak zawsze na [GitHubie](https://github.com/kchrusciel/CodeCouple/tree/master/CountDownLatch).