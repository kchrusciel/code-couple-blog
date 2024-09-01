---
title: Bezpieczne Mapy w Javie?
tags:
  - concurrent
  - java
  - map
id: '2925'
categories:
  - - Java
date: 2018-06-08 12:01:20
---

![](http://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

W Javie istnieje kilka sposobów tworzenia bezpiecznych wątkowo **Map**. Przez to, iż istnieje kilka sposobów, może to prowadzić do zakłopotania, który z nich wybrać. W dzisiejszym wpisie omówimy sobie trzy najpopularniejsze sposoby tworzenia synchronizowanych map, czyli `Hashtable`, `SynchronizedMap` oraz `ConcurrentHashMap`, zapraszam!
<!-- more -->
### Hashtable

Przed pojawieniem się frameworku `java.util.Concurrent`, użytkownicy **Javy** musieli w jakiś sposób radzić sobie z synchronizacją. Od **JDK 1.0** jest z nami klasa `Hashtable`, która posiada następujące właściwości:

*   Nie można używać wartości `null` jako klucz lub wartość (rzuca `NullPointerException`)
*   Operacje zapis/odczyt są opakowane słowem `synchronized` (co powoduje zablokowanie całej mapy tylko dla jednego wątku)
*   Użycie `synchronized` ma wpływ na wydajność (implementacja ta jest bardzo wolna)
*   Wewnętrznie używa własnego Enumertor'a (który jest iteratorem typu "fail fast") do przeglądania obiektów, który może rzucić `ConcurrentModificationException`

Hashtable<String, String> synchronizedMap = new Hashtable<>();
synchronizedMap.put(null, "Code"); //NPE
synchronizedMap.put("Couple", null); //NPE

### SynchronizedMap

Klasa `Collections` dostarcza metodę `synchronizedMap(Map<K,V> m)`, która pozwala nam stworzyć `Map` synchronizowaną na podstawie istniejącego egzemplarza mapy. Wewnętrznie, metoda ta tworzy nową **mapę** korzystając z klasy `SynchronizedMap`, która podobnie jak `Hashtable` posiada wszystkie metody **synchronizowane** (bardzo słaba wydajność). Różnicą w stosunku do `Hastable` jest to, iż można przechowywać `null` jako klucz oraz wartość.

Map<String, String> map = new HashMap<>();
Map<String, String> synchronizedMap = Collections.synchronizedMap(map);
synchronizedMap.put(null, "Code");
synchronizedMap.put("Couple", null);

### ConcurrentHashMap

Niestety, powyższe dwa sposoby dostarczają kolekcję "thread-safe" z ubogą **wydajnością**. We frameworku `java.util.Concurrent` znajdziemy kolekcję, która jest "bezpieczna" wątkowo i jest jednocześnie szybka. Jest to kolekcja `ConcurrentHashMap`. W odróżnieniu, do dwóch poprzednich kolekcji jest ona synchronizowana na operacje zapisu, tylko na konkretnie wykorzystywanym bucket'cie. Dzięki tej właściwości, operacje zapisu mogą być wykonywane równolegle do dwóch różnych **bucket'ów.** Oczywiście, jeśli częściej odczytujemy wartości, to może się zdarzyć sytuacja, w której dostaniemy niepoprawne dane. Jeśli natomiast, wykonujemy dużo więcej operacji **zapisu**, kolekcja ta jest bardzo dobrym wyborem. Podobnie jak `Hashtable`, w kolekcji tej nie możemy przechowywać klucza oraz wartości `null`.

ConcurrentHashMap<String, String> synchronizedMap = new ConcurrentHashMap<>();
synchronizedMap.put(null, "Code"); //NPE
synchronizedMap.put("Couple", null); //NPE

### Co wybrać?

Sposób synchronizacji wykorzystywany w `ConcurrentHashMap` jednoznacznie wskazuje ją jako najlepszy wybór dla `Map` synchronizowanych, jeśli wykonujemy wiele operacji zapisu, a spójność danych przy odczycie nie jest dla nas krytycznie istotna. Jeśli natomiast spójność danych jest dla nas priorytetem, najlepiej wykorzystać klasę `Collections`, która tworzy dla nas mapy **synchronizowane**. Ponadto, odnośnie `Hashtable` pojawia się ciekawy wpis w JavaDoc'u tejże klasy:

\* Java Collections Framework</a>.  Unlike the new collection
\* implementations, {@code Hashtable} is synchronized.  If a
\* thread-safe implementation is not needed, it is recommended to use
\* {@link HashMap} in place of {@code Hashtable}.  If a thread-safe
\* highly-concurrent implementation is desired, then it is recommended
\* to use {@link java.util.concurrent.ConcurrentHashMap} in place of
\* {@code Hashtable}.