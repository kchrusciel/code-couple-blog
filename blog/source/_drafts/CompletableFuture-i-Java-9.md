---
title: CompletableFuture i Java 9
tags: []
id: '2872'
categories:
  - - Python
---

![](http://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

**Java 10** jest już z nami od jakiegoś czasu, jednakże chciałbym jeszcze na chwilę wrócić do **Javy 9** (zanim wyjdzie 11 :D). **Java 9** w kontekście **CompletableFuture** wprowadziła dwie metody, które
<!-- more -->
### Problem ze zwracanym CompletableFuture

Wyobraźmy sobie sytuację w, której w naszym API wystawiamy metodę która zwraca `CompletableFuture`:

\[snipped\]

Teraz klienci naszego **API** mogą tą pracę zakończyć. Może zdarzyć się przypadek, iż zakończenie tej pracy będzie miało dla nas znaczenie. Przykładowo mamy nałożoną transformację, która zapisuje statystyki:

\[snipped\]

Rozwiązaniem tego problemu jest metoda `copy()`.

### copy()

Metoda `copy()` zwraca kopię `CompletableFuture`. Aby unikąć sytuacji w której klient naszego API kończy `CompletableFuture`, który my zwróciliśmy:

\[snipped\]

### Problem z timeout

Jeśli chcieliśmy określić ramy czasowe dla naszego asynchronicznego zadania mogliśmy wykorzystać metodę:

\[snipped\]

Niestety, metoda ta jest blokująca. Oczywiście możemy obejść ten problem tworzą nowy `CompletableFuture` odpowiedzialny za timeout:

\[snipped\]

W nowej wersji **Javy** dostajemy natywne wsparcie dla tego rozwiązania:

*   `orTimeout`
*   `completeOnTimeout`

Metody te "pod spodem" korzystają z `ScheduledThreadExecutor` i oznaczają `CompletableFuture`  jako "completed exceptionally"

### orTimeout

Metoda orTimeout:

\[snipped\]

Służy do komponowania nieblokującej transformacji odpowiedzialnej za **timeout**.

### completeOnTimeout

aaa

### defaultExecutor

Metoda ta zwraca domyślną pulę wątków na której wykonywany będzie `CompletableFuture`. Jak pisałem w poprzednich artykułach domyślną pulą dla `CompletableFuture` jest **ForkJoinPool**:

\[snipped\]

### delayedExecutor

aaa

### Więcej

W tym wpisie opisałem najważniejsze zmiany w kontekście CompletableFuture. Oprócz powyżyszych rozwiązań pojawiło się także kilka inny usprawnień. Po więcej zapraszam -> \[link\].