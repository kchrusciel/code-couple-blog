---
title: Strumienie danych w Javie - java.util.stream
tags:
  - collections
  - java
  - stream
id: '189'
categories:
  - - Java
  - - Streams
date: 2016-02-15 08:00:14
author: 'Krzysztof Chruściel'
---

Bardzo fajnym dodatkiem w **Javie 8** są strumienie danych. Znajdują się one w pakiecie **java.util.stream**. Są one odpowiedzialne za przetwarzanie danych w postaci strumieni oraz za operacje na wielu elementach. Do reprezentowania kolekcji w trakcie przetwarzania służy nowy interfejs **Stream<T>**. Na strumieniach możemy wykonać szereg operacji, aby na końcu pobrać wynik (metoda agregująca) tych operacji bez zmiany stanu samego strumienia.
<!-- more -->
Operacje na strumieniach można podzielić na dwa typy:

*   **terminalne** (ang. _terminal_)
*   **pośrednie** (ang. _intermediate_)

**Terminalne** - są to operacje, które zamykają strumień. Kończą one pracę ze strumieniem. Uwaga! Może być tylko jedna operacja kończąca, w przeciwnym wypadku wystąpi wyjątek. **Pośrednie** \- czyli metody, które operują na strumieniu, ale go nie zamykają. Dzięki temu, możliwy jest **chaining.** Strumienie są **leniwie inicjowane** (ang. _laziness-seeking_), czyli operacje pośrednie wykonywane są dopiero wtedy, kiedy natrafią na operację **terminalną**. **Wykonywanie operacji w łańcuchu** (ang. _chaining_) jest możliwe dzięki metodom (wykonywanym na strumieniach), które zwracają przetworzony strumień. Strumienie są "**jednorazówkami**" (ang. _nonreusable_), czyli nie wykorzystujemy ich kilka razy, ponieważ każde użycie strumienia musi być zakończone operacją **terminalną** (zamykającą strumień). Operacje na strumieniach **domyślnie** wykonywane są **sekwencyjnie,** czyli w jednym wątku. Natomiast mamy możliwość przestawienia sposobu wykonywania operacji na **równoległy,** czyli wykonywany w kilku wątkach. Pakiet stream w bardzo elegancki sposób dostarcza nam możliwość przełączenia trybu pracy na **równoległy**:

stream.parallel()

Natomiast jeśli chcemy wywołać przetwarzanie **sekwencyjne** (które jest ustawione domyślnie):

stream.sequential()

**Strumienie** można tworzyć na różne sposoby. Poniżej znajdują się trzy przykłady: Wywołanie metody **stream()** na obiekcie kolekcji (najczęściej wykorzystywane).

Collection.stream()

Wykorzystanie pakietu **Stream**.

Stream.of()

Wykorzystanie pakietu **Arrays**.

Arrays.stream()

Po utworzeniu strumieni pora na przykłady. Mamy klasę **Person,** która ma pola imię, nazwisko oraz datę urodzenia. W pierwszym przykładzie przy użyciu strumieni chcemy otrzymać tylko unikalne imiona:

List<Person> personList = new ArrayList<>();

personList.add(new Person("Krzysztof", "Code", LocalDate.of(1990, 01, 01)));
personList.add(new Person("Agnieszka", "Couple", LocalDate.of(1991, 02, 02)));
personList.add(new Person("Krzysztof", "Nowak", LocalDate.of(1992, 03, 03)));


List<String> distinctNames = new ArrayList<>();

distinctNames = personList.stream()
        .map(person -> person.getName())
        .distinct()
        .collect(Collectors.toList());

System.out.println(distinctNames);

Wynik:

\[Krzysztof, Agnieszka\]

W drugim przykładzie chcemy otrzymać obiekty Person, w których pola name mają ustawioną wartość na "Krzysztof":

Predicate<Person> namePredicate = person -> person.getName().equals("Krzysztof");

List<Person> personWithSpecifedName = new ArrayList<>();

personWithSpecifedName = personList.stream()
        .filter(namePredicate)
        .collect(Collectors.toList());

System.out.println(personWithSpecifedName);

Wynik:

\[Person{name='Krzysztof', surname='Code', birthDate=1990-01-01}, Person{name='Krzysztof', surname='Nowak', birthDate=1992-03-03}\]

Jeśli chcesz się dowiedzieć więcej odsyłam [TUTAJ](https://docs.oracle.com/javase/8/docs/api/java/util/stream/package-summary.html).