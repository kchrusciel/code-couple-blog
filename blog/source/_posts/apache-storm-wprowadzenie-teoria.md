---
title: Apache Storm - wprowadzenie, teoria
tags:
  - Apache Storm
  - streams
id: '300'
categories:
  - - Streams
date: 2016-03-06 22:16:10
---

**Apache Storm** jest projektem open source i służy do przetwarzania strumieniowego w czasie rzeczywistym. Ułatwia wykonywanie działań na nieograniczonych strumieniach danych. Może być używany z dowolnym językiem programowania. Przed samym rozpoczęciem zabawy z **Apache Storm** przygotowałam trochę teorii, która ułatwi nam późniejszą pracę z tym projektem.
<!-- more -->
W **Apache Storm** wykorzystywany jest model pojedynczego przetwarzania strumieniowego, który reprezentowany jest za pomocą grafu obliczeniowego zwanego **topologią** (_ang.topology)._ Polega on na przekształcaniu strumieni w nowe strumienie przy jednoczesnym aktualizowaniu bazy danych. W modelu tym za pomocą jednego pliku wdrożonego do klastra jesteśmy w stanie wykonywać różne operacje na różnych węzłach (np. filtrowanie danych w jednym węźle, agregacja w drugim). Nie musimy pisać osobnych programów dla każdego węzła. Składowe modelu:

*   krotki (_ang.tuples_)
*   strumienie (_ang.streams_)
*   wylewki (_ang.spouts_)
*   gromy (_ang.bolts_)

**Krotka** jest ciągiem wartości (danych). **Strumień** jest rdzeniem modelu składającym się z nieskończonej sekwencji krotek. ![model_storm_1](http://codecouple.pl/wp-content/uploads/2016/03/model_storm_1.jpg) **Wylewka** jest źródłem strumieni. Odczytuje ona dane i przekształca je w strumienie krotek. ![model_storm_2](http://codecouple.pl/wp-content/uploads/2016/03/model_storm_2.jpg) **Grom** wykonuje określone funkcje na strumieniach (np. złączenia, agregacje). Na wejściu dostaje przynajmniej jeden strumień wejściowy i generuje dowolną ilość strumieni wyjściowych. ![model_storm_3](http://codecouple.pl/wp-content/uploads/2016/03/model_storm_3.jpg) Po zdefiniowaniu wszystkich składowych powstaje topologia, która łączy wylewki i gromy oraz określa przepływ krotek przez aplikację. **Zadanie** (_ang.task_) to instancja gromu lub wylewki. W modelu tym wykonywane są one równolegle. Ponieważ zadania wykonywane są równolegle ważne jest określenie, które zadanie otrzyma daną krotkę. W tym celu wykorzystuje się **grupowanie strumieni** (_ang. stream grouping_). Najprostszym przykładem jest **grupowanie tasujące** (_ang.shuffle grouping_). Wykorzystuje ono losowy algorytm round-robin, aby równomiernie rozdzielić krotki na poszczególne zadania.   W następnych wpisach znajdziecie praktyczne zastosowanie przedstawionej teorii z wykorzystaniem **Apache Storm**.