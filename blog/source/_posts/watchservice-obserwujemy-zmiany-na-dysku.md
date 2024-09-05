---
title: WatchService - obserwujemy zmiany na dysku
tags:
  - java
  - WatchService
id: '3125'
categories:
  - - Java
  - - JVM
date: 2018-08-24 12:01:43
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

`WatchService` jest mechanizmem wprowadzonym w **Javie 7**. Pozwala on na obserwowanie interesującego nas folderu. Jeśli przykładowo w obserwowanym folderze pojawi się nowy plik, otrzymamy zdarzenie informujące o tej zmianie. Jest to bardziej wydaje rozwiązanie niż każdorazowe odpytywanie systemu o to czy pojawiły się nowe pliki.
<!-- more -->
### Tworzenie

Aby stworzyć nowy `WatchService` korzystamy z klasy `FileSystems`, która zwraca metody związane z aktualnym **systemem operacyjnym**. Klasa ta pozwala stworzyć `WatchService` zależny od aktualnego systemu operacyjnego:

WatchService watchService = FileSystems.getDefault().newWatchService();

Po utworzeniu usługi do nasłuchiwania pora na wskazanie miejsca, które chcemy obserwować.

### Rejestrowanie

Każda klasa implementująca interfejs `java.nio.file.Watchable` otrzymała metodę `WatchKey register(WatchService watcher, WatchEvent.Kind<?>... events)`. Metoda ta pozwala zarejestrować stworzony przez nas `WatchService`. Podczas rejestracji musimy określić na jakie zdarzenia chcemy nasłuchiwać:

*   `ENTRY_CREATE` - nowy plik został stworzony
*   `ENTRY_DELETE` - plik został usunięty
*   `ENTRY_MODIFY` - plik został zmodyfikowany
*   `OVERFLOW` - informuje o tym, że utraciliśmy informację o zdarzeniu, nie ma potrzeby rejestrowania się na to zdarzenie, aby je otrzymywać

folder.register(watchService,
        StandardWatchEventKinds.ENTRY\_CREATE,
        StandardWatchEventKinds.ENTRY\_DELETE,
        StandardWatchEventKinds.ENTRY\_MODIFY);

### WatchKey

W odpowiedzi na zarejestrowanie `WatchService` otrzymaliśmy `WatchKey`. Klasa ta posiada metodę `pollEvents()`, która zwraca listę zdarzeń `WatchEvent`. Sam `WatchKey` może znajdować się w trzech stanach:

*   `ready` - gotowy do nasłuchiwania (jest w takim stanie zaraz po utworzeniu)
*   `signaled` - znajduje się w tym stanie po zakolejkowaniu zdarzeń (już więcej nie nasłuchuje!)
*   `invalid` - znajduje się w tym stanie gdy:
    *   `WatchService` został zamknięty
    *   folder przestał być dostępny
    *   została wywołana metoda `cancel`

### WatchEvent

Jest to zdarzenie, które wydarzyło się w zarejestrowanym folderze. `WatchEvent` dostarcza trzy metody:

*   `count` - ilość wystąpień danego zdarzenia
*   `context` - nazwa pliku, dla którego zdarzenie wystąpiło
*   `kind` - typ zdarzenia (uwaga, może być to typ `OVERFLOW` nawet jeśli się na niego nie rejestrowaliśmy)

watchKey.pollEvents()
        .forEach(x -> System.out.format(
        "Context: %s Kind: %s Count: %d%n", x.context(), x.kind().name(), x.count()));

### Nasłuchujemy!

Poniżej znajduje się kompletny kod nasłuchujący na zmiany w folderze:

WatchService watchService = FileSystems.getDefault().newWatchService();
Path path = Paths.get("dir/path/to/watch");
WatchKey watchKey = path.register(watchService,
        StandardWatchEventKinds.ENTRY\_CREATE,
        StandardWatchEventKinds.ENTRY\_DELETE,
        StandardWatchEventKinds.ENTRY\_MODIFY);

while(true) {
    watchKey.pollEvents()
            .forEach(x -> System.out.format(
            "Context: %s Kind: %s Count: %d%n", x.context(), x.kind().name(), x.count()));
    watchKey.reset();
}

Pojawiła się tu metoda `reset`, która do tej pory nie była opisana. Przypominam, iż `WatchKey` znajduje się w stanie `ready` do momentu zakolejkowania pierwszych zdarzeń. Potem **nie nasłuchuje** on już na nowe zdarzenia. Aby ponownie ustawić `WatchKey` w stan `ready` z `signaled` korzystamy z metody `reset`.