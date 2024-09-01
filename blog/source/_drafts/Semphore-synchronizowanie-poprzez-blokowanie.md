---
title: Semphore - synchronizowanie poprzez blokowanie
tags: []
id: '3400'
categories:
  - - Java
---

![](http://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

Kolejnym **synchronizatorem**, który zagości u nas na blogu jest `java.util.concurrent.Sempahor`. Podczas wykorzystywania **Sempahor'u** możemy określić ile aktualnie zadań może być wykonywywać dany blok kodu.
<!-- more -->
### Problem

Wyobraźmy sobie sytuację, w której tylko określona liczba wątków może wykonywać daną akcje. Przykładowo, nasza kolejka może jednocześnie wysyłać dane tylko do dwóch odbiorców.

\[img\]

Możemy sami próbować kontrolować sekcję krtyczną poprzez **countery**, natomiast musi pamiętać wtedy o **thread-safety**. Rozwiązaniem tego problemu może być `java.util.concurrent.Sempahor`.

### Semaphor

`Semaphor` jest mechaniazmem blokujący dostęp do sekcji krtycznej. O tym jak wiele wątków może być "wpuszczonych" do sekcji krytycznej decyduje paramtr `permits` (czyli maksymalna liczba "pozwoleń"):

public Semaphore(int permits)

Ponadto możemy ustawić właściwość określaną `fairness`. Oznacza to, iż wątki najdłużej oczekujące na wejście do sekcji krytycznej będą wpuszczane na zasadzie kolejki **FIFO** (First-In-First-Out):

public Semaphore(int permits, boolean fair)

Jeśli nasz wątek chce nabyć (ang. _acquire_) dostęp do sekcji krytycznej musi wywołać metodę o tej samej nazwie:

semaphore.acquire();

Jeśli ilość pozwoleń (permits) została wykorzystana, nasze wątki trafiają na kolejkę. Po wykonaniu zadania wątek może zwolnić pozwolenie, aby znów trafiło do puli:

semaphore.release()

Wywołanie metody acquire jest blokujące jeśli wszystkie pozwolenia zostały zabrane. Jeśli natomiast nie chcemy blokować danego wątku jeśli nie ma już dostępnej liczby pozwoleń możemy wykorzystać metodę tryAcquire:

semaphore.tryAcquire()

Która zwraca true jeśli udało jej się zdobyć pozwolenie a false w przeciwnym wypadku.

### Priorytety

Metoda `acquire` oraz `release` występuje w przeciążonej formie, która przyjmuję liczbę pozwoleń do zajęcią lub zwolenienia:

semaphore.acquire(2);
semaphore.release(2);

Dzięki temu możemy **priorytetyzować** nasze zadania.

### Więcej

Dodatko Semaphor dostarcza nam kilka metod:

semaphore.availablePermits() // ilość dostępnych pozwoleń
semaphore.hasQueuedThreads() // czy są zakolejkowane jakieś wątki na sempahorze
semaphore.getQueueLength() // rozmiar tej kolejki
semaphore.isFair() // zwraca informacje czy sempahor jest w trybie fairness

### GitHub

Całość jak zawsze na GitHubie.