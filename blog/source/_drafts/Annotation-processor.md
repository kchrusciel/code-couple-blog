---
title: Annotation processor
tags:
  - annotation processor
id: '3158'
categories:
  - - Java
---

![](http://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)W dzisiejszym artykule opisze wam jak stworzyć własny **annotation processor**. Niewiele osób zna ten **mechanizm**, ale bardzo wielu z nas z niego korzysta (jeśli używacie **Lomboka**). Może on być przydatnym narzędziem do **tworzenia** plików w trakcie kompilacji jak i do dodania dodatkowej **walidacji**.
<!-- more -->
### Annotation Processor

**Annotation processor** jest mechanizmem uruchamianym w trakcie kompilacji. Wszystkie processory wyszukiwane są poprzez **classpath**. Mogą one być wykorzystane do:

*   tworzenia **nowych** plików
*   tworzenia **nowych** klas
*   dodania walidacji w procesie kompliacji (przykładowo `@NonNull`)
*   wyświetlania informacji jak issue, note, warning i error (jeśli wypieszemy error przerywa on kompilacje)

Nie powinny być wykorzystywane do **modyfikacji** istniejących plików (jak robi to **Lombok**, ale o tym kiedy indziej ;)) tylko do **tworzenia** nowych.

### Tworzymy adnotacje

Zaczynamy od stworzenia adnotacji, która będzie przetwarzana przez **annotation processor**:

@Retention(RetentionPolicy.SOURCE)
@Target(ElementType.TYPE)
public @interface NoArgsConstructor {
}

### Tworzymy Annotation Processor

Po stworzeniu adnotacji chcielibyśmy ją przetworzyć. Aby to zrobić musimy utworzyć **annotation processor**. Każdy processor musi określić kilka informacji:

*   adnotacje, które mają być przetwarzane
*   wersja **Javy** dla której **processor** jest wspierany

W pakiecie Java otrzymujemy klasę `javax.annotation.processing.AbstractProcessor` po której należy podziedziczyć (do tworzenia możemy także wykorzystać interfejs `javax.annotation.processing.Processor` (który i tak  jest implementowany przez `AbstractProcessor`). Logiką przetwarzania adnotacji odbywa się w metodzie `process`:

@SupportedAnnotationTypes("pl.codecouple.NoArgsConstructor")
@SupportedSourceVersion(SourceVersion.RELEASE\_8)
class NoArgsConstructorAnnotationProcessor extends AbstractProcessor {
    @Override
    public boolean process(Set<? extends TypeElement> annotations,
                           RoundEnvironment roundEnv) {
        return false;
    }
}

Informacje o wspieranej wersji **Javy** umieszczamy w adnotacji `@SupportedSourceVersion`. Adnotacja `@SupportedAnnotationTypes` przyjmuje tablicę Stringów (ponieważ wspierane są znaki `*`), w której podajemy pełną nazwę wspieranych adnotacji.

### Annotation Processor a kompilacja

Powinniśmy wyłączać inne **annotation processory** podczas **kompilacji** naszego processora.  Związane jest to ze środowiskiem w którym kompilujemy nasz processor. Może zdarzyć się sytuacja, w której przy kompilowaniu naszego processora najpierw zostanie użyty annotation processor (który właśnie kompilujemy) i powstaną błędy.

### Rejestracja

Aby móc korzystać z **annotation processora** musimy go zarejestrować. Można to wykonać na kilka sposobów korzystając z:

*   kompilatora
*   META-INF
*   biblioteki **AutoService**
*   Maven'a
*   IDE

### Kompilator

Najbardziej podstawowym sposobem wskazania **annotation processora** jest użycie przełącznika `-processor` (processor musi być wcześniej skompilowany) w kompilatorze:

javac -processor pl.codecouple.NoArgsConstructorAnnotationProcessor Test.java

### META-INF

Wskazywanie **annotation processora** podczas kompliacji nie jest wygodnym rozwiązaniem. Możemy wykorzystać do tego mechnizm `ServiceLoader` wprowadzony w **Javie 6**.  W pliku `META-INF/services/javax.annotation.processing.Processor` należy podać pełną nazwę klasy (z pakietem) **annotation processora**:

pl.codecouple.AnnotationProcessor

### AutoService

Jeśli nie chcemy dodawać za każdym razem serwisu do pliku `META-INF/services/javax.annotation.processing.Processor` lub pamiętać o jego aktualizacji w przypadku zmiany nazwy pakietu lub klasy możemy wykorzystać bibliotekę **AutoService**:

<dependency>
  <groupId>com.google.auto.service</groupId>
  <artifactId>auto-service</artifactId>
  <version>${version}</version>
  <optional>true</optional>
</dependency>

Od teraz możemy zaadonotować klasy odpowiedzialne za przetwarzanie adnotacji wykorzystując adnotację `@AutoService(Processor.class)`:

@AutoService(Processor.class)
class AnnotationProcessor extends AbstractProcessor {
    // logic
}

Dzięki temu automatycznie zostanie wygenerowany plik z serwisami `META-INF/services/javax.annotation.processing.Processor`:

pl.codecouple.AnnotationProcessor

### Annotation Processor a Maven

Jeśli chcemy wykorzystać annotation processor w projekcie **Maven** musimy pamiętać o kolejności modułów. Moduł z annotation processorem musi być skompilowany jako pierwszy! Aby wskazać annotation processor w fazie kompilacji umieszczamy w pliku `pom.xml`:

<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
            <version>3.6.1</version>
            <configuration>
                <annotationProcessors>
                    <annotationProcessor>
                        pl.codecouple.AnnotationProcessor
                    </annotationProcessor>
                </annotationProcessors>
            </configuration>
        </plugin>
    </plugins>
</build>

### Annotation Processor a Eclipse

Annotation processory możemy z powodzeniem wykorzystywać w IDE. Jeśli chodzi o **Eclipse** robimy to poprzez:

1.  Prawy przycisk myszy na projekcie i wybieramy Properties
2.  Otwieramy Java Compiler -> Annotation Processing i zaznaczamy "Enable annotation processing"
3.  Otwieramy Java Compiler -> Annotation Processing -> Factory Path i zaznaczamy "Enable project specific settings". Dodajemy JAR z processorem
4.  Clean i build na projekcie

**Eclipse** od razu będzie podkreślał nam błędy w kodzie jeśli zwrócimy error message: ![](http://codecouple.pl/wp-content/uploads/2018/09/eclipseAnnotationProcessor.png)

### Annotation Processor a IntelliJ

Podobnie jak Eclipse **IntelliJ** daje nam możliwość włączenia annotation processora:

1.  Wchodzimy do Settings
2.  Otwieramy Build, Execution, Deployment -> Compiler -> Annotation Processor i zaznaczamy "Enable annotation processing"
3.  Wskazujemy JAR z processorem lub zostawimy domyślne skanowanie class path'a
4.  Rebuild projektu

Niestety, w przeciwieństwie do Eclipse **IntelliJ** nie podkreśla on błędów kompilacji powstałych w wyniku uruchomienia **annotation processora** w edytorze (chociaż raz **IntelliJ** jest gorszy ;)).

### Github

Całość jak zawsze na GitHub'ie.