---
title: Java 9 - Stream API
tags:
  - java
  - java 9
  - stream
  - streams
id: '2186'
categories:
  - - JVM
  - - Streams
date: 2017-10-06 12:05:19
author: 'Krzysztof Chruściel'
---

[![](http://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)](http://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

Ah! Co to był za wrzesień, niedawno premierę miała nowa wersja biblioteki **JUnit 5**, a teraz mamy oficjalne wydanie **Javy 9**. Dziewiątka nie jest tak przełomową wersją **Javy** jak ósemka, jednakże wprowadza kilka ciekawych featurów i usprawnień. W tym wpisie bierzemy na tapetę **Stream API**.
<!-- more -->
### takeWhile/dropWhile

Operacje na nieskończonych strumieniach są teraz ułatwione, w przykładzie poniżej zostaną wypisane tylko trzy napisy, natomiast program będzie się wykonywał dalej w nieskończoność:

Stream.iterate("", s -> s + "s") 
        .filter(s->s.length() < 3) 
        .forEach(this::log);

W nowym API dostajemy dwie metody:

*   `takeWhile`
*   `dropWhile`

Służą one do "obcinania" strumieni. W pierwszy przypadku zostaną wypisane tylko trzy napisy i strumień się zamknie. W drugim przypadku będą wyświetlane wszystkie napisy, których długość jest większa od trzy:

Stream.iterate("", s -> s + "s") 
        .takeWhile(s->s.length() < 3) 
        .forEach(this::log);

Stream.iterate("", s -> s + "s")
        .dropWhile(s->s.length() < 3)
        .forEach(this::log);

### iterate

Przykład podobny do tego powyżej. Metoda `iterate` ma teraz swoją trójargumentową wersję. Chcemy wypisać 10 liczb po kolei:

Stream.iterate(0, i -> i < 10, i -> i + 1)
        .forEach(this::log);

No dobra, ale w **Javie 8** mogliśmy zrobić coś takiego:

Stream.iterate(0, i -> i + 1) 
        .limit(10)
        .forEach(this::log);

Ale teraz wyobraźmy sobie, że mamy bardziej skomplikowany obiekt, na przykład wypisz mi wszystkie daty od początku roku do dziś:

Stream.iterate(startDate, date -> date.plusDays(1))
        .filter(date->date.isBefore(LocalDate.now()))
        .forEach(this::log); // To wypisze nam wszystkie daty do dziś, ale strumień będzie się dalej "kręcił"

Stream.iterate(startDate, date -> date.plusDays(1))
        .peek(this::log)
        .allMatch(date->date.isBefore(LocalDate.now())); // Działający przykład, mniej intuicyjny

W Javie 9 możemy użyć trójargumentowego `iterate`:

Stream.iterate(startDate,date -> date.isBefore(LocalDate.now()),  date -> date.plusDays(1))
        .forEach(this::log);

### ofNullable

Kolejny przykład to metoda `ofNullable`. Działa ona tak samo jak `ofNullable` w `Optional` (nie musimy sprawdzać, czy element jest nullem i wstawiać `Stream.empty()`):

Map<String, Integer> map = new HashMap<>();
map.put("String", 1);
map.put("StringSecond", null);

//JAVA 8
List<Integer> collect = Stream.of("String", "StringSecond")
        .flatMap(element -> {
            Integer temp = map.get(element);
            return temp != null ? Stream.of(temp) : Stream.empty();
        })
        .collect(toList());

//JAVA 9
List<Integer> collection = Stream.of("String", "StringSecond")
        .flatMap(element -> Stream.ofNullable(map.get(element)))
        .collect(toList());

### Stream z Optional

Ostatnim usprawnieniem jest dodanie metody, która pozwala z Optional'a stworzyć Stream. Bo tak naprawdę `Optional` to dwa elementy: null lub wartość. Od teraz nie trzeba wykonywać operacji sprawdzania, czy element istnieje tylko od razu można wykorzystać `flatMap`:

@Test
void streamFromOptional(){
    //JAVA 8
    Stream.of("string", "second")
            .map(this::getSomething)
            .filter(Optional::isPresent)
            .map(Optional::get)
            .forEach(this::log);

    //JAVA 9
    Stream.of("string", "second")
            .map(this::getSomething)
            .flatMap(Optional::stream)
            .forEach(this::log);
}

Optional<String> getSomething(String text){
    return text.equals("second") ? Optional.of(text)  : Optional.empty();
}

### Github

Całość jak zawsze na [GitHubie](https://github.com/kchrusciel/CodeCouple/tree/master/UpdatedStreamAPI).