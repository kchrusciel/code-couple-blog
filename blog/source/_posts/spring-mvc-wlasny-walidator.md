---
title: Spring MVC - własny walidator
tags: []
id: '3715'
categories:
  - - Java
date: 2019-03-01 12:01:42
---

![](https://codecouple.pl/wp-content/uploads/2018/02/spring-by-pivotal-300x98.png)

W dzisiejszym wpisie pokażę Wam jak szybko można stworzyć własny **walidator**. Spring oferuje szereg podstawowych **walidatorów**, które zaspokajają większość naszych potrzeb. Czasem jednak pojawiają się **niestandardowe** wymagania, które chcemy obsłużyć. Wtedy warto napisać swoje **własne** rozwiązanie. Zapraszam do wpisu po więcej szczegółów.
<!-- more -->
### Problem

Klient zgłosił nam **błąd**. Okazało się, że w naszej aplikacji tworzącej samochody możemy wysłać samochód z **dowolną** liczbą drzwi. Musimy dodać nową walidację sprawdzającą wartość tego pola. Chcemy przyjmować tylko i wyłącznie wartości **3 lub 5**. Próba wysłania innej wartości powinna skutkować **błędem**. Problem ten możemy rozwiązać poprzez stworzenie własnego **walidatora**, który będzie oznaczony za pomocą **adnotacji**. Dzięki temu będzie mógł być wykorzystywany w wielu miejscach.

### Adnotacja

Zacznijmy od stworzenia **adnotacji**:

@Constraint(validatedBy = ExpectedNumbersValidator.class)
@Target(ElementType.FIELD)
@Retention(RetentionPolic.RUNTIME)
public @interface ExpectedNumbers {
    int\[\] expectedNumbers();
    String message() default "";
    Class<?>\[\] groups() default {};
    Class<? extends Payload>\[\] payload() default {};
}

Musimy wskazać, którą implementację **walidatora** będziemy wykorzystywać. W naszym przypadku będzie to nasza klasa, którą stworzymy poniżej. Wybieramy jeszcze miejsce, na którym chcemy umieszczać adnotację **walidatora**. Możemy wskazać tablicę z kilkoma wartościami. W naszym przykładzie wykorzystamy element typu `ElementType.FIELD`. Ostatnia adnotacja to **retencja**, czyli wskazanie jak długo nasza **adnotacja** będzie dostępna w programie. W samej **adnotacji** dodajemy:

*   `expectedNumbers` - **tablica** przechowująca respektowane wartości
*   `message` - **wiadomość**, którą wyświetlimy w przypadku błędu, możemy od razu podać wartość domyślną (wartość po `default`)
*   `groups`, `payload` - **wymagane** przez Spring

### Implementacja walidatora

public class ExpectedNumbersValidator implements ConstraintValidator<ExpectedNumbers, Integer> {

  private int\[\] expectedNumbers;

  @Override
  public void initialize(ExpectedNumbers expectedNumbers) {
    this.expectedNumbers = expectedNumbers.expectedNumbers();
  }

  @Override
  public boolean isValid(Integer fieldValue, ConstraintValidatorContext cxt) {
    return fieldValue == null  Arrays.stream(expectedNumbers)
                                       .boxed()
                                       .collect(Collectors.toList())
                                       .contains(fieldValue);
  }
}

Stwórzmy **klasę**, która będzie **implementowała** interfejs `ConstraintValidator`. W typie generycznym wskazujemy **nazwę** adnotacji, która będzie wykorzystywała tą implementację oraz **typ** sprawdzanej wartości. Należy zaimplementować dwie metody:

*   `initialize` - służy do przypisania wartości parametrów adnotacji
*   `isValid` - tutaj umieszczamy logikę **walidacji**, zwracamy wartość `boolean`

public class CarDto {

  String model;
  @ExpectedNumbers(expectedNumbers = { 3, 5 }, message = "Wrong number of doors.")
  Integer doorNumber;
  @ExpectedNumbers(expectedNumbers = { 50, 100, 150 }, message = "Wrong number of horse power.")
  Integer horsePower;

  //constructor, getter, setter
}

Wykorzystanie stworzonej **adnotacji** sprowadza się do dodania jednej linii kodu. Jako parametry podajemy listę akceptowanych liczb (`expectedNumbers`) oraz wiadomość (`message`), którą otrzymamy w przypadku **błędu**.

@RestController
@RequestMapping("/cars")
public class CarController {

  @PostMapping
  public ResponseEntity<String> createCar(@Valid @RequestBody CarDto carToCreate, Errors errors) {
    if (errors.hasErrors()) {
      return new ResponseEntity<>(prepareErrorMessage(errors.getAllErrors()), HttpStatus.BAD\_REQUEST);
    }
    return new ResponseEntity<>(HttpStatus.OK);
  }

  private String prepareErrorMessage(List<ObjectError> errors) {
    return errors.stream()
        .map(DefaultMessageSourceResolvable::getDefaultMessage)
        .collect(Collectors.joining("\\n"));
  }
}

W kontrolerze dodajemy tylko adnotację `@Valid`, żeby uruchomić walidację na przekazanym **DTO**. W przypadku podania niepoprawnych wartości otrzymamy: ![](https://codecouple.pl/wp-content/uploads/2019/02/Screenshot-2019-02-27-at-12.50.26-266x300.png)

### GitHub

Całość na [GitHubie](https://github.com/apieszczek/CodeCouple/tree/master/CustomValidator).