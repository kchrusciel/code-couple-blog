---
title: Relacja – Quality Excites 2017
tags:
  - konferencja
  - quality excites
id: '1943'
categories:
  - - Konferencje
date: 2017-06-30 15:31:52
author: 'Krzysztof Chruściel'
---

[![](http://codecouple.pl/wp-content/uploads/2017/04/relacjaKonferencja.png)](http://codecouple.pl/wp-content/uploads/2017/04/relacjaKonferencja.png)

Jak w roku 2016 tak i w tym wybraliśmy się na szóstą edycję konferencji **Quality Excites**. Tym razem konferencja rozbita została na dwa dni. W pierwszym dniu odbyły się liczne **warsztaty**, natomiast dzień drugi poświęcony był **prelekcjom**. My wybraliśmy się na oba dni.
<!-- more -->
### Warsztaty

Zapisaliśmy się na warsztaty "**Jak wprowadzić i utrzymać kulturę DevOps w środowisku QA?**" prowadzone przez **Kamilę Gawrońską** oraz **Wojciecha Gawrońskiego**. Warsztaty zaczęły się punktualnie. Nasza grupa była **15** osobowa. Zaczęliśmy od przedstawienia się. Każdy z nas, łącznie z prelegentami miał możliwość powiedzenia w jakiej firmie pracuje, na jakim stanowisku, jakie ma doświadczenie i najważniejsze - czego oczekuje od warsztatu. Potem wyjaśniliśmy czym dla każdego z nas jest **DevOps**. Prowadzący zaznaczyli, że jest to proces, a nie projekt i jest sposobem na uzyskanie "**operational excellence**". Zespół współpracuje z pełną świadomością i odpowiedzialnością, aby osiągnąć doskonałość. **DevOps** stara się rozwiązywać problemy **złożone**. Bardzo fajnym elementem warsztatów były ćwiczenia w podgrupach, w których każdy wcielał się w rolę jednego z członków agilowego teamu. Trwało to trochę dłużej niż było zamierzone, dlatego nie starczyło czasu na zaprezentowanie wszystkich narzędzi wspomagających pracę **DevOps'ów.** Prelegenci zdążyli przedstawić **Vagranta** oraz gdzie można znaleźć projekty na **githubie**.

> "Szkoda, że zabrakło czasu na praktykę" - Krzysztof

### Prelekcje

Po godzinie ósmej stawiliśmy się w punkcie rejestracji na drugi dzień konferencji, potem szybka kawa, croissant i można zaczynać wykłady.

Tradycyjne krótkie wprowadzenie przez **Daniela Deca**, w którym przedstawił swoje przemyślenia odnośnie minionego roku. Zaprezentował trzy punkty:

*   **komunikacja** - aby rozmawiać, a nie atakować się
*   **feedback** - aby dawać taki feedback jakiego sami oczekujemy
*   **konferencje** - aby brać udział z konferencjach i meetupach dla poszerzania wiedzy

Następnie przedstawił jednego z dwóch głównych gości jakim był **Aslak Hellesøy**, który płynnie przeszedł do prelekcji otwierającej.

### Testable Software Architecture

Jak napisaliśmy w zdaniu powyżej, prelekcję wprowadzającą prowadził gość specjalny **Aslak Hellesøy**, który pracuje nad znanym narzędziem jaki jest **Cucumber**. Najważniejsze wartości testów automatycznych to:

*   **confidence** - pewność co do testów (brak losowości)
*   **fast** - szybkość wykonywania
*   **low cost** - niska cena utrzymania

Opowiadał on jak zdekomponować złożone testy na mniejsze, dzięki wykorzystaniu różnych technik na przykład **portów i adapterów** lub **kontraktów**. Taka dekompozycja pozwala nam w łatwiejszy sposób zarządzać testami, a dzięki temu spełniliśmy trzy najważniejsze wartości dobrych testów automatycznych.

### Jakaś prezentacja o testach bezpieczeństwa <script>alert(1)</script>

Od samego początku prezentacja była prowadzona w bardzo fajny i interesujący sposób. **Mateusz Piaszczak** jest doświadczonym prelegentem i było to widać w czasie jego prelekcji. Na początku przedstawione były problemy jakie wywołało nowe rozporządzenia **GDPR**, które mówi o ochronie danych osobowych. Prelegent zaprezentował trzy potencjalne grupy, które mogą zaatakować nasze aplikacji:

*   Janusze hackingu
*   gimby
*   "normalni" hackerzy

Dla dwóch pierwszych powstały narzędzie, które bez większej wiedzy można wykorzystać do przejęcia kontroli nad innym komputerem. Prelegent pokazał również narzędzia, do testowania zabezpieczeń takie jak:

*   Acunetix
*   Burp Suite
*   Checkmarx
*   Zap

Ważna jest świadomość, że **testy automatyczne bezpieczeństwa** nie zastąpią człowieka, jednakże lepsze są takie testy niż ich całkowity brak. Na koniec **Mateusz** pokazał nam również literaturę, którą warto przeczytać, żeby zgłębić wiedzę na ten temat.

> "Najlepsza prezentacja w tym dniu" - Agnieszka

### Metryki i raporty jakościowe, czyli tam i z powrotem

O metrykach związanych z releasami opowiadał jeden z założycieli grupy **PTaQ**, **Zbigniew Moćkun**. Przedstawił on proces wprowadzania metryk i raportów na przykładzie firmy, w której pracuje. Zaczęło się od start-up, potem przychodzili coraz to więksi klienci. Raporty zostały wprowadzone jako wymaganie jednego z nich. Według **Zbyszka** metryki nie mają dawać odpowiedzi, tylko zmuszać do zadawania pytań. Zaczynali od raportów manualnych, ale z czasem zaczęli korzystać z narzędzia **QAMetrics**, który pozwolił zautomatyzować pracę. Postanowili oni również podzielić metryki na wewnętrzne i zewnętrzne, żeby nie udostępniać zbyt wielu informacji nieistotnych dla klienta. Pojawiały się problemy z politykami ich klientów, ponieważ każdy z nich nalegał na korzystanie z własnego środowiska. Dodatkowo raporty nie były zawsze wykonywane jednocześnie z releasem, tylko po. To powodowało częściową pracę **manualną**, a tym samym cofnęli się do czasów z przed automatyzacji. Dzisiaj mogą pochwalić się dużo większą dojrzałością i mądrością wyniesioną z całego procesu wprowadzania raportów i metryk w ich firmie.

### SQA w erze TestOps

Na początku **Tomasz Janiszewski** i **Dawid Pacia** przedstawili proces wytwarzania oprogramowania:

continous build -> continous validation -> continoud delivery -> continous monitoring

Skupili się na ostatnim etapie jakim jest monitoring. Narzędzie, które było wykorzystywane do przechowywania logów to **Kibana** i cały stos **ELK**. Następnie prelegenci przedstawili kim jest **TestOps** i czym się zajmuje:

*   blisko związana z infrastrukturą
*   współpracuje z DevOpsami
*   otwiera nowe testerskie perspektywy
*   daje wiedzę nad czym testerzy powinni się jeszcze skupić
*   proponuje workflow testerom

Zaprezentowane zostały również narzędzia dla **TestOpsów**, jakimi są:

*   git
*   jenkins
*   pipelines
*   blue ocean
*   docker
*   pumba (chaos monkey)
*   jmeter

Panowie zostawili nas z poradami, które powinny nam towarzyszyć w kontekście **TestOps**:

*   Specyficzny rodzaj testowania - dobranie testu do problemu
*   TestOps otwiera nowe możliwości
*   TestOps należy integrować z teamem, a jeśli nie ma takiego działu, to należy przejąć inicjatywę i odpowiedzialność

### Jak zwiększyć wartość testów jednostkowych?

**Łukasz Wróbel**, **Michał Kopacz** przedstawili sposoby jak zwiększyć wydajność **testów jednostkowych**. Pierwszym sposobem jest szukanie testów bez asercji, mogą one zaciemniać rzeczywisty stan aplikacji. Powinniśmy zwrócić uwagę również na czytelność testów. Nazwa powinna zawierać scenariusz który będzie testowany. Ponadto my jako czytelnicy testu oczekujemy iż zachowanie tego testu zostanie przedstawione w nazwie. Następnie przedstawione były różnice pomiędzy **Stub** vs. **Mock**. **Stuby** powinniśmy wykorzystywać do zachowań, natomiast **Mocki** do interakcji. Pojawiło się także kilka pojęć które powinien spełniać dobry test:

*   **Testowalny kod** -> kod musi być testowalny
*   **Kruche testy** -> jedna zmiana która dużo psuje
*   **Nieprzewidywalność** -> zależności losowe, time(), random()

Na koniec prelegenci przedstawili **TDD** jako jedna z rozwiązań na poprawę jakości kodu.

### Magic of chaos

**Kamila Mrozek** opowiedziała nam o chaosie i jak możemy sobie z nim radzić. Zaczęła od stwierdzenia, że lubi, gdy wszystko wokół niej płonie. My też niemal każdego dnia natykamy się w swoim życiu zawodowym jak i prywatnym z małymi i większymi chaosami. Jak sobie z nimi radzić? Najlepiej zacząć od własnego chaosu, a dopiero potem zwalczać chaos na wyższych poziomach - w teamie, firmie. Pierwszą rzeczą, od której powinniśmy zacząć jest tak zwana **ToDoList**, czyli lista zadań do wykonania. Mamy wiele możliwości tworzenia takich list, np. papierowe notesy, czy aplikacje na telefon. Ważne jest tworzenie takich list z głową, bo okazuje się, że zbyt długie listy nas demotywują i nie pomaga nam to. Musimy ustalić jakie priorytety obowiązują i przydzielać je w momencie tworzenia zadań. Zamiast mówić "**nie mam czasu**", powinniśmy odpowiedzieć "**nie jest to moim priorytetem**". Nie bójmy się też zostawiać zadań, w momencie przyjścia innych o wyższym priorytecie. Ale nie zapomnijmy zapisać sobie miejsca, w którym skończyliśmy. Kamila wymieniła kilka narzędzi wspomagających pracę  z zadaniami:

*   Any.Do
*   Aana
*   Evernote

Należy pamiętać, że nie jesteśmy sami ze swoim chaosem i musimy dzielić się wiedzą. Nie zawsze muszą być to spotkania, na które często nie mamy czasu. Możemy zastąpić je instrukcjami, test casami, emailami podsumowującymi, czy tablicami w swoich pokojach. Takie rozwiązania pomogą nam zwalczyć chaos na wyższym poziomie - w grupie.

### Developer na detoksie

Prezentacja prowadzona była przez **Michała Płachtę**. Przez całą prezentację towarzyszyła nam historia o **Janie**, który był odzwierciedleniem developera, któremu przydałby się detoks. W piątek po południu przed urlopem dostał zadanie do wykonania - zmiana nazw w kodzie. Co powinien zrobić w tej sytuacji? W tej historii Jan doświadczył paraliżu decyzyjnego oraz iluzji pewności siebie. **Michał** przedstawił opinię jako składowe pewności i wiedzy. Nie powinniśmy kierować się słowami w stylu "Uncle Bob said", tylko rzetelnymi badaniami, eksperymentami oraz bazować na danych. Historia Jana opierała się o jedną z dwóch najtrudniejszych rzeczy w IT - **nazewnictwo**, dlatego prelegent część wykładu poświęcił problemowi dobierania nazw. Badania dowodzą, że między 7-18% wynosi prawdopodobieństwo, że nasz kolega z teamu wybierze taką samą nazwę jak my. Ważne jest, żeby zwrócić uwagę na ten problem, ponieważ nazwy to ok. 70% całego kodu.

> "Dla mnie to była najlepsza prezentacja" - Krzysztof

### SOLIDne Page Objecty — Screenplay Pattern w akcji

**Tomasz Kras** z FutureProcessing opowiedział nam czym jest wzorzec **Screenplay**. Jest on zbudowany wokół **aktorów**, którzy używają swoich umiejętności do wykonywania zadań i zadawania pytań o stan systemu, aby osiągnąć cel biznesowy. **Prelegent** pokazywał i omawiał wzorzec na podstawie fragmentów kodu. Ważne było to, aby słownictwo było jak najbardziej zbliżone do języka naturalnego, dlatego w kodzie bardzo rzadko pojawiały się elementy związane z językiem programowania. Na koniec prezentacji **Tomek** podał kilka źródeł, z których można zaczerpnąć więcej wiedzy na temat omawianego wzorca.

### Architektura, która ewoluuje

O architekturze opowiadał nam **Daniel Pokusa**. Na początku przedstawił nam **żelazny trójkąt projektu** oraz wpływ zależności każdego wierzchołka. Według Daniela trójkąt powinien być zmodyfikowany do kwadratu i oprócz czasu, zasobów i funkcjonalności, powinna znaleźć się również **jakość**. W swojej prezentacji co jakiś czas prelegent pokazywał książki, które warto przeczytać i są związane z architekturą. Zwrócił także uwagę na dwa przeciwstawne bieguny takie jak:

*   technology freedom vs. technology prison
*   overdesign (DRY) vs. underdesign (KISS YAGNI)

Pojawiło się stwierdzenie, że testy to koszty oraz przedstawiony został wzór, według którego można stwierdzić, czy warto automatyzować testy:

(N\*E) > P + M

N - ilość wykonań E - czas wykonania testu P - czas przygotowania testu M - czas utrzymania testu

Na koniec **Daniel** zaznaczył, że klient zawsze oczekuje jakości, a nie jest ona nigdy wartością 0-1. **Kod źródłowy testów jest tak samo ważny jak kod produkcyjny**, a decyzje należy podejmować najpóźniej jak to możliwe.

### Wdrażanie na wulkanie, czyli CI w świecie, który nie znosi opóźnień

**Piotr Marczydło** z firmy **DreamLab** opowiadał jak dostarczać oprogramowanie lepsze, szybciej i taniej. Prelekcja opierała się o doświadczenie zdobyte w firmie, w której aktualnie pracuje. Omówionych zostało kilka z wielu problemów pojawiających się w trakcie **wytwarzania oprogramowania**. Są nimi m.in. brak spójności w projekcie, niska jakość kodu, czy dług techniczny. Piotr przedstawił nam w uproszczeniu model developmentu:

*   definiowanie wymagań
*   projektowanie
*   implementacja
*   testowanie

Ich dobre praktyki doprowadziły do tego, że inny teamy mogą korzystać z **CI as a Service**. Na koniec przedstawiony został model dojrzałości systemów **CI**, gdzie numer to stopień dojrzałości:

1.  Initial -> chaotic
2.  Managed -> firefighting
3.  Defined - > predictable
4.  Quantitatively managed -> service level agreement
5.  Optimizing -> zero touch continous deployment