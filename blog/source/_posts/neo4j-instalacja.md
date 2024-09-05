---
title: Neo4j - instalacja
tags:
  - cypher
  - db
  - grafy
  - Neo4j
id: '1417'
categories:
  - - DB
  - - neo4j
date: 2017-02-10 12:20:20
author: 'Krzysztof Chruściel'
---

![neo4j_logo](http://codecouple.pl/wp-content/uploads/2017/02/neo4j_logo-facebook-300x156.png)

Dzisiaj krótko o **bazach grafowych**, na przykładzie **Neo4j.** Bazy grafowe jak sama nazwa wskazuje wykorzystują strukturę grafów. **Neo4j** oparty jest na grafach skierowanych. Zacznijmy najpierw od tego czym są **grafy**. Jest to reprezentacja węzłów i krawędzi połączonych ze sobą. Przedstawiają one **relacje** między obiektami. Bazy grafowe wykorzystujemy jeśli bardziej niż na samych danych interesują nas powiązania/relacje między obiektami. Sieci społecznościowe są bardzo dobrym przykładem ich wykorzystania.
<!-- more -->
# Instalacja Neo4j

Wchodzimy na stronę [https://neo4j.com/](https://neo4j.com/) i pobieramy najnowszą wersję dla posiadanego przez nas systemu. W tym artykule jest to wersja **3.1.1** na Windowsa. Po pobraniu pliku uruchamiamy go i przechodzimy przez kolejne kroki instalacji.

Następnie uruchamiamy **Neo4j** i podajemy ścieżkę lub wybieramy domyślną, pod którą zapisywana będzie utworzona przez nas baza. Następnie naciskamy przycisk _Start_ uruchamiając server.

![neo4j_install](http://codecouple.pl/wp-content/uploads/2017/02/neo4j_install.png)  

Po poprawnym uruchomieniu powinniśmy otrzymać komunikat, że **Neo4j** jest gotowy i znajdziemy go pod adresem [http://localhost:7474/](http://localhost:7474/). Port **7474** jest portem domyślnym.

![neo4j_start](http://codecouple.pl/wp-content/uploads/2017/02/neo4j_start.png)

W pasku po lewej stronie znajdziemy m.in. ustawienia, informacje o bazie, serwisy cloudowe, dokumentacje oraz informacje o samym **Neo4j.** Na górze jest pasek, w który wpisujemy grafowe zapytania w języku **Cypher**. Poniżej jest strona startowa. Po wykonaniu zapytania pojawią się w tym miejscu wyniki.

 

# Cypher

Teraz przejdźmy do kilku prostych zapytań. Zaczniemy od stworzenia nowego węzła wpisując w pasku na górze:

CREATE (codecouple:Blog {name:"CodeCouple"})
RETURN codecouple

Otrzymujemy pierwszy węzeł typu _Blog_ z nazwą _CodeCouple._ Dzięki poleceniu _return_ wyświetlamy wynik od razu na ekran.

![neo4j_result2](http://codecouple.pl/wp-content/uploads/2017/02/neo4j_result2.png)

Następnie tworzymy w ten sam sposób drugi węzeł typu _Person_ z nazwą _You._

CREATE (you:Person {name:"You"})

Teraz połączmy stworzone przez nas węzły. Przypisujemy węzły do zmiennych, tworzymy relację i wyświetlamy całość.

MATCH (you:Person {name:"You"})
MATCH (codecouple:Blog {name:"CodeCouple"})
CREATE (you)-\[like:LIKE\]->(codecouple)
RETURN you,like,codecouple

![neo4j_result3](http://codecouple.pl/wp-content/uploads/2017/02/neo4j_result3.png)

Wchodząc w panelu bocznym w _Database Information -> Node labels_ widzimy wszystkie utworzone przez nas typy węzłów. Klikając na poszczególne, jesteśmy w stanie zobaczyć wszystkie dane. W _Database Information -> Relationship types_ możemy z kolei podejrzeć wszystkie relacje.   W następnym wpisie pokażę jak łączyć się z Neo4j i modelować swoje struktury grafowe za pomocą Javy.