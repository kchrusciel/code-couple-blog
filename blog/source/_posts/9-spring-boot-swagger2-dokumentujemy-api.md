---
title: '#10 Spring Boot - Swagger2 - dokumentujemy API'
tags:
  - java
  - spring boot
  - swagger
id: '1142'
categories:
  - - Java
  - - Spring Boot
date: 2017-01-07 11:42:18
author: 'Krzysztof Chruściel'
---

[![swagger-logo-bw](http://codecouple.pl/wp-content/uploads/2016/12/swagger-logo-bw.png)](http://codecouple.pl/wp-content/uploads/2016/12/swagger-logo-bw.png)

Aktualnie modną architekturą wśród systemów informatycznych są **mikroserwisy**. Najczęściej komunikują się one poprzez **API REST'owe,** które wykorzystuje notacje **JSON**. Często systemy te składają się z wielu **mikroserwisów,** które rozwijane są poprzez różne teamy w firmie. Jednym ze sposobów komunikacji pomiędzy teamami jest dokumentowanie całego **API REST'owego**. Narzędziem, które bardzo ułatwia dokumentowanie naszego API jest **Swagger**.
<!-- more -->
### 1\. Maven dependencies

Zacznijmy od dodania zależności **mavenowych**. Pierwsza odpowiada za funkcje core **Swagger** czyli całą funkcjonalność, natomiast druga za **GUI**.

```
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger2</artifactId>
    <version>2.6.1</version>
</dependency>
```

<dependency>
   <groupId>io.springfox</groupId>
   <artifactId>springfox-swagger-ui</artifactId>
   <version>2.6.1</version>
   <scope>compile</scope>
</dependency>

### 2\. Ustawienia Swaggera

Następnie utwórzmy sobie klasę z ustawieniami **Swaggera**.

@Configuration
@EnableSwagger2
public class SwaggerConfig {

    @Bean
    public Docket SwaggerApi() {
        return new Docket(DocumentationType.SWAGGER\_2)
                .groupName("codecouple-api")
                .apiInfo(apiInfo())
                .select()
                .apis(RequestHandlerSelectors.any())
                .paths(getSwaggerPaths())
                .build()
                .globalResponseMessage(RequestMethod.GET,
                        newArrayList(new ResponseMessageBuilder()
                                .code(500)
                                .message("500 message")
                                .responseModel(new ModelRef("Error"))
                                .build()));
    }

    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title("Spring Demo with Swagger")
                .description("Spring Demo with Swagger")
                .contact(new Contact("Krzysztof Chrusciel",
                                     "http://codecouple.pl",
                                     "email@here.pl"))
                .license("License name here")
                .licenseUrl("URL to license")
                .version("1.0.1")
                .build();
    }

    private Predicate<String> getSwaggerPaths() {
        return or(
                regex("/api.\*"),
                regex("/test.\*"));
    }
}

Adnotacja `@EnableSwagger2` uruchamia możliwości **Swaggera**. **Swagger** dostracza bardzo fajne buildery do ustawień. Najważniejszym beanem jest `Docket,` w który znajdują się główne ustawienia. Natomiast w klasie `ApiInfo` możemy ustawić informacje na temat **API**.

### 3\. Obsługiwane endpointy

W polu `paths` ustawiamy ścieżki endpointów, które będą obsługiwane przez Swaggera. Out-of-the-box metoda paths przyjmuje predykaty takie jak `regex`, `ant`, `any`, `none`. Predykatem domyślnym jest `any`. Możemy także używać wyrażeń regularnych:

private Predicate<String> getSwaggerPaths() {
    return or(
            regex("/api.\*"),
            regex("/test.\*"));
}

### 4. Globalne messages

W polu `globalResponseMessage` ustawiamy globalne **messages** dla różnych kodów statusów. W tym przykładzie dla wszystkich metod typu `GET` i kodu `500` zwracaj wiadomość "_500 message_".

.globalResponseMessage(RequestMethod.GET,
        newArrayList(new ResponseMessageBuilder()
                .code(500)
                .message("500 message")
                .responseModel(new ModelRef("Error"))
                .build()));

Wszystkie ustawienia zostały zawarte w naszej klasie `SwaggerConfig`. Od teraz aplikacja **Swaggera** znajduje się pod adresem `http://your_address/swagger-ui.html`

### [![swaggerui](http://codecouple.pl/wp-content/uploads/2017/01/swaggerUI.png)](http://codecouple.pl/wp-content/uploads/2017/01/swaggerUI.png)

### 5. Dokumentowanie API

Możemy teraz zacząć dokumentować nasze **API**. Zacznijmy od dodania pierwszego endpointa:

@GetMapping(value = "/api/book/{id}", produces = MediaType.APPLICATION\_JSON\_VALUE)
public @ResponseBody Book getBooksByTitle(@PathVariable(required = true) Long id) {
    return bookRepository.findOne(id);
}

Jak widzicie w przykładzie powyżej nie daliśmy żadnej specjalnej adnotacji natomiast **Swagger** skanuje **classpath** i odnajduje klasy adnotowane jako `@Controller` i automatycznie dodaje je do dokumentacji (chyba, że w ustawieniach zmieniliśmy `paths` i mają być skanowane na przykład tylko ścieżki, które w nazwie mają "test"). Domyślnie wyświetlany jest on jako nazwa metody `getBooksByTitle,` a adres to **\[nazwa\_metody\]Using\[typ\_meody\],** czyli `getBooksByTitleUsingGET`, `http://your_address/swagger-ui.html#!/book-controller/getBooksByTitleUsingGET`. Jeśli natomiast chcemy zmienić nazwę wyświetlaną w UI oraz adres to korzystamy z adnotacji `@ApiOperation,` gdzie `value` to nazwa w UI a `nickname` to adres URL.

@ApiOperation(value = "Add new book", nickname = "Add new book")

### 6. Specyficzne odpowiedzi dla statusów HTTP

Możemy także określić specyficzne odpowiedzi dla statusów HTTP:

@ApiResponses(value = {
        @ApiResponse(code = 200, message = "Success", response = Book.class),
        @ApiResponse(code = 401, message = "Unauthorized"),
        @ApiResponse(code = 403, message = "Forbidden"),
        @ApiResponse(code = 404, message = "Not Found"),
        @ApiResponse(code = 500, message = "Failure")}) // Swagger annotation

### 7\. Opis parametrów

W przypadku, gdy nasz endpoint przyjmuje parametr możemy go udokumentować poprzez adnotacje `@ApiImplicitParams`:

@ApiOperation(value = "Get book by id", nickname = "Get book by id")
@ApiImplicitParams({
        @ApiImplicitParam(name = "id", value = "Book's id", required = true, dataType = "long", paramType = "path", defaultValue="1")
})
@GetMapping(value = "/api/book/{id}", produces = MediaType.APPLICATION\_JSON\_VALUE)
public @ResponseBody Book getBooksByTitle(@PathVariable(required = true) Long id) {
    return bookRepository.findOne(id);
}

[![swaggeruiparameter](http://codecouple.pl/wp-content/uploads/2017/01/swaggerUIParameter.png)](http://codecouple.pl/wp-content/uploads/2017/01/swaggerUIParameter.png)

### 8. Więcej

**API Swaggera** jest bardzo rozbudowane i pozwala w bardzo prosty sposób na dokumentację **API**. Jeśli chcecie poczytać więcej zapraszam [TUTAJ](https://springfox.github.io/springfox/docs/current/).