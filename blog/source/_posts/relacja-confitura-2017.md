---
title: Relacja - Confitura 2017
tags:
  - confitura
  - konferencja
id: '1986'
categories:
  - - Konferencje
date: 2017-08-04 12:01:23
author: 'Krzysztof Chruściel'
---

[![](http://codecouple.pl/wp-content/uploads/2017/04/relacjaKonferencja.png)](http://codecouple.pl/wp-content/uploads/2017/04/relacjaKonferencja.png)

Stolica przywitała nas bardzo dobrą pogodą. 1-ego lipca w **Warszawie** odbyła się 11-sta edycja **Confitury**. Jest to największa darmowa konferencja w Polsce o podłożu **JVM**. Występują na niej osoby obecne na polskiej scenie Javy. Jak w poprzednich latach nie mogło i nas zabraknąć, zapraszamy na relację!
<!-- more -->
### Keep IT clean: mid-sized building blocks and hexagonal architecture in real life

**Jakub Nabdralik** z **AllegroTech** przedstawił nam prezentację na temat architektury **hexagonalnej**. **Public** jest słowem kluczowym, które jest najczęściej używane jeśli chodzi o specyfikatory dostępu. Niestety jest to bardzo błędne zrozumienie tematu enkapsulacji! Prelegent przedstawił nam swój sposób na realizację architektury hexagonalnej. Wszystkie klasy w obrębie jednego pakietu, który jest logiczną całością, powinny mieć dostęp pakietowy (package-private). Jedynym punktem wejścia do pakietu powinna być fasada, która jest publiczna. Publiczne mogą być, lecz nie muszą DTO'sy i wyjątki. Dzięki takiemu podejściu wystarczy przetestować naszą fasadę i w zasadzie mamy pokryty testami cały moduł.

> Moim zdaniem najlepsza prezentacja dnia - Krzysztof

### Studium przypadku wystarczająco dobrej architektury

Dobrą architekturę na przykładzie startup'u **DevSkiller** prezentował **Kuba Kubryński**. Prelegent przedstawił nam elementy jakie powinna spełniać "wystarczająco" dobra architektura. Dlaczego "wystarczająco" dobra? Ponieważ perfekcjonizmu nigdy nie osiągniemy, natomiast powinniśmy dostarczać dobre produkty. Agile, Continues Delivery i unit testy to elementy, które zostały przedstawione. Usłyszeliśmy jak korzystać z nich w pragmatyczny sposób. Kuba bardzo silny nacisk kładł na programowanie oparte o dane. Na podstawie metryk wprowadzał lub usuwał jakieś funkcjonalności. Projektowanie i programowanie nie jest już oparte na przeczuciu a na danych!

### DDD: Q&A - czyli co gryzie świadomego programistę/programistkę

Nasz Polski ewangelizator **DDD** **Sławek Sobótka** przedstawił najczęściej zadawane pytania, które padają podczas jego szkoleń, jako prezentację. Trudna prelekcja dla osób, które na co dzień nie korzystają z konceptów **DDD**, a tym samym mają problem z definicjami jak bounded context czy agregat. Pytania zadawane przez ludzi to między innymi:

*   jak wyznaczyć granice obiektów?
*   jak projektować API modułów?
*   jak wyznaczać granice modułów?

Sławek wyjaśniał krok po kroku jakie powinny być odpowiedzi na te pytania.

### 3 kroki do TDD

**Test Driven Development** był tematem czwartej prezentacji w naszym dniu. **Michał Lewandowski** przedstawił nam kilka kroków, które pozwolą nam korzystać z **TDD** w sposób efektywny. Samo **TDD** jest techniką bardzo prostą, jednakże stosowanie jej polega na wieloletniej pracy i dostosowywaniu do siebie. Fajna prezentacja!

### Druga najtrudniejsza rzecz w IT

O nazewnictwie, czyli drugiej najtrudniejszej rzeczy w IT zaraz po inwalidacji cache opowiedział nam **Paweł Lewtak**. Około 70% kodu to nazwy, dlatego to zagadnienie jest tak ważne. Dzięki przemyślanym nazwom zmiennych, metod i klas jesteśmy w stanie stworzyć samodokumentujący się kod. Jest to cenne, ponieważ zdecydowanie więcej czasu poświęcamy na czytanie kodu niż jego pisanie. Prelegent przedstawił nam najpopularniejsze "błędy", które popełniamy oraz dobre praktyki pisania czytelnego kodu.

### Ship every change to production! How it’s done at LinkedIn, in Mockito, and how you can do it with shipkit.org

**Mockito Guy**, czyli **Szczepan Fabera** wraz z głównymi programistami produktu prezentowali **Shipkit**. Shipkit jest produktem, który ma na celu ułatwienie procesu **Continuous Delivery**. Oprócz tego główny prelegent opowiadał o procesie pracy w **LinkedIn**. Tam code review jest obowiązkowe, co moim zdaniem jest bardzo fajnym podejściem i świadczy o tym, że osoby z zarządu mają pojęcie na temat dobrych praktyk. Co do samej części prezentacji produktu wypadła ona słabo, natomiast już sam proces, o którym opowiadał Szczepan był bardzo ciekawy.

### Plantacje programistów - kolonializm XXI wieku

Idealna prezentacja na zakończnie **Confitury** poprowadzona była przez **Wojtka Selige**. Prelegent opowiadał o tym, dlaczego Polska pomimo, iż ma bardzo dużą ilość "zasobów", nie posiada własnego produktu rozpoznawanego na całym świecie. Czy Polska jest tylko "plantacją" programistów? Wojtek przedstawił też jego wizję przyszłości. Rynek chłonie coraz większą ilość osób przez co zarobki jak i próg wejścia stają się coraz mniejsze. Nasze eldorado programistów kiedyś pewnie się skończy, więc warto zastanowić się czy robimy wszystko, aby na tym rynku pozostać.