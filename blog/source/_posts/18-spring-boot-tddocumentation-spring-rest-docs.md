---
title: '#18 Spring Boot – TDDocumentation -  Spring Rest Docs'
tags:
  - rest
  - spring
  - spring boot
  - spring rest docs
id: '2030'
categories:
  - - Spring Boot
date: 2017-08-25 12:05:21
author: 'Krzysztof Chruściel'
---

[![](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)

Pamiętacie wpis o [najlepszych praktykach REST'owych](http://codecouple.pl/2017/07/07/rest-architecture-best-practises/)? Jedną z wyszczególnionych tam praktyk było dokumentowanie naszego **API**. Wymieniłem tam także kilka najpopularniejszych rozwiązań. Jedno z nich, czyli **Swagger** opisałem już na blogu w artykule [#10 Spring Boot - Swagger2 - dokumentujemy API](http://codecouple.pl/2017/01/07/9-spring-boot-swagger2-dokumentujemy-api/). Dziś czas na kolejne podejście do dokumentacji, tym razem od strony testów. **Test Driven Documentation** jest techniką, która polega na tworzeniu dokumentacji w oparciu o testy.
<!-- more -->
Jak napisałem we wstępie, **Spring Rest Docs** wykorzystuje podejście, w którym pisanie dokumentacji odbywa się poprzez wykorzystanie testów. W testach tworzone są **snippety,** które następnie łączone są w jeden plik korzystając ze składni [ASCIIDoc'a](http://asciidoctor.org/). Cała dokumentacja frameworku **Spring** napisana jest przy jej użyciu. **ASCIIDoc** przetwarza tekst na **HTML**. **Spring Rest Docs** wspiera:

*   **Spring MVC Test** - wykorzystany w przykładzie
*   **REST Assured**

### 1\. Maven

Standardowo zaczynamy od dodania zależności do **Maven'a**:

<dependency>
   <groupId>org.springframework.restdocs</groupId>
   <artifactId>spring-restdocs-mockmvc</artifactId>
   <scope>test</scope>
</dependency>

Oraz musimy skonfigurować proces budowania dokumentacji:

<build>
   <plugins>
      <plugin>
         <groupId>org.asciidoctor</groupId>
         <artifactId>asciidoctor-maven-plugin</artifactId>
         <version>1.5.3</version>
         <executions>
            <execution>
               <id>generate-docs</id>
               <phase>prepare-package</phase>
               <goals>
                  <goal>process-asciidoc</goal>
               </goals>
               <configuration>
                  <backend>html</backend>
                  <doctype>book</doctype>
               </configuration>
            </execution>
         </executions>
         <dependencies>
            <dependency>
               <groupId>org.springframework.restdocs</groupId>
               <artifactId>spring-restdocs-asciidoctor</artifactId>
               <version>1.2.1.RELEASE</version>
            </dependency>
         </dependencies>
      </plugin>
   </plugins>
</build>

### 2\. Domena

Na szybko stwórzmy sobie encję **Todo**, która będzie dostępna pod endpointem `/todos`.

@Data
@AllArgsConstructor
public class Todo {

    @Id
    @GeneratedValue
    private Long id;

    private String title;
    private String description;

}

Teraz dodajmy controller:

@RestController
@RequestMapping("/todos")
class TodoController {

    @GetMapping
    @ResponseStatus(value = HttpStatus.OK)
    Todo getTodoByTitle(@RequestParam(value = "title", required = true) String title){
        return new Todo(1l, "TDD", "Description");
    }

}

### 3. Dokumentacja

Możemy zacząć pisanie testów! Jeśli zdecydowaliśmy się korzystać ze **Spring MVC Test** musimy zdefiniować `@Rule` dla klasy `JUnitRestDocumentation`, która w konstruktorze przyjmuje folder, gdzie znajdą się wygenerowane **snippety** (snippety to elementy generowane przez **Spring Rest Docs**, które umieszczamy potem w naszej dokumentacji):

@Rule
public JUnitRestDocumentation documentation = new JUnitRestDocumentation("target/generated-snippets");

Musimy teraz poinstruować nasz test, aby generował dokumentację:

@RunWith(SpringRunner.class)
@SpringBootTest
public class TodoDocumentation {

    @Rule
    public JUnitRestDocumentation documentation = new JUnitRestDocumentation("target/generated-snippets");

    @Autowired
    private WebApplicationContext context;

    @Autowired
    private TodoRepository todoRepository;

    private MockMvc mockMvc;

    @Before
    public void setUp() {
        this.mockMvc = MockMvcBuilders.webAppContextSetup(this.context)
                .apply(documentationConfiguration(this.documentation))
                .build();
    }

    @Test
    public void shouldReturnTodo() throws Exception {
        todoRepository.save(new Todo("TDD", "CodeCouple"));
        this.mockMvc.perform(
                get("/todos")
                        .param("title", "TDD")
                        .accept(MediaType.APPLICATION\_JSON))
                .andExpect(status().isOk())
                .andDo(document("todos",
                        responseFields(
                                fieldWithPath("id").description("Todo ID"),
                                fieldWithPath("title").description("Todo title"),
                                fieldWithPath("description").description("Todo description")),
                        requestParameters(
                                parameterWithName("title").description("Todo title"))));
    }

}

Ważna część dla nas zaczyna się od statycznej metody `document`. Tam umieszczamy testy odpowiedzialne za generowanie dokumentacji. Metoda `responseFields` sprawdza, czy w odpowiedzi otrzymaliśmy pola: id, title, description. Jeśli tak, to zostaną one udokumentowane wraz z opisem zawartym w `description`. Kolejna metoda `requestParameters` służy do testu i opisu parametrów zawartych w naszym **URI**. Oczywiście istnieje [dużo więcej metod](http://docs.spring.io/spring-restdocs/docs/1.2.1.RELEASE/reference/html5/).

Aby stworzyć plik **HTML** z dokumentacją należy dodać wzorcowy plik **ASIIDOC'a**, w moim przypadku dodałem plik **manual.adoc** z treścią poniżej. Domyślną ścieżką na ten plik jest `src/main/asciidoc`. Można tę ścieżkę zmienić w pluginie, należy w sekcji `build` dodać wpis `<sourceDirectory>your/path/here</sourceDirectory>`

\= Todos API Reference
CodeCouple.pl - Version 1.0.1;
:doctype: book
:icons: font
:source-highlighter: highlightjs
:toc: left
:toclevels: 4
:sectlinks:


\[\[headers\]\]
== Headers

Curl-request in CodeCouple.pl:

include::{snippets}/todos/curl-request.adoc\[\]
include::{snippets}/todos/http-request.adoc\[\]
include::{snippets}/todos/http-response.adoc\[\]

include::{snippets}/todos/response-fields.adoc\[\]
include::{snippets}/todos/request-parameters.adoc\[\]

Teraz w pierwszej kolejności uruchamiamy test, który wygeneruje nam do folderu `target/generated-snippets` snippety. Następnie odpalamy `install` w **Mavenie**. W folderze `target/generated-docs` powinien dodać nam się plik **manual.html** (ma taką samą nazwę jak nasz plik z ASCIIDoc'a). Ścieżkę, gdzie generować ma się dokumentacja możemy ustawić w sekcji `build`, należy dodać wpis `<outputDirectory>your/path/here</outputDirectory>`

### 3.1 Automatyczne budowanie

Jeśli chcemy mieć zautomatyzowany proces budowania wystarczy dodać poniższy plugin. Od teraz dla wszystkich klas z **Documetation** w nazwie generowana będzie dokumentacja przy budowaniu **Mavenowego** artefaktu.

 `<``plugin``>`

 `<``groupId``>org.apache.maven.plugins</``groupId``>`

 `<``artifactId``>maven-surefire-plugin</``artifactId``>`

 `<``configuration``>`

 `<``includes``>`

 `<``include``>**/*Documentation.java</``include``>`

 `</``includes``>`

 `</``configuration``>`

 `</``plugin``>`

### 4. Wynik

Wynikiem działania jest bardzo dobrze wyglądający HTML: [![](http://codecouple.pl/wp-content/uploads/2017/08/springRestDocs.png)](http://codecouple.pl/wp-content/uploads/2017/08/springRestDocs.png)

### 5. Github

Całość jak zawsze na [GitHubie](https://github.com/kchrusciel/Spring-Boot-Examples).