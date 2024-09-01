---
title: Relacja – CoreDump Kraków 2018
tags:
  - coredump
  - konferencja
id: '3421'
categories:
  - - Konferencje
date: 2018-11-30 12:01:00
---

![](http://codecouple.pl/wp-content/uploads/2018/11/coreDump-White-Full.png)

W **listopadzie** 2018 roku w **Krakowie** odbyła się pierwsza edycja konferencji **CoreDump**. Była to od dłuższego czasu wyczekiwana przez nas **konferencja**. Wyczekiwana, ponieważ znając organizatorów spodziewaliśmy się dużej ilości ciekawych informacji. Zapraszamy na krótką **relację** z tego wydarzenia.
<!-- more -->
### Dzień pierwszy

Rozpoczęliśmy od miłego przywitania się z **Krakowem** poprzez... stanie w korkach ;). **CoreDump** odbywał się w **Hotelu Galaxy**. Po dojechaniu na miejsce odebraliśmy pakiet startowy, posililiśmy się ciastkami oraz kawą i ruszyliśmy po solidną dawkę wiedzy.

#### Offline Concurrency Patterns

Pierwszy wykład poprowadzony był przez **Arkadiusza Kondasa**. Przedstawił on problem równoległego dostępu do danych na przykładzie rezerwacji biletów lotniczych. Ponadto opowiedział o błędach związanych z niepoprawnymi danymi. Rozwiązaniem tych problemów mogą być:

*   **niemutowalność**
*   **izolacja**
*   **optimistic locking**
*   **pesimistic locking**

**Arkadziusz** w bardzo przestępny sposób zaprezentował powyższe rozwiązania. Skupił się on także na problemach związanych z **lockami**. Na koniec podkreślił, że jeśli możemy, to unikajmy wielowątkowości.

#### Baking in superb code quality into the Java World

Drugi wykład tego dnia prezentowany był przez **Michała Kordasa**. Na początku zaczęliśmy od zdefiniowania **metryki** dla jakości kodu. Jednogłośnie wybraliśmy **WTF/minute**. Po wybraniu metryki, **Michał** przedstawił wiele narzędzi, które mogą poprawić jakość naszego kodu. Na liście znalazły się:

*   **Sonarlint**
*   **Spotbugs**
*   **PMD**
*   **Spotless**
*   **IntelliJ**

Istotnym usprawnieniem naszej pracy może być włączenie wszystkich ostrzeżeń w naszym IDE. Przykładowo **IntelliJ** potrafi wykryć niezwolniony zasób, jednakże ta opcja domyślnie jest wyłączona. Rada od prowadzącego,  włączcie wszystkie ostrzeżenia!

#### Four Diseases

Cztery choroby, bo tak na język polski można przetłumaczyć ten tytuł poprowadzona była przez **Piotra Przybyła**. Na prezentacji widać było bardzo duże doświadczenie w kontekście występowania na konferencjach. Cztery choroby dotyczyły najpopularniejszych błędów popełnianych przez programistów:

*   **DDDois** - na przykładzie formularza poczty
*   **regex** - na przykładzie regex email
*   **not-made-here syndrome** - przechowywanie niepoprawnych typów danych (baza w bazie czy czas jako **String**).
*   **Stringoza** - trzymanie danych w typie **String** zamiast w konkretnym typie reprezentującym byt

#### Is writing performant code too expensive?

