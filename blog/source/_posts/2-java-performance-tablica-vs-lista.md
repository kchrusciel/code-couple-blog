---
title: '#2 Java Performance - Tablica vs. Lista'
tags:
  - java
  - performance
id: '2357'
categories:
  - - Java
date: 2017-12-15 12:14:55
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

Kolejny wpis z serii **Java Performance** dotyczy stosowania struktur danych takich jak **tablice** oraz **listy**. Tablice oraz listy są jednymi z najbardziej popularnych struktur danych stosowanych przez programistów **Javy.** Jednakże nie zawsze dobieramy je jako **optymalne** rozwiązanie dla danego problemu. W tym wpisie postaram się pokazać wam, jak wybierać pomiędzy listą, a tablicą.
<!-- more -->
### Notacja dużego O

Z notacją dużego O po raz pierwszy miałem styczność na studiach. Notacja ta, to nic innego jak **opis szybkości algorytmu** (w najgorszym przypadku) poprzedzony dużą literą **O**. Jeśli nasze zadanie polega na znalezieniu adresu wśród listy **100 adresów**, musimy przejrzeć je wszystkie po kolei. Złożoność takiego procesu określimy jako **O(n)**, gdzie **n** oznacza ilość operacji w najgorszym przypadku. Jeśli nasz adres będzie na końcu listy, wykonamy wówczas 100 operacji. Wiedza o **O notacji** przyda nam się następnych akapitach.

### Tablica

Jest to struktura danych, która w pamięci przechowywana jest jako **cały blok**. Jeśli w naszej tablicy mamy 10 elementów, to elementy te znajdują się obok siebie. W przypadku dodawania (lub usuwania) elementów w środku listy, cecha ta wpływa negatywnie na czas wykonania tej operacji, ponieważ wszystkie pozostałe elementy muszą zostać przesunięte. Często zdarza się tak, iż nie możemy przesunąć tych elementów, bo brakuje pamięci, wtedy szukany jest kolejny obszar, który jest w stanie pomieścić tą tablicę z 11 elementami, co po raz kolejny wydłuża operację dodawania.

Jednakże pozytywną cechą takiej struktury jest bardzo szybki czas odczytu, ponieważ elementy tablicy znajdują się w jednym miejscu, co oznacza, iż nie ma potrzeby przeszukiwania całego obszaru pamięci.

### Lista

Kolejną strukturą danych jest **lista**. Każdy element w pamięci, który znajduje się w liście przechowuje swoją wartość oraz pamięta adres kolejnego elementu. Dzięki tej właściwości dodawanie lub usuwanie elementów jest natychmiastowe, ponieważ następuje tylko przepięcie wskaźników.

Jednakże negatywną cechą takiej struktury jest bardzo długi czas odczytu w opozycji do tablicy. Aby odczytać ostatni element listy musimy przejść przez wszystkie elementy, aż  wartość na samym końcu zostanie odczytana.

### Tablica vs Lista

Jeśli zależy nam na optymalizacji naszego kodu, a często korzystamy z tablicy lub listy powinniśmy robić to z głową. Poniżej znajduje się tabela, która przedstawia szybkość operacji w **O notacji**: \[table id=3 /\] Dlatego jeśli często będziemy dodawać lub usuwać elementy powinniśmy wybrać **listę**, jeśli jednak dane inicjalizujemy tylko raz lub rzadko, a wykonujemy wiele operacji odczytu powinniśmy wybrać **tablicę**.

### Tablica + Lista

A co jeśli potrzebujemy struktury, która ma szybkie operacje **zapisu** i **odczytu**? Możemy stworzyć **tablicę list**. Wyobraźmy sobie katalog nazwisk od A do Z, a operacją jaką chcemy wykonać to wstawienie nazwiska na literę Z. Możemy przygotować naszą strukturę tak, że będziemy mieli tyle elementów w tablicy ile mamy liter w naszym katalogu, a każdy element zawiera w sobie listę z konkretnymi nazwiskami. Wykonujemy operację, pobieramy tablicę na literę Z więc mamy **O(1)** i po pobraniu, mamy listę, do której wstawiamy nowe nazwisko **O(1)**.

### Konkretna implementacja

**Update!** Pojawiło się kilka komentarzy na temat samego wpisu. Wszystko co znajduje się powyżej dotyczy samych struktur danych a nie ich konkretnych implementacji. Konkretną implementacją listy we wbudowanym **API Javy** może być na przykład **LinkedList**. Jeśli chodzi o tworzenie tablic, to proste tablice można tworzyć poprzez **int\[\] tab = new int\[10\]**, jednakże zarządzanie nimi nie jest zbytnio wygodne. Korzystając z lekkiego narzutu możemy wykorzystać  implementację **ArrayList**, która pod spodem wykorzystuje prostą tablicę, a dzięki interfejsowi **List** zarządzanie nią jest bardzo proste.

> \* Resizable-array implementation of the <tt>List</tt> interface. Implements \* all optional list operations, and permits all elements, including \* <tt>null</tt>. In addition to implementing the <tt>List</tt> interface, \* this class provides methods to manipulate the size of the array that is \* used internally to store the list. (This class is roughly equivalent to \* <tt>Vector</tt>, except that it is unsynchronized.) \* \* <p>The <tt>size</tt>, <tt>isEmpty</tt>, <tt>get</tt>, <tt>set</tt>, \* <tt>iterator</tt>, and <tt>listIterator</tt> operations run in constant \* time. The <tt>add</tt> operation runs in <i>amortized constant time</i>, \* that is, adding n elements requires O(n) time. All of the other operations \* run in linear time (roughly speaking). The constant factor is low compared \* to that for the <tt>LinkedList</tt> implementation.

### Podsumowanie

Jak widzicie, wybór odpowiedniej struktury danych może mieć bardzo znaczący wpływ na szybkość działania naszej aplikacji i pamiętajmy, wszystko co robimy róbmy z głową, ponieważ łatwo można coś naprawić, ale jeszcze łatwiej popsuć. Mierzmy nasze wyniki, aby ta optymalizacja była mądra.