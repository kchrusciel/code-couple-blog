---
title: Exchanger - czyli wymieniamy obiekty pomiędzy wątkami
tags:
  - concurrent
  - java
  - synchronizer
id: '3370'
categories:
  - - Java
date: 2018-12-14 12:01:45
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

Dalej pozostajemy w tematach związanych z pakietem `java.util.concurrent`. Dzisiejszy synchronizator pracy to `Exchanger`. Jak nazwa sugeruje służy on do wymiany danych pomiędzy dwoma wątkami. Podczas tworzenia tego synchronizatora określamy jakiego typu dane chcemy wymienić. Dane zostaną wymienione dopiero, gdy dwa wątki będą gotowe.
<!-- more -->
### Problem

W naszej aplikacji chcielibyśmy wymieniać dane w sposób asynchroniczny pomiędzy dwoma wątkami. Kolejnym założeniem jest to, iż oba wątki wymienią się danymi dopiero po zakończeniu swojej asynchronicznej pracy.

### Exchanger

Rozwiązaniem tego problemu jest klasa `Exchanger`, która pochodzi z pakietu `java.util.concurrent`. Pozwala wymieniać ona dane pomiędzy wątkami:

![](http://codecouple.pl/wp-content/uploads/2018/12/Screen-Shot-2018-11-19-at-12.35.49-1024x372.png)

Zaczynamy od stworzenia klasy `Exchanger`, która jest parametryzowana typem:

Exchanger<String> stringExchanger = new Exchanger<>();

Po utworzeniu klasy do wymiany możemy stworzyć dwa zadania, które po wykonaniu pracy wymienią się danymi:

stringExchanger.exchange("First Value")

Napiszmy teraz test sprawdzający poprawność klasy `Exchanger`:

@Test
void shouldExchangeValuesBetweenThreads() throws InterruptedException {
    // Given
    Exchanger<String> exchanger = new Exchanger<>();

    Job firstJob = new Job(exchanger, "first");
    Job secondJob = new Job(exchanger, "second");

    // When
    firstJob.start();
    secondJob.start();

    firstJob.join();
    secondJob.join();

    // Then
    assertThat(firstJob.getExchangedValue()).isEqualTo("second");
    assertThat(secondJob.getExchangedValue()).isEqualTo("first");
}

Implementacja wygląda następująco:

class Job extends Thread {

    private final Exchanger<String> exchanger;

    private final String value;

    private String exchangedValue;

    Job(Exchanger<String> exchanger, String value) {
        this.exchanger = exchanger;
        this.value = value;
    }

    @Override
    public void run() {
        try {
            exchangedValue = exchanger.exchange(value);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    String getExchangedValue() {
        return exchangedValue;
    }
}

### GitHub

Całość jak zawsze na [Githubie](https://github.com/kchrusciel/CodeCouple/tree/master/Exchanger).