Najlepsza **prezentacja** tego dnia (zdaniem **Krzyśka**) dotyczyła pisania **optymalnego** kodu oraz ich kosztów. W świat optymalizacji wprowadził nas aktualny pracownik firmy Codewise **Tomasz Kowalczewski**. Zaczął od wspomnień z [Very Large Databases Conference](https://www.vldb.org/conference.html). Jest to konferencja, na której spotykają się ludzie proponujący nowe sposoby przetwarzania dużych **wolumenów** danych. Ponadto pojawiły się informacje na temat architektury **NUMA**, która wykorzystywana jest najczęściej w środowiskach **cloudowych**. Czekamy na nagranie z tej prelekcji!

#### Pragmatic Hype-driven development

Nasza ostatnia prezentacja tego dnia traktowała o tym, jak radzić sobie z najnowszymi **technologiami** i nie oszaleć. Praktyczne rady przedstawione były przez **Roberta Laszczaka**. Omawiane **buzzwordy** to:

*   **DDD**
*   **Event Storming**
*   **Event Sourcing**
*   **CQRS**
*   **Clean Architecture**
*   **Microserwisy** 

Dzień kończymy na krótkiej rozmowie z organizatorem tego całego zamieszania:

![](https://pbs.twimg.com/media/Ds8U_v0XgAAPpZM.jpg)

### Dzień drugi

Drugi dzień zaczynam od kawy... i selfika! [![](https://pbs.twimg.com/media/Ds_s6oqXQAAo9um.jpg)](https://twitter.com/CodeCouple_pl?lang=pl)

#### Challenging Relationships - How Graph Databases efficiently store, manage and query connected data at scale

**Neo4j** na scenie. W świat **grafów** wprowadzał nas **Michael Hunger**. Była to prezentacja pełna informacji. Zaczęliśmy od krótkiej historii biblioteki **Neo4j**, aby płynnie przejść do informacji na temat reprezentacji grafów w komputerach. Ponadto pojawiły się informacje kiedy warto wybrać **Neo4j** oraz dlaczego do języka zapytań (**Cypher**) został wybrany **ASCII Art**.

#### Apache Kafka and KSQL in Action : Let’s Build a Streaming Data Pipeline!

**Robin Moffatt** przedstawił nam w jaki sposób można przetwarzać strumienie danych z wykorzystaniem **Apache Kafka** i **KSQL**. Przetwarzanie strumieniowe jest znanym nam tematem z racji pracy magisterskiej Agnieszki. Robin na przykład pokazywał jak można nakładać transformacje na strumieniu danych. Ciekawym rozwiązaniem okazał się [Kafka Connect](https://www.confluent.io/hub/), który dostarcza interfejsy do różnych technologii pozwalające połączyć się z Apache Kafka. Kolejna nowość do Apache Kafka to [Avro](https://www.confluent.io/blog/decoupling-systems-with-apache-kafka-schema-registry-and-avro/), które przechowuje schematy. Bardzo ciekawa prezentacja!

https://www.youtube.com/watch?v=RJtEacDX4Oc

#### Chaos Engineering - withstanding turbulent conditions in production

**Benjamin Wilms** próbował zapanować na chaosem. Tematem tej prezentacji była technika znana ze środowiska **Netflix'a**, czyli **Monkey Chaos**. Autor przedstawił kilka najpopularniejszych rozwiązań. Jednym z nich jest [chaos-monkey-spring-boot](https://github.com/codecentric/chaos-monkey-spring-boot), której autorem jest właśnie **Benjamin**. Wykorzystując tą bibliotekę możemy przykładowo wstrzykiwać **opóźnienie** do naszej sieci. Wykorzystuje ona **programowanie aspektowe**. Ponadto ciekawym rozwiązaniem jest [Chaos Toolkit](https://chaostoolkit.org/), w którym możemy przygotować scenariusze **chaosu**. Kolejna bardzo dobra prezentacja (drugi dzień lepszy :D).

#### I shall say this only once

Nasza ostatnia prezentacja tego dnia dotyczyła problemu **eventów**. Przedstawiona była przez **Szymon Pobiegę**, który opowiedział nam historię firmy zajmującej się produkcją **pierogów**. Firma ta próbowała rozwiązać tak zwany [problem dwóch generałów](https://pl.wikipedia.org/wiki/Problem_bizantyjskich_genera%C5%82%C3%B3w). **Szymon** podczas prelekcji pokazywał jak można zminimalizować ryzyko utraty **informacji** oraz w jaki sposób wykonać **deduplikację** danych. Na koniec zachęcił do zgłębienia wiedzy na temat realizacji tego problemu bez **transakcji**.

### Podsumowanie

Naszym zdaniem organizatorzy stanęli na wysokości zadania. Podczas tej konferencji pojawiały się tematy z różnych dziedzin, a przekrojowy poziom prezentacji mógł zadowolić wszystkich uczestników. Z niecierpliwością patrzymy w przyszłość, aby znów wybrać się na konferencję **CoreDump**!