---
title: Relacja - 4Developers 2019
tags:
  - 4developers
  - konferencja
id: '3895'
categories:
  - - Konferencje
date: 2019-04-26 16:16:53
author: 'Krzysztof Chruściel'
---

![](https://raw.githubusercontent.com/kchrusciel/code-couple-blog-assets/main/2017/04/relacjaKonferencja.png)

**8 kwietnia 2019 roku** odbyła się kolejna **warszawska** edycja konferencji **4Developers**. Jest to spotkanie sympatyków świata IT z różnych dziedzin. W tym roku dostępnych było aż **czternaście** ścieżek tematycznych, dzięki czemu każdy z uczestników z pewnością znalazł coś dla siebie. Jak co roku odbyły się konkursy, w których można było wygrać książki, kubki oraz koszulki (nam się poszczęściło!). Zapraszamy do **naszej relacji** z wydarzenia!
<!-- more -->
### Warszawa

Do **stolicy** przybyliśmy już dzień wcześniej, więc w dniu **konferencji** byliśmy na czas. Z rejestracją nie było żadnych **problemów** – wszystko przebiegało bardzo sprawnie, pomimo dużej liczby uczestników. Szybka kawa i zaczynamy!

### Struktury myślenia: modele mentalne, poziomy wnioskowania i ograniczenia ludzkiego RAM'u

Na początek wybraliśmy wykład **Artura Króla** – psychologa, który opowiadał o naszym mentalnym **RAM'ie**. Mózgu nie projektował inżynier i musimy pamiętać, że nasza pamięć robocza jest ograniczona. Artur zaczął od przykładu z **zapamiętywaniem** cyfr. Przeciętna osoba jest w stanie bez przygotowania zapamiętać około **dziewięciu** cyfr, a rekordzista zapamiętał ich aż **303**. Wszystko jest kwestią **kompresji** danych, jednak proces ten jest **czasochłonny**. Nie należy się tym **zniechęcać**. Podczas kompresji danych przydaje się **żargon** – dzięki niemu jesteśmy w stanie w jednym słowie zawrzeć np. opis całego procesu.

Prelegent zaznaczył też, że **ekspertami** są osoby wyszkolone w **jednym** temacie i niekoniecznie mają one **przewagę** w innych. Korzystając z wcześniejszego przykładu, osoba, która jest w stanie zapamiętać 303 cyfry, nie będzie w stanie zapamiętać tyle samo liter czy obrazków.

Podobno w naszym **mózgu** lewa półkula odpowiedzialna jest za treści utrwalone, a prawa za nowe. Na początku nauki czujemy duży **progres**, a w pewnym momencie następuje przestój (jest to efekt *plateau*). Nie powinniśmy się tym w ogóle **martwić**. To dobry znak, ponieważ w tym czasie treści z prawej półkuli "**przepisywane**" są do lewej. Jeśli jednak okres przestoju trwa zbyt długo, to raczej zły znak.

Warto też co jakiś czas **rozpakowywać** nasze skompresowane treści. Możemy wtedy dostrzec **błędy** logiczne oraz **pominięte** szczegóły z procesu nauki. Jest to też sposób, żeby osoby z zewnątrz nas zrozumiały (np. biznes). Jedną z dobrych metod do rozpakowywania danych jest technika "*5 Whys*", w której zadajemy pytania "**dlaczego**", prowadzące nas w głąb problemu.

**Najważniejsze** to dać sobie CZAS i się nie zniechęcać! Warto poczytać więcej o modelu **Braci Dreyfus**.

### Client had a dream, czyli od zera do rozwiązania chmurowego

Kolejna prezentacja znajdowała się na ścieżce **Cloud Computing**. Prezenterem był **Tomasz Marciniak**, który przedstawił kroki, jakie musiał wykonać, aby aplikacja została dostosowana do środowiska **chmurowego**. Na początku **Tomasz** wymienił problemy, które musiał rozwiązać:

* podział **komponentów**
* **komunikacja** między komponentami
* co ma się **skalować** i jak szybko
* podział na to, co można **developować**, a co **mockować**
* **backlog** bez Product Owner'a
* przygotowanie **środowisk**: dev, test, prod

Następnie zaprezentowane zostały propozycje rozwiązań wraz z **diagramem** całej aplikacji.

Pod koniec prezentacji pojawiły się **elementy**, które należy rozważyć/zastosować podczas tworzenia **mikroserwisów** w chmurze:

* **nazwa** serwisu ma znaczenie
* każdy serwis powinien mieć **własną** bazę (może być osobny schemat lub instancja)
* częste błędy:
    * wprowadzenie bibliotek **commons**
    * **master** mikroserwis (jeden główny komponent, przez który przechodzi cała logika)
    * **duplikacja** danych w obawie przed dużym ruchem
* RESTful vs kolejki – co wybrać? (wybrali **kolejki**)
* serwisy **dockerowe**
* wait-for-it.sh dla synchronizacji serwisów **dockerowych**
* **scheduling** a skalowalność
* managed/unmanaged
* **Kafka** handlers
* Swagger4Kafka
* testy BDD jako AC (Acceptance Criteria)
* architektura **hexagonalna**
* **DDD** dla warstwy aplikacji

### Zero-downtime Deployment Strategies with Kubernetes and CloudNative

Bardzo interesujący problem *Zero-downtime Deployment Strategies* został przedstawiony przez **Wojciecha Barczyńskiego**. Zaczął on od tego, czym w ogóle są strategie *Zero-downtime Deployment* oraz na jakie aspekty powinniśmy zwrócić uwagę przy ich stosowaniu. Jednym z aspektów jest **Graceful Shutdown** – mechanizm polegający na **bezpiecznym** i **poprawnym** zamknięciu naszej aplikacji. Prelegent zaprezentował następujące techniki **deploymentu**:

* [Recreate](https://github.com/wojciech12/talk_zero_downtime_deployment_with_kubernetes/blob/master/1_demo_recreate)
* [Rolling Updates](https://github.com/wojciech12/talk_zero_downtime_deployment_with_kubernetes/blob/master/2_demo_rolling_updates)
* [Blue Green](https://github.com/wojciech12/talk_zero_downtime_deployment_with_kubernetes/blob/master/3_demo_bluegreen)
* [Canary](https://github.com/wojciech12/talk_zero_downtime_deployment_with_kubernetes/blob/master/4_demo_canary)
* [Canary with Traefik](https://github.com/wojciech12/talk_zero_downtime_deployment_with_kubernetes/blob/master/4_demo_canary_traefik)

Bardzo podobało nam się, że były to przykłady **live demo**. Bardzo polecamy zapoznanie się z [profilem GitHub prelegenta](https://github.com/wojciech12/talk_zero_downtime_deployment_with_kubernetes), gdzie znajdziecie wszystkie przykłady z prezentacji.

### How does architect know?

Na temat **architektury** wypowiadał się **Łukasz Szydło**. Członek ekipy z **Bottegi** zwrócił uwagę na istotny problem braku informacji o **kodzie**. Bardzo często jest tak, że gdy przychodzimy do projektu i zaczynamy czytać kod, **zastanawiamy** się, *kto to tak spier....* Jednakże, za niektórymi kawałkami kodu kryją się wielogodzinne **spotkania** i **debaty** na temat **architektury**. Warto takie informacje trzymać na przykład w kodzie źródłowym w postaci **ADR'a** (ang. *Architecture Decision Record*).

Podczas **projektowania** ważne jest zastanowienie się nad **wektorami zmian** (w jaki sposób prawdopodobnie aplikacja będzie modyfikowana/rozszerzana). **Łukasz** przedstawił trzy poziomy projektowania:

* **System**
* **Komponent**
* **Elementy konstrukcyjne**

Na każdym z tych poziomów mamy inne **otoczenie**, coraz bardziej złożone, a to oznacza, że musimy odpowiadać sobie na inne pytania.

Od czego zacząć, aby zostać dobrym **architektem**?

* książki o **DDD**
* książki o **architekturze**
* [droga.dev](https://droganowoczesnegoarchitekta.pl/) (droga nowoczesnego architekta)

### Kiedy od softu zależy ludzkie życie - o systemach safety-critical

O systemach *safety-critical* opowiadał **Maciej Gajdzica**. Systemy tej klasy bardzo często mają bezpośredni wpływ na **ludzkie życie**. Na początku **Maciej** przedstawił systemy wraz z błędami, które mogły lub doprowadziły do **śmierci** ludzi. Pierwszym systemem był **Therac-25** pisany w **asemblerze** (wykorzystywany do naświetlań):

* cały program pisany był przez jedną osobę
* brak **dokumentacji**
* **rezygnacja** z zabezpieczeń hardwarowych
* brak **testów** systemowych
* **ignorowanie** błędów zgłaszanych przez użytkowników

Kolejny system to **Ariane 5** pisany w języku **Ada** (doprowadził do **wybuchu** rakiety). **Problemem było**:

* **przepełnienie** int-16
* kod **skopiowany** z poprzedniej wersji

**Prezenter** przedstawił także kilka **rekomendowanych** technik/przemyśleń, aby obniżyć ryzyko:

* **Bezpieczeństwo** systemu musi być zapewnione od początku, nie możemy dopisywać go po czasie.
* Bezpieczeństwo pojedynczego modułu nie gwarantuje **bezpieczeństwa** całego systemu.
* *Diverse programming* zmniejsza ryzyko wystąpienia tych samych błędów.
* **Sanity checks**
* **SOUP** - *Software Of Unknown Provenance*

Na koniec **Maciej** powiedział, że nie powinniśmy bać się **norm**. Wymagają one dobrych praktyk, które i tak większość z nas chce stosować.

### EventStorming Lessons Learned - kilkadziesiąt tysięcy post-itów później

**Mariusz Gil** jest osobą bardzo mocno zaangażowaną w udoskonalanie techniki zwanej **Event Storming**. Jest to technika, podczas której próbujemy zebrać jak najwięcej "biznesowo" istotnych faktów. **Prezenter** poprzez swoje kilkuletnie doświadczenie dzielił się z nami swoimi przemyśleniami.

Bardzo ważne jest to, aby na spotkaniu znalazły się wszystkie zaangażowane w projekt osoby. Powinien być na nim obecny także **facilitator**. Na początku powinniśmy określić, po co się spotkaliśmy i co chcielibyśmy osiągnąć. Jeśli odpowiedzią jest sam **Event Storming**, to mamy problem! Event Storming to tylko narzędzie, które ma nam pomóc. Powodami naszego spotkania mogą być: **uwspólnienie wiedzy**, **eksploracja danych**, **modelowanie domeny**, **identyfikacja ryzyka**, **rozwój** czy **plany na przyszłość**.

Należy także zachęcić osoby, aby brały czynny udział w spotkaniu, ale nic na siłę. Można po spotkaniu zostawić tablicę w widocznym miejscu, żeby ludzie przechodząc obok niej zaciekawili się i sami pytali. Po spotkaniu należy poinformować, co z niego wynikło – następnym razem może być więcej chętnych, którzy zauważą zysk.

Ostatni bardzo ważny punkt to fakt, że na spotkaniu są różne osobowości i musimy o tym pamiętać, dyskutując.

### test && commit revert (TCR) - alternative to TDD or eccentricity?

Bardzo ciekawa i nowa technika **TCR** została zaprezentowana przez **Piotra Stawireja**. Gdy **Kent Beck** pierwszy raz usłyszał o tym pomyśle, stwierdził: "*to jest największa głupota, jaką słyszałem... ale muszę to sprawdzić*". Jest to **technika**, w której przed **commitem** wywoływane są **testy**. Jeśli testy nie przeszły, to nasze zmiany są **usuwane**. Takie podejście ma za zadanie zmusić nas do tworzenia małych **commitów**. Oczywiście **Piotr** wspomniał, że nie jest to **technika** idealna, ale może okazać się, że za jakiś czas powstanie jakaś ciekawa **kombinacja** tej techniki, która zostanie połączona z **TDD**. Kilka z powstałych **odmian** to:

* **BTCR** – połączenie TDD i TCR – revert tylko kodu produkcyjnego bez testów
* The Buddy
* The Watch Buddy
* **The Storyteller** (dla samotnych programistów, bo można sobie porozmawiać)

Najważniejsze *takeaways* z prezentacji o **TCR**:

* **alternatywny** workflow (nie ma się co rzucać na produkcję)
* technika ma **zmusić** nas do małych commitów
* bardzo szybki powrót do **stabilnego** stanu
* eksperymentowanie, połączenie z **TDD** – bierzmy zalety, nie wady

### Wzorce i podejścia architektoniczne wspierające refaktoryzację w stronę mikroserwisów

Ostatnia **prezentacja** tego dnia dotyczyła **architektury** aplikacji. Przedstawił ją reprezentant Bottegi, **Szymon Szylhabel**. Podobnie jak **Mariusz Gil**, przedstawił on swoje przemyślenia na temat **architektury**:

* Jeżeli ciężko jest nam wyciągnąć feature z projektu, to znak, że **źle** go zaprojektowaliśmy.
* Struktura projektu – lepiej podział na **featury** niż Controller/DTO/Repository/itd.
* Powinniśmy stosować horyzontalne (techniczne) i wertykalne (featurowe) **modele**.
* **Miara sukcesu** – projektuj elementy systemu tak, aby łatwo można je było usuwać.
* Ważne są **bounded contexty**, które można odkryć przez **Event Storming**.
* Dla modułów powinniśmy mieć **osobne** bazy, tabele albo chociaż schematy.
* Do integracji modułów powinniśmy stosować **mediatora** w celu koordynacji komunikacji.
* **Odwzorowanie** procesów w kodzie (np. czekamy na potwierdzenie użytkownika).
* Powinniśmy stosować **sagi**, jeśli chcemy w łatwy sposób zmieniać wymagania aplikacji.