---
title: '#26 Spring Boot - Neo4j'
tags:
  - db
  - grafy
  - graph
  - Neo4j
  - spring
  - spring boot
id: '2640'
categories:
  - - DB
  - - Java
  - - neo4j
  - - Spring
  - - Spring Boot
date: 2018-01-05 12:04:13
---

![](http://codecouple.pl/wp-content/uploads/2017/02/neo4j_logo-facebook-300x156.png)

W poprzednim wpisie pokazałam [jak zainstalować Neo4j](http://codecouple.pl/2017/02/10/neo4j-instalacja/). Teraz możemy spróbować napisać prostą aplikację z użyciem **Spring Boot'a**, która wykorzystuje bazę grafową **Neo4j**.  Dzięki wykorzystaniu **Spring Data** otrzymujemy całą abstrakcję związaną z warstwą persystencji. Ponadto operacje **CRUD'owe** wywoływane są w taki sam sposób jak dla innych, znanych nam typów baz.
<!-- more -->
### Maven

Zacznijmy od dodania zależności:

<dependency>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-starter-data-neo4j</artifactId>
</dependency>

### Połączenie

Aby nawiązać połączenie z bazą **Neo4j** należy w pliku `application.properties` wskazać adres, użytkownika oraz hasło:

spring.data.neo4j.uri=http://localhost:7474/
spring.data.neo4j.username=neo4j
spring.data.neo4j.password=neo4j

Jeśli uruchamiamy bazę lokalnie na domyślnym porcie **7474** to wystarczy podać użytkownika i hasło. Domyślnie są to wartości `neo4j` zarówno dla użytkownika jak i hasła, ale przy pierwszym uruchomieniu bazy zostajemy poproszeni o zmianę hasła.

### Mapowanie

Teraz stwórzmy klasy z węzłami i relacjami. Do mapowania obiektów na grafy wykorzystywana jest biblioteka **OGM** (_ang. Object Graph Mapping_).

#### Węzły

W celu oznaczenia naszej klasy **POJO** jako węzeł używamy adnotacji `@NodeEntity`. Podobnie jak w **JPA** domyślną nazwą węzła będzie nazwa klasy, ale możemy to zmienić ustawiając wartość `label`, `@NodeEntity(label="Blog")`. Każdy węzeł, który będzie zapisany w bazie musi posiadać unikalny identyfikator typu `Long`. Jeśli nazwa pola jest różna od "id" to należy użyć adnotacji `@GraphId`, w celu jawnego oznaczenia **identyfikatora**.

#### Relacje

Relacja może być reprezentowana przez zbiór w klasie węzła, który jest adnotowany jako `@Relationship`. Każda relacja musi mieć określony typ oraz kierunek. Domyślnym typem relacji jest uppercase'owana nazwa adnotowanego zbioru. Jeśli chcemy określić swój typ to umieszczamy go pod `type`. Z kolei domyślny kierunek relacji to `OUTGOING`. Inne typy ustawiamy pod `direction`:

*   **UNDIRECTED** - brak zdefiniowanego kierunku relacji
*   **OUTGOING** - relacja wychodząca z węzła
*   **INCOMING** - relacja wchodząca do węzła

Wszystkie typy relacji dostępne są w klasie `org.neo4j.ogm.annotation.Relationship`, ale możemy również podać tą wartość jako **String** (uppercase).

@Relationship(type = "LIKE", direction = Relationship.INCOMING)

#### Relacje z właściwościami

Jeśli relacja zawiera dodatkowe właściwości musimy utworzyć dla niej nową klasę z adnotacją `@RelationshipEntity`. Typ relacji określamy tak samo jak w przypadku `@Relationship` w `type`. Zamiast kierunku definiujemy początkowy oraz końcowy węzeł relacji poprzez adnotacje `@StartNode` i `@EndNode`.

```
@RelationshipEntity(type = "STUDY")
class Studies{
    @StartNode
    Student student;
    @EndNode
    Course course;
    Date startDate;
}
```

### Implementacja

Zaczynamy od stworzenia klasy z węzłem `Blog`.

@NodeEntity
@Data
@NoArgsConstructor
public class Blog {

    @GraphId
    private Long blogId;
    private String name;

    public Blog(String name) {
        this.name = name;
    }
}

Drugi węzeł `Subscriber` posiada dodatkowo zbiór oznaczający relacje z węzłem `Blog`. Metoda `subscribe()`, pozwala nam utworzyć (dodać do zbioru) relacje pomiędzy węzłami `Blog` oraz `Subscriber`.

@NodeEntity
@Data
@NoArgsConstructor
public class Subscriber {

    private Long id;
    private String name;

    public Subscriber(String name) {
        this.name = name;
    }

    @Relationship(type = "LIKE")
    public Set<Blog> blogs;

    public void subscribe(Blog blog) {
        if (blogs == null) {
            blogs = new HashSet<>();
        }
        blogs.add(blog);
    }
}

### Repozytorium

Podobnie jak w innych typach baz, wykorzystujemy abstrakcję dostarczoną przez **Spring Data**. Nasz interfejs musi dziedziczyć po interfejsie `GraphRepository`. Dzięki temu otrzymujemy zbiór podstawowych metod:

interface SubscriberRepository extends GraphRepository<Subscriber> {
        Subscriber findByName(String name);
}

### GitHub

Cały kod z mapowaniem oraz użyciem **CRUD'owych** operacji znajdziecie na [GitHubie](https://github.com/apieszczek/SpringBoot).