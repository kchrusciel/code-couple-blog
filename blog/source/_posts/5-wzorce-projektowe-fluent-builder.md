---
title: '#5 Wzorce projektowe: Test Data Builder'
tags:
  - builder
  - Clean Code
  - design pattern
  - fluent builder
  - wzorce projektowe
id: '2638'
categories:
  - - Clean Code
  - - Java
  - - Wzorce projektowe
date: 2018-01-26 12:04:12
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/03/designPatternArt.png)

Dzisiaj na tapete bierzemy wzorzec **Test Data Builder**. Nazywany jest również **Fluent Builder'em** lub **Appender'em**. Z jego pomocą jesteśmy w stanie budować obiekty w prosty i przejrzysty sposób. Zetknęliście się kiedyś z kodem, w którym tworzenie obiektu z dużą ilością pól odbywało się przez konstruktor, a wy kilka razy musieliście sprawdzać w jakiej kolejności podawać następne parametry? Jest na to proste rozwiązanie - **Test Data Builder**.
<!-- more -->
Implementacja

Wzorzec ten ma kilka implementacji, ale każdy z nich sprowadza się do stworzenia **fluent API**. Jednym ze sposobów jest stworzenie klasy **buildera** posiadającej metodę do każdego pola, która ustawia wartość oraz zwraca obiekt **buildera**. Dzięki temu możemy ustawiać kolejne pola poprzez łańcuch wywołań metod. Klasa posiada również metodę `build()`, która wywoływana jest na końcu łańcucha. Tworzy ona nowy obiekt z ustawionymi polami i zwraca go:

class ArticleBuilder {

    private String title;

    public ArticleBuilder title(String title) {
        this.title = title;
        return this;
    }

    public Article build() {
        Article article = new Article();
        article.setTitle(title);
        return article;
    }
}

Kolejną możliwością jest stworzenie **buildera** jako wewnętrzną klasę statyczną, która podobnie jak przykład wyżej posiada do każdego pola, metody ustawiające wartość oraz zwracające obiekt **buildera**. Różnicą jest implementacja metody `build()`, która przekazuje do prywatnego konstruktora klasy budowanego obiektu (`Author`), obiekt **buildera**. Dzięki takiemu rozwiązaniu nie potrzebujemy żadnych setterów.

class Author {
    private String firstName;
    private String lastName;

    private Author(final AuthorBuilder builder) {
        this.firstName = builder.firstName;
        this.lastName = builder.lastName;
    }

    static class AuthorBuilder {
        private final String firstName;
        private String lastName;

        public AuthorBuilder (String firstName) {
            this.firstName = firstName;
        }

        public AuthorBuilder lastName(String lastName) {
            this.lastName = lastName;
            return this;
        }

        public Author build() {
            return new Author(this);
        }
    }
}

Biblioteka **Lombok** dostarcza nam gotowy mechanizm **Test Data Buildera**. Adnotacja nad daną klasą pozwala nam korzystać z **buildera** poprzez wywołanie metody `builder()` na początku łańcucha oraz metody `build()` na jej końcu. Klasa posiada tylko pola, które chcemy ustawiać, a budując obiekt nie używamy słowa kluczowego `new`. Więcej informacji na temat lombokowego buildera znajdziecie [TUTAJ](https://projectlombok.org/features/Builder).

@Builder
class Category {
    private String name;
}

Wywołanie wszystkich powyższych implementacji widzimy poniżej:

Author author =  new Author.AuthorBuilder("Agnieszka")
        .lastName("Pieszczek")
        .build();
Article article = new ArticleBuilder()
        .title("#5 Wzorce projektowe: Test Data Builder")
        .author(author)
        .creationDate(LocalDateTime.now())
        .format(Format.NORMAL\_ARTICLE)
        .category(Category.builder().name("Design Patterns").build())
        .build();

### GitHub

Całość znajdzie na [GitHubie](https://github.com/apieszczek/DesignPatterns).