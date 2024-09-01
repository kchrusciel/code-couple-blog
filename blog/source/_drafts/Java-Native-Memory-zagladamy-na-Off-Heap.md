---
title: Java Native Memory - zaglądamy na Off-Heap
tags: []
id: '4120'
categories:
  - - Java
---

Po raz kolejny wybierzemy się w podróż w stronę metalu. Tym razem sprawdzimy co znajduje się wewnątrz pamięci natywnej procesu JVM'a.
<!-- more -->
### Czym jest Java Native Memory?

W momencie uruchomienia każdego procesu alokowany jest dla niego nowy obszar pamięci. W przypadku "zwykłego procesu" (nie JVM), alokowany jest obszar pamięci zwany **heap'em**. W przypadku procesu **JVM** oprócz **heap'a** (na którym przechowywane jest większość obiektów) mamy obszar pamięci określany jako **off-heap** (w nim znajduje się pamięć natywna procesu dlatego wykorzystujemy nazwę **Java** **Native** **Memory**): ![](https://codecouple.pl/wp-content/uploads/2019/10/processes-1024x694.png)

### Co znajduje się w Java Native Memory?

Wewnątrz obszaru **off-heap** znajdują się dodatkowe informacje wymagane do poprawnego działania procesu **JVM**. Znajdziemy tam między innymi informacje o:

*   **wątkach** - **stosy** wątków zwykłych i natywnych
*   **metaspace** - załadowane klasy i struktury
*   **code cache** - obszar wykorzystywany przez **JIT'a**
*   **GC** - obszar wykorzystywany przez **GC**
*   inne...

### ![](https://codecouple.pl/wp-content/uploads/2019/10/off-heap.png)

### Native Memory Tracking

Od **Javy 7** pojawiła się nowa fukcjonalność, który pozwala na podglądanie pamięci natywnej w **Javie**. Jest to **feature** zwany **Native Memory Tracking**. Można go włączyć używając przełącznika w **JVM**:

*   `-XX:NativeMemoryTracking=[off summary detail]`

Gdzie w momencie dodawania tego przełącznika musimy wybrać jedną z opcji:

*   `off` - wyłączamy NMT (ta opcja jest domyślnie ustawiona)
*   `summary` - zbiera wszystkie informacje na temat pamięci
*   `detail` - abc

asas

**Uwaga!** Należy pamiętać, że po włączeniu **NMT** nasza aplikacja może zużywać więcej zasobów **CPU** jak i **pamięci**.

### jcmd

jcmd jest narzędziem, które pozwala na odczytywanie dodatkowych informacji o działającej wirtualnej maszynie javy, co może być przydatne w jej diagnostyce (wiele programów diagnostycznych wykorzystuje jcmd "pod spodem". Narzędzie to jest dostęp w zainstalowany JDK. W naszym przypadku chcielibyśmy odczytać informacje o pamięci natywnej. Aby to zrobić musimy znać PID naszego proces, tutaj może okazać się kolejne narzędzie z JDK jakim jest **jps**. Narzędzie **jps** zwraca nam wszystkie uruchomione procesy JVM wraz z ich numerem PID:

$ jps
74649 Jps
4462

Gdy znamy już **PID** naszego procesu możemy wykorzystać **jcmd**, który zwróci nam informacje o **pamięci natywnej**:

jcmd <pid> VM.native\_memory \[summary  detail  baseline  summary.diff  detail.diff  shutdown\] \[scale= KB  MB  GB\]

A w naszym przypadku:

jcmd 4462 VM.native\_memory

Dodatkowo możemy przekazać:

*   summary -
*   detail -
*   baseline - tworzy zrzut referencyjny do kolejnych pomiarów
*   summary.diff -
*   details.diff -
*   shutdown - wyłącza NMT
*   scale - w jakich jednostkach  chcemy otrzymywać wyniki

asas asas

### Analiza

Udało nam się zrobić **zrzut pamięci natywnej**, który prezentuje się tak:

$ jcmd 40648 VM.native\_memory summary scale=KB
40648:

Native Memory Tracking:

Total: reserved=5791929KB, committed=432833KB
-                 Java Heap (reserved=4194304KB, committed=262144KB)
                            (mmap: reserved=4194304KB, committed=262144KB)

-                     Class (reserved=1082389KB, committed=38545KB)
                            (classes #6673)
                            (  instance classes #6207, array classes #466)
                            (malloc=1045KB #15524)
                            (mmap: reserved=1081344KB, committed=37500KB)
                            (  Metadata:   )
                            (    reserved=32768KB, committed=32768KB)
                            (    used=32049KB)
                            (    free=719KB)
                            (    waste=0KB =0.00%)
                            (  Class space:)
                            (    reserved=1048576KB, committed=4732KB)
                            (    used=4271KB)
                            (    free=461KB)
                            (    waste=0KB =0.00%)

-                    Thread (reserved=43197KB, committed=43197KB)
                            (thread #42)
                            (stack: reserved=43008KB, committed=43008KB)
                            (malloc=140KB #228)
                            (arena=49KB #82)

-                      Code (reserved=248236KB, committed=11064KB)
                            (malloc=548KB #3469)
                            (mmap: reserved=247688KB, committed=10516KB)

-                        GC (reserved=211733KB, committed=65813KB)
                            (malloc=22257KB #4821)
                            (mmap: reserved=189476KB, committed=43556KB)

-                  Compiler (reserved=146KB, committed=146KB)
                            (malloc=15KB #322)
                            (arena=131KB #5)

-                  Internal (reserved=791KB, committed=791KB)
                            (malloc=751KB #2408)
                            (mmap: reserved=40KB, committed=40KB)

-                     Other (reserved=16KB, committed=16KB)
                            (malloc=16KB #2)

-                    Symbol (reserved=9046KB, committed=9046KB)
                            (malloc=7248KB #82130)
                            (arena=1798KB #1)

-    Native Memory Tracking (reserved=1752KB, committed=1752KB)
                            (malloc=11KB #143)
                            (tracking overhead=1741KB)

-               Arena Chunk (reserved=176KB, committed=176KB)
                            (malloc=176KB)

-                   Logging (reserved=4KB, committed=4KB)
                            (malloc=4KB #179)

-                 Arguments (reserved=18KB, committed=18KB)
                            (malloc=18KB #467)

-                    Module (reserved=122KB, committed=122KB)
                            (malloc=122KB #1558)

Przeanalizujmy co znajduje się w każdej z sekcji.

#### Total

W pierwszej linijce mamy przedstawiony całkowity zarezerwowany obszar oraz ilość rzeczywiście użytej pamięci:

Total: reserved=5791929KB, committed=432833KB

#### Java Heap

Drugi linijka prezentuje rozmiar stosu aby móc sprawdzić ile pozostało miejsca na pozostałe obszary:

Java Heap (reserved=4194304KB, committed=262144KB)
(mmap: reserved=4194304KB, committed=262144KB)

Jak widzicie po mimo zarezerwowania 5656 MB dla aplikacji to heap zarezerwował tylko 4096 MB, pozostała różnica to rozmiar zarezerwowany przez obszar natywny.

#### Class

W tym blokuje otrzymamy informacje na temat **załadowanych** klas:

*   reserved - zarezerwowany obszar pamięci dla klas
*   committed - wykorzystany obszar pamięci
*   classes - liczba załadowanych klas (zwykłych i tablic)

Class (reserved=1082389KB, committed=38545KB)
                            (classes #6673)
                            (  instance classes #6207, array classes #466)
                            (malloc=1045KB #15524)
                            (mmap: reserved=1081344KB, committed=37500KB)
                            (  Metadata:   )
                            (    reserved=32768KB, committed=32768KB)
                            (    used=32049KB)
                            (    free=719KB)
                            (    waste=0KB =0.00%)
                            (  Class space:)
                            (    reserved=1048576KB, committed=4732KB)
                            (    used=4271KB)
                            (    free=461KB)
                            (    waste=0KB =0.00%)

#### Thread

W kolejnym bloku znajdują się informacje na temat **wątków** (tutaj bardzo dobrze widać, że jeden wątek to około jednego MB pamięci):

*   reserved - zarezerwowany obszar pamięci dla wątków
*   committed - wykorzystany obszar pamięci
*   thread - liczba wątków
*   stack - zarezerwowany obszar dla stosów per wątek

Thread (reserved=43197KB, committed=43197KB)
                            (thread #42)
                            (stack: reserved=43008KB, committed=43008KB)
                            (malloc=140KB #228)
                            (arena=49KB #82)

#### Code

Tutaj otrzymamy informacje przechowywane przez JIT'a:

*   reserved - zarezerwowany obszar pamięci dla klas
*   committed - wykorzystany obszar pamięci

#### GC

asas

#### Compiler

asas

#### Internal

asas

#### Symbol

Tutaj przechowywane są wszystkie obiekty typu String, które znajdują się w "String Pool"

### Statystyki na zamknięcie

Na sam koniec, jeśli chcemy możemy także pobrać informacje o **off-heap'ie** w momencie zamknięcia aplikacji. Aby włączyć tą opcje należy użyć **dwóch** dodatkowych przełączników:

*   `-XX:+UnlockDiagnosticVMOptions`
*   `-XX:+PrintNMTStatistics`