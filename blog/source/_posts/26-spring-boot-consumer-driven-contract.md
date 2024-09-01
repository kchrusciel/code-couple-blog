---
title: '#27 Spring Boot - Consumer Driven Contract'
tags:
  - cdc
  - consumer driven contract
  - spring
  - spring boot
  - spring cloud
id: '2431'
categories:
  - - Spring Boot
date: 2018-01-19 12:12:50
---

![](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)

Z każdym kolejny mikroserwisem testowanie naszej aplikacji staje się **coraz bardziej trudne** (w przypadku gdy są one ze sobą powiązane). Oczywiście możemy zamokować zachowanie innych serwisów korzystając na przykład z biblioteki **WireMock**, jednakże po wdrożeniu naszej aplikacji na produkcję okazuje się, że aplikacja nie integruje się poprawnie. A no właśnie, okazało się, iż mój serwis odpytywał zły endpoint, ale jak to możliwe, skoro wszystkie testy były uzależniająco zielone?
<!-- more -->
### Consumer Driven Contract

Testy przechodziły, ponieważ to ja sam, poprzez mockowanie określałem jak usługi, z którymi będę się komunikował będą się zachowywać (w moim przypadku zachowywały się źle w stosunku do produkcji). Rozwiązaniem tego problemu są kontrakty. **Consumer Driven Contract** to podejście, w którym do komunikacji między usługami wykorzystujemy współdzielone kontrakty. Działanie **CDC** pokażę na przykładzie dwóch aplikacji, **producer** oraz **consumer**.

### Producer - serwis z innego teamu

**Producer** jest to aplikacja, która tworzona jest przez inny team. Moja usług **consumer** będzie korzystała z endpointu `/` z usługi **producer**, która będzie zwracać użytkownika z bazy. Za nim zacznę pisać moją usługę, w uzgodnieniu z inną ekipą musimy przygotować kontrakt, który będziemy wykorzystywać do komunikacji. Zaczynamy od dodania zależności:

<dependency>
   <groupId>org.springframework.cloud</groupId>
   <artifactId>spring-cloud-starter-contract-verifier</artifactId>
   <scope>test</scope>
</dependency>

### Piszemy kontrakt

Przygotujmy teraz **pierwszy kontrakt**, dodajemy nowy plik `shouldReturnUser.groovy` (ponieważ kontrakty piszemy w **Groovym**) w naszych źródłach testowych czyli `src\test\resources\contracts`. Następnie dodajemy zawartość **kontraktu**. Dla zapytania `GET` na adresie `/` powinien być zwrócony **JSON** czyli `contentType` oraz `{"id":1, "name": "CodeCouple.pl" }` z statusem `200 OK`:

Contract.make {

    description "Should return user"

    request {
        method("GET")
        url("/")
    }

    response {
        status 200
        body(\["id":1, "name": "CodeCouple.pl"\])
        headers {
            contentType("application/json")
        }
    }

}

### Budujemy stuba

Napisaliśmy nasz pierwszy **kontrakt**, teraz musimy wygenerować **stuba**, który będzie zachowywał się jak w opisie **kontraktu**. Tak naprawdę nasz **stub**, to wygenerowany **jar**, który następnie możemy zdeployować na **Nexusie** lub w innym centralnym miejscu, do którego mają dostęp inne teamy. Domyślnie umieszczany jest on w lokalnym repozytorium **m2**. Jednakże, aby zbudować naszego **stuba** musimy dodać nowy **plugin** `spring-cloud-contract-maven-plugin` do procesu budowania:

<plugin>
   <groupId>org.springframework.cloud</groupId>
   <artifactId>spring-cloud-contract-maven-plugin</artifactId>
   <version>1.1.4.RELEASE</version>
   <extensions>true</extensions>
   <configuration>
      <baseClassForTests>pl.codecouple.producer.BaseClass</baseClassForTests>
   </configuration>
</plugin>

### Testy?

