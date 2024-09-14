---
title: Garbage collection - zliczanie referencji
tags:
  - Garbage Collector
  - GC
  - Reference Counting
id: '239'
categories:
  - - Algorytmy
  - - JVM
date: 2016-02-18 19:08:39
author: 'Krzysztof Chruściel'
---

**Garbage collector** - potocznie nazywany "odśmiecaczem". Jest tak naprawdę automatycznym procesem odpowiedzialnym za identyfikowanie nieużywanych obiektów, a następnie za ich usunięcie. Nieużywane obiekty to takie, do których nie ma żadnych referencji, czyli nie mamy możliwości dostania się do tego obiektu. Brak możliwości dostania się do obiektu jest jednoznaczny z usunięciem obiektu, a to oznacza zwolnienie obszaru pamięci.
<!-- more -->
GC (skrót od **Garbage Collector**) zawiera wiele zaimplementowanych algorytmów odpowiedzialnych za rozpoznawanie obiektów. Algorytmy te można podzielić na:

*   **skalarne**
*   **wektorowe**

Zliczanie referencji (ang. _reference counting_) jest jednym z algorytmów **skalarnych**. Polega on na zliczaniu referencji, czyli odwołań do obiektu. Zliczanie to polega na inkrementacji (w momencie dodania nowej referencji) lub dekrementacji (w momencie usunięcia referencji) wartości przypisanej do obiektu. Wartość ta prezentuje ilość odwołań do obiektu. W przypadku, gdy wartość ta jest równa zero oznacza to, że obiekt może być usunięty. Usunięcie obiektu sprawia zwolnienie obszaru pamięci. Rysunek poniżej przedstawia schemat działania: _**object 1**_ oraz _**object 2**_ przechowują referencje do _**object 3,**_ dlatego wartość wynosi 2. _**Object 4**_ ma referencję do _**object 5,**_ więc wartość wynosi 1. [![referenceCounting1](http://codecouple.pl/wp-content/uploads/2016/02/referenceCounting1.png)](http://codecouple.pl/wp-content/uploads/2016/02/referenceCounting1.png) Po przypisaniu _**object 1**_ oraz **_object 2_** do _**object 5**_, _**object 3**_ ma wartość zero co oznacza, iż może być usunięty z pamięci. [![referenceCounting2](http://codecouple.pl/wp-content/uploads/2016/02/referenceCounting2.png)](http://codecouple.pl/wp-content/uploads/2016/02/referenceCounting2.png) Jednak ten **algorytm** ma poważną wadę, nie radzi sobie z **cyklami** (nie jest w stanie rozpoznać cyklu). **Cykl** to sytuacja, w której **_object 1_** wskazuje na **_object 3,_** a **_object 3_** wskazuje na _**object 1**_. [![referenceCounting3](http://codecouple.pl/wp-content/uploads/2016/02/referenceCounting3.png)](http://codecouple.pl/wp-content/uploads/2016/02/referenceCounting3.png) Rozwiązaniem wad algorytmów **skalarnych** są algorytmy **wektorowe**, ale o tym później.