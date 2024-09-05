---
title: REST architecture - Best practises
tags:
  - http
  - rest
id: '1852'
categories:
  - - REST
date: 2017-07-07 12:43:37
author: 'Krzysztof Chruściel'
---

[![](http://codecouple.pl/wp-content/uploads/2017/06/restLogo.png)](http://codecouple.pl/wp-content/uploads/2017/06/restLogo.png)

Wszyscy (albo prawie wszyscy) robimy usługi **REST'owe** dla naszych **mikroserwisów**.  Jest wiele elementów które powinna spełnia architektura **REST**. W tym wpisie przedstawię wam ogólne zasady dotyczące prawidłowego projektowania **API**.
<!-- more -->
### 1. Rzeczowniki

Wszystkie **endpointy** powinny reprezentować zasoby jako rzeczowniki w liczbie mnogiej. Dzięki temu zachowujemy spójności, oraz korzystając z odpowiednich metod **HTTP** możemy wykorzystać pojedynczy adres **URI**. Agregacje danych powinny być wywoływane od najbardziej ogólnego elemety do najbardziej szczegółowego (jeśli chcemy pobrać wszystkie Todo usera o ID 1 to powinnyśmy wykorzystać adres `/users/1/todos`).  Jeśli wystawiamy operacje **CRUD** na obiekcie domenowy, załóżmy **Todo** to nasze endpointy powinny wyglądać tak:

*   **/api/todos** - wszystkie todos
*   **/api/todos/10** - todo o ID 10
*   **/api/todos/titles** - wszystkie tytuły wszystkich todos
*   **/api/users/1/todos** - todos usera o ID 1
*   **/api/users/1/todos/10** - todo o ID 10 od usera o ID 1

### 2. Metody HTTP

Do wykonywania operacji powinniśmy używać odpowiednich metod **HTTP** zgodnie z ich przeznaczeniem. Nie należy tworzyć metod w stylu `/api/addNewTodo` czy `/api/removeTodoById?id=10`, ponieważ zaburzamy konwencje i użytkownicy naszego **API** mogą się czuć zakłopotani. Różnicę pomiędzy **POST**, **PUT** i **PATCH** znajdziecie [w moim innym artykule](http://codecouple.pl/2017/06/09/15-spring-boot-post-put-czy-patch/). Tabela poniżej pokazuje zastosowanie najpopularniejszych metod **HTTP** (nie są to wszystkie metody):

\[table id=1 /\]

### 3\. Kody statusów HTTP

Kolejnym elementem na który należy zwrócić uwagę to kody statusów **HTTP.** Dzięki poprawnemu ich stosowaniu klient wie jaka jest odpowiedź z serwera. Poniżej znajduje się tabela z kodami i wyjaśnieniem.

\[table id=2 /\]

### 4. Content negotiation

Nie chciałem tego tłumaczyć jako negocjowanie treści bo brzmi to dziwnie. Jednakże chodzi tutaj o wysyłanie i odbieraniu danych w odpowiednim formacie. Projektując nasze API możemy ustalić iż przyjmuje dane tylko w formacie **JSON**. W przypadku gdy klient wyśle złe dane powinnyśmy wysłać kod `415` czyli `Unsupported Media Type`. Dbanie o odpowiednie nagłówki jest bardzo ważne bo dzięki temu jesteśmy odporni na błędne dane jednocześnie informując o tym użytkowników. Przykład w **Spring Bootcie**, w momencie gdy wyślemy dane z innym nagłówkiem niż nasz zdefiniowany w sekcji `consumes` poleci wyjątek z kodem `415`.

@PostMapping(value = "/todos",
        consumes = APIVersion.TODO\_V1,
        produces = MediaType.APPLICATION\_JSON\_VALUE)
public ResponseEntity<Void> addTodo(@RequestBody Todo todo){
    //Some logic responsible for async creating
    return ResponseEntity.accepted().location(URI.create("/todos/2")).build();
}

### 5. Wersjonowanie

W pewnym momencie działania naszej aplikacji na produkcji przychodzi zgłoszenie od biznesu, należy dodać jedno pole w modelu a w drugim usunąć. Niestety, nie możemy od tak zmienić ich w naszym kodzie, ponieważ klienci naszych usług będą dostawać kod `406 Not Acceptable` który informuje o tym że klient wysyłał niepoprawne dane lub kod `415` czyli `Unsupported Media Type`  o złym typie danych. Aby zaradzić temu problemowi musimy zastosować wersjonowanie. Wersjonowanie API często implementuje się na jeden z trzech sposób:

*   dodanie informacji o wersji na stałe w **URI** - `/api/v2/todos`
*   dodanie informacji o wersji jako parametr w **URI** - `/api/todos?ver=2`
*   wykorzystanie nagłówków `Accept` w **HTTP** - `Accept: application/vnd.codecouple.pl.todo.v2+json`

Każdy typ ma swoje wady i zalety, [polecam zapoznać się z tym wpisem](http://allegro.tech/2015/01/Content-headers-or-how-to-version-api.html).

### 6. Cache

**Cachowanie** danych może znacznie przyśpieszyć działanie naszego **API** oraz zmniejszyć ilość operacji na serwerze. Proces buforowania można zrealizować na dwa sposoby:

*   korzystając z nagłówka **Cache-Control**
*   korzystając z **ETagów**

Nagłówek **Cache-Control** oznacza na ile czasu chcemy zatrzymać aktualny stan zasobu w cache bez potrzeby pobierania nowej wersji. Długość ta definiowana jest w wartości **max-age**. W poniższym przykładzie mamy dodany cache do odpowiedzi z wartością **100 sekund**. Oznacza to że zasób w tym stanie będzie dostępny przez 100 sekund. Po tym czasie zasób zostanie zaktualizowany.

@GetMapping(value = "/todos",
        consumes = APIVersion.TODO\_V1,
        produces = MediaType.APPLICATION\_JSON\_VALUE)
public ResponseEntity<List<Todo>> showTodo(){
    Todo todoFirst = new Todo("First");
    Todo todoSecond = new Todo("Second");
    return ResponseEntity.ok().cacheControl(CacheControl.maxAge(100l, TimeUnit.SECONDS)).body(Arrays.asList(todoFirst, todoSecond));
}

Kolejnym sposobem na realizację **cachu** jest użycie **Entity Tagów** zwanych **ETagi**. W momencie zapytania o obiekt dostajemy **ETag** z unikalnym numerem obiektu. W kolejnym wywołaniu dodajemy nagłówek `If-None-Match` z tą wartości i jeśli stan obiektu się nie zmienił dostaniemy kod `304` z treścią `Not Modified`. Jeśli obiekt się zmienił dostaniemy status `200`. Aby aktywować **ETagi** w **SpringBootcie** należy dodać `ShallowEtagHeaderFilter`:

@Bean
public Filter shallowEtagHeaderFilter() {
    return new ShallowEtagHeaderFilter();
}

### 7\. Dokumentacja

Nasze API powinno być bardzo dobrze udokumentowane. Na rynku znajdują się kilka frameworków wspomagających proces tworzenia dokumentacji:

*   Swagger - [mój wpis o Swaggerze](http://codecouple.pl/2017/01/07/9-spring-boot-swagger2-dokumentujemy-api/),
*   Spring Rest Docs
*   HATEOAS
*   RAML
*   API Blueprint

Każdy z nich ma inne podejście. **Swagger** niestety doprowadza do **Annotation Hell** przez co kod staje się bardzo ciężki do czytania. Jednakże ma bardzo fajne featury na przykład dla **QA**. Wygenerowana dokumentacja pozwala na klikanie po tych **endpointach**. Podobnie jak w **Postmanie** możemy wysyłać przykładowe **JSON'y** w już przygotowanym formacie. **Spring Rest Docs** niema fajne wersji webowej z **UI** do klikania jednakże ma bardzo fajne podejście nazywane **Test-Driven Documentation**. Aby napisać fragment dokumentacji należy napisać test do **API**, który jest naszą dokumentacją. Wybór technologii zależy do nas, najważniejsze aby ta dokumentacja była taka żeby każdy, mimo że to dokumentacja chciał ją czytać!

### 8\. HATEOAS

Według [modelu dojrzałości Richardsona](https://martinfowler.com/articles/richardsonMaturityModel.html) poziom 3 jest najwyższym poziomem dojrzałości aplikacji REST'owej. Na tym poziomie znajduje się HATEOAS (ang. _Hypertext As The Engine Of Application State_). Dzięki temu dostarczamy linki dla klientów do poruszania się po naszymi API. Wyobraźmy sobie sytuację że chcemy sprawdzić jakieś konkretne Todo. Najpierw uderzamy do listy todos:

\[
    {
        id: 1,
                name: "Jan"
    },
    {
        id: 2,
                name: "Nowak"
    },
    {
        id: 3,
                name: "Tomasz"
    }
\]

Teraz aby dostać się do todo trzeciego kopiujemy id 3 i uderzamy pod adres /todos/3:

\[
   {
        id: 3,
                name: "Tomasz"
    }
\]

Korzystając z hiperłączy czyli HATEOAS od razu dostajemy linki do zasobów:

{
    name: "Jan",
            \_links: {
    self: {
        href: "http://localhost:8081/todos/1"
    },
    todo: {
        href: "http://localhost:8081/todos/1"
    }
}

### 9. Inne

Oprócz punktów powyżej powinniśmy rozważyć także kilka pozostałych elementów:

*   **stronicowanie** - każde zapytanie powinno mieć możliwość stronicowania wyników
*   **internacjonalizacja** \- w przypadku gdy projektujemy **API** które korzysta z wielu języków powinniśmy korzystać z nagłówka `Accept-Language`
*   **ograniczenie liczby żądań** - nie musi to być stosowane zawsze ale należy rozważyć ograniczenie liczby żądań na dane IP.
*   **metryki** - należy mierzyć wszystkie wartości jakie się da, ułatwia to debugowanie oraz analizę wąskich gardeł
*   **rozproszone logowanie** - w architekturze **microserwisów** powinniśmy korzystać z rozproszonego logowania korzystając na przykład z **Sleuth'a** i **Zipkina**.