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

![](https://codecouple.pl/wp-content/uploads/2017/04/relacjaKonferencja.png)

**8 kwietnia 2019** odbyła się kolejna **Warszawska** edycja konferencji 4 **Developers**. Jest to spotkanie sympatyków świata IT z różnych działów. W tym roku dostępnych było aż **czternaście** ścieżek. Każdy z uczestników z pewnością znalazł temat dla siebie. Jak co roku odbyły się konkursy, w których można było wygrać książki, kubki oraz koszulki (nam się udało). Zapraszamy do **relacji** z wydarzenia!
<!-- more -->
### Warszawa

Do **stolicy** przybyliśmy już dzień wcześniej więc w dniu **konferencji** byliśmy na czas. Z rejestracją nie było żadnych **problemów**, wszystko przebiegało bardzo sprawnie pomimo dużej ilości uczestników. Szybka kawka i zaczynamy ;)

### Struktury myślenia: modele mentalne, poziomy wnioskowania i ograniczenia ludzkiego RAM'u

Na początek wybraliśmy wykład **Artura Króla** - psychologa, który opowiadał o naszym mentalnym **RAM'ie**. Mózgu nie projektował inżynier i musimy pamiętać, że nasz RAM jest ograniczony. Artur zaczął od przykładu z **zapamiętywaniem** cyfr. Przeciętna osoba jest w stanie bez przygotowania zapamiętać około **9-ciu** cyfr, a najlepsza osoba jest w stanie zapamiętać ich aż **303**. Wszystko jest kwestią **kompresji** danych. Jednak proces ten jest **czasochłonny**. Nie należy się **zniechęcać**. Podczas kompresji danych przydaje się **żargon**. Dzięki niemu jesteśmy w stanie w jednym słowie zawrzeć np. opis całego procesu.

Prelegent zaznaczył też, że **ekspertami** są osoby, które są wyszkolone w **jednym** temacie. Niekoniecznie mają one **przewagę** w innych. Korzystając z wcześniejszego przykładu osoba, która jest w stanie zapamiętać 303 cyfry, nie będzie w stanie zapamiętać tyle samo liter czy obrazków.

Podobno w naszym **mózgu** lewa półkula odpowiedzialna jest za treści utrwalone, a prawa za nowe. Na początku nauki czujemy duży **progres**, a w pewnym momencie przestój (jest to efekt _plateau_). Nie powinniśmy się tym w ogóle **martwić**. To dobry znak, ponieważ w tym czasie treści z prawej półkuli "**przepisywane**" są do lewej. Jeśli okres przestoju trwa jednak zbyt długo to raczej zły znak :)

Warto też co jakiś czas **rozpakowywać** nasze skompresowane treści. Możemy wtedy dostrzec **błędy** logiczne oraz **pominięte** szczegóły podczas nauki. Jest to też sposób, żeby osoby z zewnątrz nas zrozumiały (np. biznes). Jedną z dobrych metod do rozpakowywania danych jest technika "_5 Whys_", w której zadajemy pytania **dlaczego** prowadzące nas w głąb problemu.

**Najważniejsze** to dać sobie CZAS i się nie zniechęcać! Warto poczytać więcej o modelu **Braci Dreyfus**.

### Client had a dream, czyli od zera do rozwiązania chmurowego

Kolejna prezentacja znajdowała się na ścieżce **Cloud Computing**. Prezenterem był **Tomasz Marciniak**, który przedstawił jakie kroki musiał wykonać, aby aplikacja dostosowana była do środowiska **cloud'owego**. Na początku **Tomasz** wspomniał jakie problemy musiał rozwiązać:

*   podział **komponentów**
*   **komunikacja** między komponentami
*   co ma się **skalować** i jak szybko
*   podział na to co można **developować**, a co **mockować**
*   **backlog** bez product owner'a
*   przygotowanie **środowisk** dev, test, prod

Następnie zaprezentowane zostały propozycje rozwiązań wraz z **diagramem** całej aplikacji.

Pod koniec prezentacji pojawiły się **elementy**, które należy rozważyć/zastosować podczas tworzenia **mikroserwisów** w chmurze:

*   **nazwa** serwisu ma znaczenie
*   każdy serwis powinien mieć **własną** bazę (może być osobny schemat, instancja)
*   częste błędy:
    *   wprowadzenie bibliotek **commons**
    *   **master** mikroserwis (jeden główny komponent przez, który przechodzi cała logika)
    *   **duplikacja** danych w obawie przed dużym ruchem
