---
title: Otwieramy kursor w MongoDB - Tailable Cursor
tags:
  - db
  - mongo
  - spring boot
  - spring boot 2
  - tailable
id: '3086'
categories:
  - - DB
  - - Spring
  - - Spring Boot
date: 2018-08-03 12:01:09
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/12/springBoot2Art.png)

Motywem przewodnim **Spring Boot'a** w wersji **2.0** jest **reaktywność**. Wraz z tymi zmianami pojawiła się także możliwość reaktywnej współpracy z bazami **NoSQL**. W dzisiejszym wpisie zaprezentuję wam jak stworzyć niezamykający się **kursor** na bazie **MongoDB**. Aby to osiągnąć wykorzystamy kursor **tailable**.
<!-- more -->
### Tailable Cursor

Mongo automatycznie zamyka kursor w momencie zwrócenia wszystkich dokumentów, o które odpytuje użytkownik. Jednak jest możliwość pozostawienia kursora otwartego i nasłuchującego na nowe dokumenty, które pojawiają się w kolekcji. Do tego służy kursor **tailable**. Działa on analogicznie jak polecenie `tail -f` w systemach **unixowych**. W momencie dodania dokumentu do kolekcji kursor wyłapie go i od razu zwróci. Więcej znajdziecie [tutaj](https://docs.mongodb.com/manual/core/tailable-cursors/). Kursor **tailable** wykorzystywany jest tylko w kolekcjach typu **capped**, dlatego najpierw stworzymy sobie taką kolekcję.

### Capped Collection

To **kolekcja**, która ma stały rozmiar określony w trakcie tworzenia. Dokumenty przechowywane są w kolejności dodania, dzięki temu nie potrzebujemy tworzyć dodatkowych indeksów do odczytu dokumentów w takiej kolejności. Jeśli planujemy aktualizacje dokumentów, wtedy zaleca się utworzenie indeksu, żeby uniknąć skanowania całej kolekcji. Jeśli podczas aktualizacji przekroczymy pierwotny rozmiar dokumentu, operacja się nie powiedzie, a my otrzymamy komunikat błędu. W momencie przekroczenia rozmiaru **kolekcji**, nadpisywane są najstarsze dokumenty. Nie mamy możliwości ręcznego **usunięcia** dokumentów oraz **shardowania** kolekcji. Więcej informacji o tym typie **kolekcji** znajdziecie [tutaj](https://docs.mongodb.com/manual/core/capped-collections/).

### Tworzymy Capped Collection

Kolekcję typu **capped** możemy stworzyć poniższym poleceniem w konsoli lub dowolnym kliencie mongo np. **Robo 3T** (dawniejsze **Robomongo**). Ponieważ, jest to kolekcja typu **capped**, wymagane jest podanie jej rozmiaru. Jeśli podamy wartość mniejszą niż **4096 bajtów**, to rozmiar będzie ustawiony na **4096 bajtów**. Jeśli podamy wartość niepodzielną przed **256**, wtedy **mongo** podniesie ją do najbliższej takiej wartości:

db.createCollection("events", { capped : true, size : 8000} )

Możemy również ustawić parametr **capped** dla istniejących kolekcji:

db.runCommand({"convertToCapped":"events",size:10000})

Jeśli chcemy sprawdzić czy kolekcja jest typu **capped** używamy:

db.events.isCapped()

Możemy też stworzyć taką **kolekcję** w kodzie. W **Springu** wykorzystujemy do tego metodę `capped()` z klasy `CollectionOptions`.

### Implementacja

Mamy już stworzoną kolekcję, to przejdźmy do wykorzystania samego kursora **tailable**. Utworzymy prostą reaktywną aplikację w **Springu**. Potrzebne nam będą dwie zależności (`spring-boot-starter-webflux` tylko na potrzeby prezentacji danych):

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-webflux</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-mongodb-reactive</artifactId>
</dependency>

Przyda nam się klasa domenowa, niech będzie to `Event` z adnotacją `@Document`.

@Data
@RequiredArgsConstructor
@Document
public class Event {

    @Id
    private String id;
    private final EventType eventType;
    private final Date date;
}

Teraz pora na **repozytorium**. Wykorzystamy `ReactiveMongoRepository` ze **Spring Data**. Otrzymujemy **out-of-the-bo****x** podstawowe zapytania do bazy. Aby wskazać, że dane zapytanie ma wykorzystywać kursor **tailable** wystarczy dodać adnotację `@Tailable`. Ponadto, zapytania mogą zawierać warunki wyszukiwania:

@RestController
@RequestMapping("/events")
public class ReactiveController {

    @Autowired
    private ReactiveEventRepository repository;

    @GetMapping(produces = MediaType.TEXT\_EVENT\_STREAM\_VALUE)
    public Flux<Event> getEvents() {
        return repository.findAllBy()
                .doOnNext(System.out::println);
    }
}

Został nam już tylko **kontroler**, w którym wykorzystamy **kursor**. Będzie to prosta metoda **GET**, która zwróci **Flux'a** z eventami. W przykładzie pokazałam jak można wypisać eventy zarówno na konsoli jak i przy użyciu protokołu **HTTP**. Do tego drugiego użyjemy parametru `produces` ustawionego na `TEXT_EVENT_STREAM_VALUE`.

@RestController
@RequestMapping("/events")
public class ReactiveController {

    @Autowired
    private ReactiveEventRepository repository;

    @GetMapping(produces = MediaType.TEXT\_EVENT\_STREAM\_VALUE)
    public Flux<Event> getEvents() {
        return repository.findAllBy()
                .doOnNext(System.out::println);
    }
}

Teraz wystarczy uruchomić aplikację i wejść pod adres `http://localhost:8080/events`. Zauważcie, że ikona ładowania strony cały czas się kręci, oznacza to, że **kursor** jest otwarty i nasłuchuje. Jeśli dodamy coś do bazy wtedy w przeglądarce pojawi nam się nowy wpis.

### GitHub

Całość znajdziecie na [GitHubie](https://github.com/apieszczek/SpringBoot/tree/master/spring-boot-tailable).