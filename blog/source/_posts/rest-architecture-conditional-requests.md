---
title: REST architecture - Conditional requests
tags:
  - rest
id: '1953'
categories:
  - - REST
date: 2017-07-28 12:04:11
author: 'Krzysztof Chruściel'
---

[![](http://codecouple.pl/wp-content/uploads/2017/06/restLogo.png)](http://codecouple.pl/wp-content/uploads/2017/06/restLogo.png)

Mechanizm **Conditional requests** czyli warunkowych zapytań służy do optymalizacji żądań **HTTP**. Bardzo często odpytujemy o dany zasób po mimo iż jego stan się nie zmienił. W odpowiedzi dostajemy cały zasób i musimy zaimplementować logikę porównywania czy pojawiła się jakaś zmiana w obiekcie. Jednakże standard **HTTP** dostarcza nam mechanizmy do realizacji tego zagadnienia, są to słabe oraz silne nagłówki **cachowania**.
<!-- more -->
Mechanizm ten powinien być wykonywany dla operacji odczytu (ang. _read_). W momencie wysłania warunkowego żądania sprawdzany jest żądany zasób, czy zmienił się w stosunku do ostatniego wywołania. Nie jest to sprawdzanie bajt po bajcie tylko odbywa się to przy wykorzystaniu **validatorów**. Rozróżniamy dwa typy validatorów:

*   data ostatniej modyfikacji zawarta w nagłówku **Last-Modified**
*   wartość typu **String** przechowująca numer wersji nazywana **Entity Tag** lub **ETag**

Samo porównywanie wartości może odbywać się na dwa sposoby:

*   **słaba walidacja** kiedy mogą wystąpić "drobne" różnice
*   **silna walidacja** kiedy każdy bajt musi się zgadzać

HTTP domyślnie używa silnej walidacji. Natomiast do wykonywanie warunkowych zapytań wykorzystujemy warunkowe nagłówki:

*   **If-None-Match** dla **ETagów**
*   **If-Modified-Since** dla **Last-Modified**

Przykładowe flow znajduje się poniżej. Pierwsze wykonanie to wysłanie żądania **GET** o dowolny zasób. W odpowiedzi dostajemy ten zasób wraz z dwoma nagłówkami **ETag** oraz **Last-Modified**. Jeden z nich jest nadmiarowy, do realizacji warunkowych żądań wystarczy jeden mechanizm, ja po prostu chciałem zaprezentować dwa od razu.

[![](http://codecouple.pl/wp-content/uploads/2017/06/conditionalRequest1.png)](http://codecouple.pl/wp-content/uploads/2017/06/conditionalRequest1.png)

Teraz jeśli chcemy sprawdzić czy zasób się zmienił nie musimy ponownie odpytywać o cały zasób. Wystarczy wykorzystać odpowiednie nagłówki. Dla **ETag** należy dodać **If-None-Match** z wartością otrzymaną za pierwszym razem natomiast dla **Last-Modified** należy użyć **If-Modified-Since** z datą otrzymaną wcześniej. Jeśli zasób się nie zmienił powinniśmy otrzymać kod **304 Not Modified**. W przypadku gdy zasób zmienił się od tego czasu otrzymamy kod **200** wraz z tym zasobem oraz nową wersją **ETagu** i z zaktualizowaną datą **Last-Modified**.

[![](http://codecouple.pl/wp-content/uploads/2017/06/conditionalRequest2.png)](http://codecouple.pl/wp-content/uploads/2017/06/conditionalRequest2.png)

W **Springu** możemy zrealizować **ETagi** na dwa sposoby. Pierwszy z nich to wykorzystanie adnotacji `@Version` z pakietu `javax.persistence,` która umieszczona na polu przechowującym wersję będzie ją automatycznie aktualizować:

@Data
@Entity
@RequiredArgsConstructor
public class Todo {

    @Id @GeneratedValue
    private Long id;

    @Version
    private Long version;

    private String content;

    public Todo(String content) {
        this.content = content;
    }

Natomiast drugim sposobem jest dodanie beany `ShallowEtagHeaderFilter`:

@Bean
public Filter shallowEtagHeaderFilter() {
    return new ShallowEtagHeaderFilter();
}

Jedyną różnicą pomiędzy tymi rozwiązaniami jest rodzaj generowanego **ETagu**. W przypadku `@Version` tag generowany jest od zera. W drugim rozwiązaniu tag wygląda na losowy ciąg na przykład: 03f91e84687eb66da6e5479c563dd6c9d. Aby sprawdzić poprawność działania można wykorzystać POSTMan'a lub jak **najbardziej testy**!

@Test
public void shouldReturnETag() throws Exception {
    todoRepository.save(new Todo("content"));

    MockHttpServletResponse response = mvc.perform(get("/todos/1"))
            .andExpect(header().string(ETAG, is(notNullValue())))
            .andReturn().getResponse();

    mvc.perform(get("/todos/1").header(IF\_NONE\_MATCH, response.getHeader(ETAG)))
            .andExpect(status().isNotModified())
            .andExpect(header().string(ETAG, is(notNullValue())))
            .andReturn().getResponse();
}

Jeśli natomiast chcemy wykorzystać mechanizm **If-Modified-Since** musimy wykorzystać audyty **JPA**. Mechanizm audytów będzie automatycznie aktualizował pole które przechowuje datę ostatnie modyfikacji:

@Data
@Entity
@RequiredArgsConstructor
@EntityListeners(AuditingEntityListener.class)
public class Todo {

    @Id @GeneratedValue
    private Long id;

    @JsonIgnore
    @LastModifiedDate
    private LocalDateTime lastModifiedDate;

    private String content;

    public Todo(String content) {
        this.content = content;
    }
}

Należy pamiętać także o dodaniu adnotacji `@EnableJpaAuditing` na naszej aplikacji. Test do sprawdzenia działania:

@Test
public void shouldReturnLastModified() throws Exception {
    todoRepository.save(new Todo("content"));

    MockHttpServletResponse response = mvc.perform(get("/todos/1"))
            .andExpect(header().string(LAST\_MODIFIED, is(notNullValue())))
            .andReturn().getResponse();

    mvc.perform(get("/todos/1").header(IF\_MODIFIED\_SINCE, response.getHeader(LAST\_MODIFIED)))
            .andExpect(status().isNotModified())
            .andExpect(header().string(LAST\_MODIFIED, is(notNullValue())))
            .andReturn().getResponse();
}