---
title: Relacja – JDD Kraków 2018
tags:
  - jdd
  - konferencja
id: '3250'
categories:
  - - Konferencje
date: 2018-10-15 10:59:32
---

![](http://codecouple.pl/wp-content/uploads/2018/08/jdd.png)

8 oraz 9 października bieżącego roku odbyła się jedna z największych konferencji IT w Polsce. **JDD** jest cykliczną imprezą, która zbiera największych entuzjastów języka Java w Polsce. Na konferencji występuje wiele gwiazd polskiej jak i zagranicznej sceny. Zapraszamy do relacji z tegorocznej edycji.
<!-- more -->
### Zaczynamy

Miejscem spotkania było Nowohuckie Centrum Kultury w Krakowie. Z parkingiem nie mieliśmy problemu, bo z rana było sporo wolnych, darmowych miejsc wzdłuż ulicy Jana Pawła II, a pod samym NCK można było się zatrzymać na płatnych parkingach. Rejestracja trwała od 8:00 rano i przebiegała całkiem sprawnie jak na prawie 1000 uczestników. Każdy dostał pakiet z ulotkami i gadżetami z firm sponsorujących to wydarzenie. O 9:00 rozpoczęła się ceremonia otwarcia, a zaraz po niej pierwszy wykład. Pod kątem organizacji nie można się do niczego doczepić. Przygotowane były 4 ścieżki, na których równocześnie występowali prelegenci. Każdy mógł znaleźć coś dla siebie. Kawa, herbata, soki i przekąski były dostępne przez cały czas trwania konferencji w kilku miejscach obiektu. Organizatorzy przygotowali aplikację, w której można było znaleźć plan budynku oraz agendę. Była też możliwość wygrania koszulki z tegorocznej edycji JDD, pod warunkiem, że wypełniło się ankietę oraz zebrało wszystkie QR kody, które rozmieszczone były na wszystkich stanowiskach sponsorów. Poza koszulkami większość wystawców miała swoje konkursy i nagrody.

### GraphQL - APIs the New Way

Pierwsza prezentacja dotyczyła GraphQL'a. Przedstawiona była przez reprezentanta ukraińskiej sceny Javowej **Vladimira Tsukura**. Dotychczasowe REST'owe API boryka się z dwoma problemami:

\- _over-fetching_ - za dużo **danych** - _under-fetching_ - za dużo **requestów**

Rozwiązaniem tych problemów może okazać się API oparte na grafach. Biblioteką implementującą to podejście jest **GraphQL**. Na koniec należy pamiętać, że to nadal nie rozwiązuje wszystkich problemów jeśli API jest źle zaprojektowane.

### Java Innovations: from Developer-driven features to a new Cloud approach

Na samym wstępie musimy wspomnieć o problemach technicznych, które miały miejsce przez całą prezentację. Doprowadziło to do braku pełnego skupienia na omawianym temacie. **Fabrizio Marini** podczas walki z problemami technicznymi starał się pokazać jakie nowości zostały wprowadzone w kolejnych wersjach Javy od 9 zaczynając. Po tych opisach przeszedł on na stronę cloudową. Oracle ostatnimi czas chce zawalczyć o kawałek chmurowego tortu promując i dostarczając swoje rozwiązania.

### Automate all the things

**Kuba Kubryński** zaczął od zadania kilku pytań na temat automatyzacji oraz starał się odpowiedzieć na pytanie czym owa automatyzacja może być. Ponadto zostały przedstawione największe pułapki związane z infrastrukturą i testami. Pułapki związane z infrastrukturą:

\- zaczynanie od złego procesu - brak zrozumienia i chęci innych członków zespołu do zmian - brak wizji - brak standardów

Pułapki związane z testowaniem:

\- testowanie na zbyt wysokim poziome - testowane jest zbyt dużo - podział testów i developmentu - nieprawidłowy rozwój - staranie się być idealnym

### Java Code Security

Skuszeni ostatnią bardzo dobrą prezentacją **Marka Puchalskiego** na Quality Excites udaliśmy się na jego prelekcję. Marek zaczął od przedstawienia kilku przykładów związanych z security, po czym przeszliśmy do tworzenia własnych polityk. Po raz kolejny okazuje się jak małą mamy wiedzę na temat wbudowanych mechanizmów zabezpieczeń naszych aplikacji.

### new java.io.File("jdd.json"); is this really that simple?

"Kolejna prezentacja o niczym" - takimi słowami rozpoczął swoją prezentację **Jarek Pałka**. Jednakże naszym zdaniem było to błędne określenie. Prelegent opowiadał o tym jak w wydajny sposób wykorzystywać IO związane z plikami. Bardzo wiele wbudowanych mechanizmów z domyślnymi ustawieniami w Javie działa w nieoptymalny sposób. Pomimo, iż korzystamy z popularnych rozwiązań, to niestety zapominamy o tym, że tworzone były one również przez ludzi. Warto zajrzeć do bebechów i sprawdzić jak te mechanizmy są zaimplementowane.

### Docker internals

Przedostatnia prezentacja w tym dniu dotyczyła Dockera. **Michał Gryko** zaczął od przedstawienia czym jest Docker by płynnie przejść do jego implementacji. Sam Docker jest kolejną warstwą abstrakcji ułatwiającą pracę z takimi mechanizmami jak `cgroup` i `namespaces`. Te dwie funkcjonalności są w **Linuxie** od bardzo dawna, jednakże to dopiero Docker tak bardzo je rozpromował. Była to porządna dawka wiedzy, szkoda tylko, że pod koniec dnia, gdy "nie wchodzi" ona już tak szybko jak z rana. Prezentacja ta została oceniona jako najlepsza wśród **JUGMajsterów**.

### GraphQL - when REST API is not enough - lessons learned

Zakończyliśmy pierwszy dzień konferencji tą samą tematyka, którą rozpoczęliśmy - GraphQL. Tym razem z **Marcinem Stachniukiem**. Była to prezentacja typu lessons learned: - nie należy dodawać biblioteki zaraz po jej wydaniu - abstrakcja nie jest wystarczająca jeśli nie wiesz co jest pod maską - używajmy scheme zamiast code first - GraphQL nie jest kompletnym językiem wyszukiwania - problem N+1 można rozwiązać poprzez batching data-loader - zmiana myślenia z REST API na grafy jest kluczowa - testowanie jest proste - istnieje wiele narzędzi do grafów **Pora na dzień numer dwa!**

### Secure Domain

Pierwsza prezentacja tego dnia poprowadzona była przez znanego nam już **Dominika Przybysza**. Opowiadał on o bezpiecznej domenie, ale tak naprawdę o czystej domenie. Podczas wystąpienia przedstawione zostały dobre praktyki, które pozwalają nam tworzyć jak najbardziej "czystą" domenę. Zamiast zwykłych typów `String`, powinniśmy opakowywać je w klasy dla lepszego zrozumienia (przecież w domenie nie mam obiektów typu `String` tylko _imię_ czy _nazwisko_). Słowo kluczowe `String`, nie powinno być najpopularniejszym słowem używanym w naszym kodzie źródłowym. Wiele przykładów przedstawionych było również w innych językach na platformie **JVM**.

### Event Storming - skracanie dystansu pomiędzy IT a biznesem

Wracamy na ścieżkę numer jeden, która znajduje się w sali kinowej. Występował przed nami **Sławek Sobotka**, który opowiadał o najważniejszym procesie **DDD** jakim jest **event storming**. Podczas prezentacji przedstawiona została przykładowa sesja **event storming'u** ze szczególnym zwróceniem uwagi na to co jest istotne w tym procesie. Rada od prelegenta - "_trzymajcie zgniecione karteczki, jak przyjdzie biznes to pokażecie ile złych pomysłów odrzuciliście_".

### Transakcyjne przetwarzanie w JPA- jak wiele można zepsuć

W warstwie **persystencji** znaleźliśmy się za pomocą **Wojtka Oczkowskiego**. Opowiadał on o transakcjach w **JPA**. Była to prelekcja wypełniona przykładami młodego programisty **Romka**. Każdy błąd początkującego programisty był weryfikowany na **code review**, które było przeprowadzane przez wszystkich nas podczas prezentacji. Były to bardzo proste, a zarazem pouczające przykłady.

### A practical approach to Java Memory Model

**Memory Model** jest tematem, który zawsze wypełnia sale po brzegi. Tym razem opowiadał o tym **Andrzej Czarny**, który na co dzień pracuje w UK. W prezentacji przedstawione zostały przykłady w jaki sposób procesory układają i wykonują prace. Wiedza ta wymagana była do dalszych przykładów. Bardzo ciekawe okazało się narzędzie **JCStress**, które pozwala wykonywać testy dla zadań asynchronicznych.

### The Dark Side of Java 8

Nasza przedostatnia prezentacja dotyczyła "czarnej" strony Javy 8. Podczas niej dowiedzieliśmy się co poszło nie tak w aktualnie najpopularniejszej wersji Javy czyli 8. Wiele problemów takich jak brak możliwości zamknięcia nieskończonego strumienia, brak możliwości ustawienia swojej puli wątków w **paraller streamach** czy "przepuszczanie" danych w operatorze **flatMap** zostało naprawionych w kolejnych wersjach.

### Reactive programming: lessons learned

Ostatnią prezentacją tego dnia należała do nowego **Java Championa Tomka Nurkiewicza**. Dotyczyła ona programowania reaktywnego. Była to prezentacja, której zadaniem było zrozumienie kiedy warto zainwestować w ten paradygmat. Aktualnie koszt wprowadzenia tego podejścia może być większy niż rozwiązanie problemu wydajności na inny sposób.

### Zakończenie

Podobało nam się, że zarówno ceremonia otwarcia jak i zamknięcia konferencji nie była sztucznie "napompowana" ani wydłużona. Organizatorzy w krótkim czasie przekazali wszystkie najważniejsze informacje. Mamy nadzieję, że do zobaczenia za rok!