*   RESTful vs kolejki - co wybrać? (wybrali **kolejki**)
*   serwisy **dockerowe**
*   wait-for-it.sh dla synchronizacji serwisów **dockerowych**
*   **scheduling** a skalowalność
*   managed/ unmanaged
*   **Kafka** handlers
*   Swagger4Kafka
*   testy BDD jako AC
*   architektura **hexagonalna**
*   **DDD** dla warstwy aplikacji

### Zero-downtime Deployment Strategies with Kubernetes and CloudNative

Bardzo interesujący problem _Zero-downtime Deployment Strategies_ został przedstawiony przez **Wojciecha Barczyńskiego**. Zaczął on od tego czym w ogóle są strategie _Zero-downtime Deployment_ oraz na jakie aspekty powinniśmy zwrócić uwagę przy ich stosowaniu. Jednym z aspektów jest **Graceful Shutdown**. Jest to mechanizm/technika polegający na **bezpiecznym** i **poprawnym** zamknięciu naszej aplikacji. Prelegent zaprezentował następujące techniki **deploymentu**:

*   [Recreate](https://github.com/wojciech12/talk_zero_downtime_deployment_with_kubernetes/blob/master/1_demo_recreate)
*   [Rolling Updates](https://github.com/wojciech12/talk_zero_downtime_deployment_with_kubernetes/blob/master/2_demo_rolling_updates)
*   [Blue Green](https://github.com/wojciech12/talk_zero_downtime_deployment_with_kubernetes/blob/master/3_demo_bluegreen)
*   [Canary](https://github.com/wojciech12/talk_zero_downtime_deployment_with_kubernetes/blob/master/4_demo_canary)
*   [Canary with Traefik](https://github.com/wojciech12/talk_zero_downtime_deployment_with_kubernetes/blob/master/4_demo_canary_traefik)

Bardzo podobało nam się, że były to przykłady **live dem**. Bardzo polecamy zapoznanie się z [githubem prelegenta](https://github.com/wojciech12/talk_zero_downtime_deployment_with_kubernetes), gdzie znajdziecie wszystkie przykłady z prezentacji.

### How does architect know?

Na temat **architektury** wypowiadał się **Łukasz Szydło**. Członek ekipy z **Botteg'i** zwrócił uwagę na istotny problem braku informacji o **kodzie**. Bardzo często jest tak, że gdy przychodzimy do projektu i zaczynamy czytać kod to **zastanawiamy** się _kto to tak spier...._ Jednakże, za niektórym kawałkami kodu kryją się wielogodzinne **spotkania** i **debaty** na temat **architektury**. Warto takie informacje trzymać na przykład w kodzie źródłowym w postaci **ADR'a** (ang. _Architecture Decision Record_).

Podczas **projektowania** ważne jest zastanowienie się nad **wektorami zmian** (w jaki sposób prawdopodobnie aplikacja będzie modyfikowana/rozszerzana). **Łukasz** przedstawił trzy poziomy projektowania:

*   **System**
*   **Komponent**
*   **Elementy konstrukcyjne**

Na każdym z tych poziomów mamy inne **otoczenie**, coraz bardziej złożone, a to oznacza, że musimy odpowiadać sobie na inne pytania.

Od czego zacząć, aby zostać dobrym **architektem**?

*   książki o **DDD**
*   książki o **architekturze**
*   [droga.dev](https://droganowoczesnegoarchitekta.pl/) (droga nowoczesnego architekta)

### Kiedy od softu zależy ludzkie życie - o systemach safety-critical

O systemach _safety-critical_ opowiadał **Maciej Gajdzica**. Systemy tej klasy bardzo często mają bezpośredni wpływ na **ludzkie życie**. Na początku **Maciej** przedstawił systemy wraz z błędami, które mogły/doprowadziły do **śmierci** ludzi.  Pierwszym systemem był **Theac-25** pisany w **asemblerze** (wykorzystywany do naświetlania):

*   cały program pisany był przez jedną osobę
*   brak **dokumentacji**
*   **rezygnacja** z zabezpieczeń hardwarowych
*   brak **testów** systemowych
*   **ignorowanie** błędów zgłaszanych przez użytkowników

Kolejny system to **Ariane 5** pisany w języku **Ada** (doprowadził do **wybuchu** rakiety). Problemam

*   **przepełnienie** int-16
*   kod **skopiowany** z poprzedniej wersji

**Prezenter** przedstawił także kilka **rekomendowanych** technik/przemyśleń, aby obniżyć ryzyko:

*   **Bezpieczeństwo** systemu musi być zapewnione od początku, nie możemy dopisywać go po czasie.
*   Bezpieczeństwo pojedynczego modułu nie gwarantuje **bezpieczeństwa** całego systemu
*   Diverse programming zmniejsza ryzyko wystąpienia tych samych błędów
*   **Sanity checks**
*   **SOUP** - Software Of Unknown Provenance

Na koniec **Maciej** powiedział, że nie powinniśmy bać się **norm**. Wymagają one dobrych praktyk, które i tak większość z nas chce stosować.

### EventStorming Lessons Learned - kilkadziesiąt tysięcy post-itów później

**Mariusz Gil** jest osobą bardzo mocno zaangażowaną w udoskonalanie techniki zwanej **Even Storming**. Jest to technika, podczas której próbujemy zebrać jak najwięcej "biznesowo" istotnych faktów. **Prezenter** poprzez swoje kilkuletnie doświadczenie dzielił się z nami swoimi przemyśleniami.

Bardzo ważne jest to, aby na spotkaniu znalazły się wszystkie zaangażowane w projekt osoby. Na spotkaniu powinien być obecny także **facilitator**. Na początku powinniśmy zacząć od tego, po co się spotkaliśmy i co chcielibyśmy osiągnąć. Jeśli odpowiedzią jest sam **Event Storming** to mamy problem! Event Storming to tylko narzędzie, które ma nam pomóc. Powodami naszego spotkania może być **uwspólnienie** **wiedzy**, **eksploracja danych**, **modelowanie domeny**, **identyfikacja ryzyka**, **rozwój** czy **plany na przyszłość**.

Należy także zachęcić osoby, aby brały czynny udział w spotkaniu, ale nic na siłę. Można po spotkaniu zostawić tablicę w widocznym miejscu, żeby ludzie przechodząc obok niej zaciekawili się, sami pytali. Po spotkaniu należy poinformować co z niego wynikło, następnym razem może być więcej chętnych, którzy zauważą zysk.

Ostatni bardzo ważny punkt, to że na spotkaniu są różne osobowości i musimy o tym pamiętać dyskutując.

### test && commit revert (TCR) - alternative to TDD or eccentricity?

Bardzo ciekawa i nowa technika **TCR** została zaprezentowana przez **Piotra Stawireja**. Gdy **Kent Beck** pierwszy raz usłyszał o tym pomyśle to stwierdził "_to jest największa głupota jaką słyszałem... ale muszę to sprawdzić_". Jest to **technika**, w której przed **commitem** wywoływane są **testy**, jeśli testy nie przeszły to nasze zmiany są **usuwane**. Takie podejście ma za zadanie zmusić nas do tworzenia małych **commitów**. Oczywiście **Piotr** wspomniał, że nie jest to **technika** idealna, ale może okazać się, że za jakaś czas powstanie jakaś ciekawa **kombinacja** tej techniki, która zostanie połączona z **TDD**. Kilka z powstałych **odmian** to:

*   **BTCR** - połączenie TDD i TCR - revert tylko kodu produkcyjnego bez testów
*   The Buddy
*   The Watch Buddy
*   **The Storyteller** (dla samotnych programistów, bo można sobie porozmawiać)

Najważniejsze _take aways_ z prezentacji o **TCR**:

*   **alternatywny** workflow (nie ma się co rzucać na produkcję)
*   technika ma **zmusić** nas do małych commitów
*   bardzo szybki powrót do **stabilnego** stanu
*   eksperymentowanie, połączenie z **TDD** - bierzmy zalety nie wady

### Wzorce i podejścia architektoniczne wspierające refaktoryzację w stronę mikroserwisów

Ostatnia **prezentacja** tego dnia dotyczyła **architektury** aplikacji. Przedstawiona została ona przez reprezentanta Bottegi **Szymona Szylhabela**. Podobnie jak **Mariusz Gil** przedstawiał swoje przemyślenia na temat **architektury**:

*   Jeżeli ciężko jest nam wyciągnąć feature z projektu to znak, że **źle** go zaprojektowaliśmy
*   Struktura projektu - lepiej podział na **featury** niż Controller/DTO/Repository/itd
*   Powinniśmy stosować horyzontalne (techniczne) i wertykalne (featurowe) **modele**
*   **Miara sukcesu** - projektuj elementy systemu tak, aby łatwo można je było usuwać
*   Ważne są **bounded contexty**, które można odkryć przez **Event Storming**
*   Dla modułów powinniśmy mieć **osobne** bazy,  tabele albo chociaż schematy
*   Do integracji modułów powinniśmy stosować **mediatora** w celu koordynacji komunikacji
*   **Odwzorowanie** procesów w kodzie (np. czekamy na potwierdzenie użytkownika)
*   Powinniśmy stosować **sagi** jeśli chcemy w łatwy sposób zmieniać wymagania aplikacji