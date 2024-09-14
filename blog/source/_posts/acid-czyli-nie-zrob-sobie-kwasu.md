---
title: ACID - czyli nie zrób sobie kwasu
tags:
  - acid
  - db
id: '541'
categories:
  - - DB
date: 2016-03-27 09:08:34
author: 'Krzysztof Chruściel'
---

Dziś bardziej **bazodanowo**, czyli słów kilka o **ACID**. **ACID** jest anagramem, czyli słowem zbudowanym z pierwszych liter innych słów. Jest to zbiór właściwości, które pozwalają osiągnąć spójność danych. Prawie wszystkie aktualne aplikacje korzystają z bazy danych warto więc widzieć coś na temat: **A** - _atomowość_, **C** - _spójność_, **I** - _izolacja_, **D** - _trwałość_.
<!-- more -->
Jak wspomniałem we wstępie słowo ACID jest anagramem, wyjaśnijmy więc jego znaczenie.

**A (ang. _atomicity_) - atomowość** Jeśli w ramach jednej transakcji wykonywane jest kilka operacji, nie zostaną one wykonane jeśli jedna z operacji się nie wykona. Można to porównać do zasady jeden za wszystkich - wszyscy za jednego. Najlepszym przykładem są operacje bankowe, w jednej transakcji mamy operacje zmiany stanu konta osoby, która wysyła i konta osoby, która otrzymuje. Nie może być tak, że operacja wysyłania pieniędzy się nie uda, ale stan na koncie drugiej osoby się zwiększy. W przypadku błędu transakcja jest przerywana.

**C (ang. _consistency_) - spójność** Spójność związana jest z zasadami integralności danych. Zapewnia ona spójność danych poprzez zastosowanie mechanizmów, które uniemożliwiają zmianę danych w nieautoryzowany sposób. Powracając do przykładu bankowego mogłyby być to ogromne straty finansowe.

**I (ang. _isolation_) - izolacja** Bardzo ważna jest gdy z naszej bazy korzysta kilka osób w tym samym czasie. Użytkownicy muszą mieć możliwość korzystania z tych samych danych. Związane jest to także ze współbieżnością. Istnieją różne poziomy izolacji, [WIĘCEJ](http://edu.pjwstk.edu.pl/wyklady/sbd/scb/w12.htm).

**D (ang. _durability_) - trwałość** Ostatnią literą jest trwałość. Związane jest to z trwałością danych w transakcji np. w przypadku awarii jesteśmy w stanie odtworzyć dane.