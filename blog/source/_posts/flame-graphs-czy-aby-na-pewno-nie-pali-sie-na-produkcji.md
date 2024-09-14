---
title: Flame Graphs - czy aby na pewno nie pali się na produkcji?
tags: []
id: '4281'
category: Java
date: 2020-04-28 12:01:32
author: 'Krzysztof Chruściel'
---

[![](https://codecouple.pl/wp-content/uploads/2020/04/file-3.svg)](https://codecouple.pl/wp-content/uploads/2020/04/file-3.svg)

**Flame Graphs** jest techniką, która pozwala zlokalizować nam tak zwane "**bottlenecki**" w naszym kodzie. Dzięki swojej **graficznej** reprezentacji przypominającej **płomienie** jesteśmy w stanie w bardzo łatwy sposób zaobserwować **procesy**, które konsumują największą ilość czasu **CPU**. Zapraszamy do wpisu aby zobaczyć jak wygenerować własne "**płomienie**".
<!-- more -->
### Flame Graphs

**Flame Graphs** są sposobem reprezentacji **danych** związanych z **wydajnością** aplikacji. Dane przedstawione są w formie wykresu przypominającego **płomienie**:

[![](https://codecouple.pl/wp-content/uploads/2020/04/cpu-mysql-updated.svg)](https://codecouple.pl/wp-content/uploads/2020/04/cpu-mysql-updated.svg)

Jest to sposób reprezentacji danych zaproponowany przez [Brendana Gregga](http://www.brendangregg.com/flamegraphs.html), który jest "gościem od performance" w firmie **Netflix**. Dzięki takiej reprezentacji unikniemy nadmiernej analizy danych, które w większości nie są danymi **najważniejszymi**.

### Github

Aby **wygenerować** wykres najlepiej **sklonować** repozytorium **Brendana** [https://github.com/brendangregg/FlameGraph](https://github.com/brendangregg/FlameGraph). W repozytorium tym znajduje się plik `flamegraph.pl`, którzy służy do **generowania** wykresu. Najczęściej wydajemy polecenie:

```shell
./flamegraph.pl pilk-z-danymi.txt > plik-wynikowy.svg
```

Po uruchomieniu tego polecania wystarczy otworzyć wygenerowany **plik** na przykład w przeglądarce.

### Plik z danymi

Dane prezentowane na wykresie powinny być dostarczone w odpowiednim **formacie**:

```shell
funkcja-1();funckja-2() czas-CPU-spędzony-na-wykonywaniu-funkcji-2
```

 Sprawdźmy to w praktyce dla **danych**:

```shell
a();b();c() 1
a();b();d() 1
```

[![](https://codecouple.pl/wp-content/uploads/2020/04/file-1.svg)](https://codecouple.pl/wp-content/uploads/2020/04/file-1.svg)

```shell
a();b();c() 1
a();b();d() 2
```

[![](https://codecouple.pl/wp-content/uploads/2020/04/file-2.svg)](https://codecouple.pl/wp-content/uploads/2020/04/file-2.svg)

### Jak czytać wykres

Na wykresie znajdują się **dwie** osie:

![](https://codecouple.pl/wp-content/uploads/2020/04/file.svg)

*   oś y (pionowa) - pokazuje głębokość/**wysokość** stosu wywołań
*   oś x (pozioma) - pokazuje nazwy procesów w kolejności **alfabetycznej**
*   **kolory** - wbrew pozorom nie mają **znaczenia**

Najważniejsze **procesy** to te, które znajdują się na samej górze. Są one tak zwanymi procesami **on-CPU**, czyli procesami, które tak naprawdę są wykonywane na **procesorze.** Procesy poniżej to te, które wywołały **proces** na górze (w dokumentacji spotkacie się z określeniem tych procesów jako przodkowie _ancestry_).

### Dane

W poprzednich **akapitach** przedstawiłem wam przykładowe **dane**. Jednakże skąd wziąć dane, które rzeczywiście pokażą nam ciekawe informacje? Do pobierania danych o procesach mamy dostępną całą gamę narzędzi. Najpopularniejsze to:

*   **perf**
*   **DTrace**
*   **jstack**
*   **pprof**

Każde z tych narzędzi generuje dane w innym formacie. Autor **Flame Graphs** dostarczył konwertery, które pozwalają zmienić format wyjściowy na format obsługiwany dla **Flame Graphs**. Na [https://github.com/brendangregg/FlameGraph](https://github.com/brendangregg/FlameGraph) znajdziecie wiele konwerterów:

*   `stackcollapse.pl` - dla DTrace stacks
*   `stackcollapse-perf.pl` - dla Linux'owego perf_events "perf script" wyniku
*   `stackcollapse-jstack.pl` - dla jstack
*   `stackcollapse-go.pl` - dla GoLangowego pprof

### Dodatkowe opcje

Samo narzędzie ma sporo **dodatkowych** opcji:

```shell
USAGE: ./flamegraph.pl \[options\] infile > outfile.svg

  --title TEXT     # change title text
  --subtitle TEXT  # second level title (optional)
  --width NUM      # width of image (default 1200)
  --height NUM     # height of each frame (default 16)
  --minwidth NUM   # omit smaller functions (default 0.1 pixels)
  --fonttype FONT  # font type (default "Verdana")
  --fontsize NUM   # font size (default 12)
  --countname TEXT # count type label (default "samples")
  --nametype TEXT  # name type label (default "Function:")
  --colors PALETTE # set color palette. choices are: hot (default), mem,
                   # io, wakeup, chain, java, js, perl, red, green, blue,
                   # aqua, yellow, purple, orange
  --bgcolors COLOR # set background colors. gradient choices are yellow
                   # (default), blue, green, grey; flat colors use "#rrggbb"
  --hash           # colors are keyed by function name hash
  --cp             # use consistent palette (palette.map)
  --reverse        # generate stack-reversed flame graph
  --inverted       # icicle graph
  --flamechart     # produce a flame chart (sort by time, do not merge stacks)
  --negate         # switch differential hues (blue<->red)
  --notes TEXT     # add notes comment in SVG (for debugging)
  --help           # this message

  eg,
  ./flamegraph.pl --title="Flame Graph: malloc()" trace.txt > graph.svg
```