Ważne jest ustawienie `extensions` na wartość `true`, co oznacza, że w naszym procesie budowania mogą być wykorzystane inne **artefakty** (więcej [https://maven.apache.org/pom.html#Extensions](https://maven.apache.org/pom.html#Extensions)). Należy także ustawić konfigurację dla naszych testów. Zaraz, zaraz, jakich **testów**? Otóż **plugin** ten, oprócz stworzenia **stuba**, tworzy także testy. Testy te, zweryfikują czy nasza aplikacja działa zgodnie z kontraktem. Jest to bardzo dobre podejście, ponieważ mamy pewność, że nie wypuśmy stuba, który z naszą aplikacją działałby niepoprawnie. Wiemy już, iż dostaniemy testy, teraz musimy wskazać klasę bazową (wygenerowane testy będą dziedziczyć po tej klasie) dla tych testów. W naszym przypadku będzie to klasa o nazwie `BaseClass`. Nasza klasa bazowa wygląda nastepująco:

@RunWith(SpringRunner.class)
@SpringBootTest(classes = ProducerApplication.class)
public abstract class BaseClass {

    @Autowired
    UserController userController;

    @Before
    public void setUp() throws Exception {
        RestAssuredMockMvc.standaloneSetup(userController);
    }

}

Tworzymy kontroler:

@RestController
class UserController {

    @GetMapping("/")
    UserDTO getUser(){
        return UserDTO.builder()
                .id(1)
                .name("CodeCouple.pl")
                .build();
    }

}

@Builder
@Data
class UserDTO {
    private long id;
    private String name;
}

Skonfigurowaliśmy proces budowania naszego **stuba** oraz przygotowaliśmy klasy, możemy więc odpalić `mvn clean install` jeśli zdecydowaliśmy się na korzystanie z **Mavena**. W konsoli pojawi się wpis:

\[INFO\] Installing path-to-artifact\\producer-service-0.0.1-SNAPSHOT-stubs.jar to path-to-m2\\producer-service-0.0.1-SNAPSHOT-stubs.jar

W folderze `\target\generated-test-sources\contracts` znajdziemy wygenerowane automatycznie testy, które weryfikują poprawność działa usługi na podstawie kontraktu:

public class ContractVerifierTest extends BaseClass {

   @Test
   public void validate\_shouldReturnUser() throws Exception {
      // given:
         MockMvcRequestSpecification request = given();

      // when:
         ResponseOptions response = given().spec(request)
               .get("/");

      // then:
         assertThat(response.statusCode()).isEqualTo(200);
         assertThat(response.header("Content-Type")).matches("application/json.\*");
      // and:
         DocumentContext parsedJson = JsonPath.parse(response.getBody().asString());
         assertThatJson(parsedJson).field("\['id'\]").isEqualTo(1);
         assertThatJson(parsedJson).field("\['name'\]").isEqualTo("CodeCouple.pl");
   }

}

Wygenerowaliśmy **stuba**, możemy teraz wrócić do pisania naszego serwisu czy **consumera**.

### Druga strona - Consumer

Z drugiej strony, czyli już w naszym serwisie, który tworzymy, musi dodać zależności, które będą potrafiły uruchomić **stuby** z repozytorium:

<dependency>
   <groupId>org.springframework.cloud</groupId>
   <artifactId>spring-cloud-starter-contract-stub-runner</artifactId>
   <scope>test</scope>
</dependency>

Po dodaniu zależności możemy zacząć pisanie naszej logiki, która odpytywać będzie **Producer'a:**

@RestController
class ConsumerController {

    private final RestTemplate restTemplate;

    ConsumerController(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    @GetMapping("/")
    ResponseEntity<String> showCodeCouple(){
        HttpHeaders headers = new HttpHeaders();
        headers.set("Accept", MediaType.APPLICATION\_JSON\_VALUE);
        HttpEntity<?> entity = new HttpEntity<>(headers);
        return restTemplate.exchange(
                "http://producer-service/",
                HttpMethod.GET,
                entity,
                String.class);
    }
}

### Testy muszą być

Tym razem w testach nie będziemy już sami mockować zachowania innych serwisów, tylko wykorzystamy wygenerowane **stuby**. Wykorzystujemy do tego adnotację `@AutoConfigureStubRunner`. Adnotacja ta przyjmuje kilka parametrów, `workOffline`, który decyduje o tym czy stuby mają być pobierane z lokalnego repozytorium czy z repozytorium zdalnego. Kolejny parametr to `ids`, gdzie wskazujemy nazwy przygotowanych stubów.

@RunWith(SpringRunner.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.MOCK)
@AutoConfigureMockMvc
@AutoConfigureStubRunner(workOffline = true, ids = { "pl.codecouple:producer-service" })
public class ConsumerControllerIntegrationTest {

    @Autowired
    MockMvc mockMvc;

    @Test
    public void shouldReturnUser() throws Exception {
        // When
        ResultActions result = mockMvc.perform(get("/"));
        // Then
        result.andExpect(status().isOk())
            .andExpect(content().json("{\\"id\\":1,\\"name\\":\\"CodeCouple.pl\\"}"));
    }

}

Odpalamy testy, musi być kolor zielony. Teraz możemy wrócić do **producera** i zmienić coś w kontrakcie. Po zmianie, całą operację generowania należy powtórzyć. Gdy znów odpalimy testy będziemy mieli kolor czerwony, bardzo dobrze, to oznacza, że nasza aplikacja w sposób błędny integruje się z innym serwisem. Złapaliśmy to w teście! Dzięki temu unikniemy sytuacji, którą opisałem we wstępie.

### GitHub

Całość kodu znajdziecie jak zawsze na [GitHubie](https://github.com/kchrusciel/Spring-Boot-Examples).

### Więcej

Bardzo mocno polecam nagrania **Marcina Grzejszczaka** na temat **CDC** (należy wpisać na youtube Marcin Grzejszczak CDC). Fajne nagranie z **Devoxx'a** 2017, w którym **Marcin** i **Josh Long** pokazują moc kontraktów:

https://www.youtube.com/watch?v=IiK9A9nQ6NU