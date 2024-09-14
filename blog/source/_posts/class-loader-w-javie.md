---
title: Domyślne Class Loadery w Javie
tags:
  - class loader
  - java
  - jvm
id: '3540'
categories:
  - - Java
date: 2019-01-18 12:01:57
author: 'Krzysztof Chruściel'
---

![](https://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

**ClassLoader'y** są mechanizmem odpowiedzialnym za ładowanie klas. Pełnią one bardzo istotną rolę w trakcie działania wirtualnej maszyny Javy. **ClassLoader'y** są to klasy napisane w **Javie**, no dobra to kto załadował pierwszą klasę? Zapraszam do wpisu, aby się tego dowiedzieć!
<!-- more -->
### ClassLoader

**ClassLoader** jest mechanizmem, który ładuje klasy z postaci binarnej do postaci wykonywalnej na wirtualnej maszynie Javy. Klasy te ładowane są **dynamicznie** co oznacza, iż dostarczone są tylko wtedy, gdy są potrzebne na podstawie nazwy wraz z **pakietem/ścieżką**. W Javie **ClassLoader'y** występują w **hierarchii**.

### Hierarchia

Poniższy obrazek prezentuje **hierachię** **ClassLoader'ów**:

![](https://codecouple.pl/wp-content/uploads/2018/12/class_loader_hierachy-1024x461.png)

### Bootstrap Class Loader

Pierwszym **Class Loader'em** w hierarchii jest tak zwany **Bootstrap**/**Null**/**Primordial** Class Loader. Jest to **Class Loader** napisany w kodzie natywnym, którego zadaniem jest dostarczenie wszystkich elementów z folderu `$JAVA_HOME/lib/*.jar`. Znajduję się tam między innymi `rt.jar`, które zawiera podstawowe klasy jak `String` czy **kolekcje**. Ponadto ładowane są Javowe **Class Loader'y**. Każdy kolejny typ **Class Loader'a** jest już napisany w **Javie**.

### Extension Class Loader

Kolejny **Class Loader** odpowiedzialny jest za dostarczenie dodatkowych narzędzi, które znajdują się w folderze `$JAVA_HOME/lib/ext/*.jar` lub w każdym innym dowolnym folderze zdefiniowanym w zmiennej systemowej `java.ext.dirs`. W folderze `ext` możemy znaleźć między innymi binaria projektu **Nashorn** (który jest deprecated od Javy 11). **Extension Class Loader** jest drugim w hierarchii **Class Loader'em**.

### System Class Loader

Ostatnim obowiązkowym **Class Loader'em** jest **System Class Loader**. Ładuje on wszystkie **klasy**, które znajdują się na tak zwanym **class path'ie**. **Class Path** jest to wartość, która zawiera informacje o klasach i ich ścieżkach jakie mają być załadowane do **JVM'a**. **Class Path** można ustawić na kilka sposobów:

*   **Zmienna środowiskowa**
*   **Wiersz poleceń**
*   **Manifest**

#### Zmienna środowiskowa

**Zmienną środowiskową** odpowiedzialną za dostarczenie ścieżek do klas jest `CLASSPATH`. W tej zmiennej środowiskowej przechowujemy ścieżki do plików `.class` oraz `.jar`. Ścieżki rozdzielamy znakiem `:` dla systemów **Unix** i `;` dla systemów **Windows**. Przykładowa zmienna środowiskowa `CLASSPATH=path/to/classes;path/to/jars`.

#### Wiersz poleceń

Podczas uruchamiania programu z **wiersza** poleceń `java Run` można wskazać własny **class path**. Wykonuje się to poprzez użycie przełączników `-cp` lub `-classpath`. Należy pamiętać o tym, iż tak przekazane wartości zmiennej **class path** nadpisują zmienną globalną `CLASSPATH`. Domyślny `CLASSPATH` to folder, w którym został uruchomiony kod.

#### Manifest

Jeśli uruchamiamy aplikację jako archiwum `java -jar` wtedy wartości `-cp`, `-classpath` oraz `CLASSPATH` zostaną zignorowane. W przypadków archiwum informacje o **class path'ie** powinny znajdować się wewnątrz pliku **manifest** (tym razem podajemy ścieżki względne, które rozdzielamy **spacjami**):

Main-Class: pl.codecouple.Runner
Class-Path: lib/code.jar lib/couple.jar

### Konflikt nazw

Jeśli w `CLASSPATH` znajdują się dokładnie dwie takie same nazwy klas w tych samych pakietach to tylko pierwsza z nich na **class path'ie** zostanie załadowana.

### Sprawdzamy

Jeśli w naszym kodzie mamy widoczność na daną klasę to możemy pobrać z niej **Class Loader**, przez który została załadowana:

@Test
void shouldReturnNullClassLoaderWhenLoadStringClass() {
    // Given
    Class<String> stringClass = String.class;
    // When
    ClassLoader classLoader = stringClass.getClassLoader();
    // Then
    assertThat(classLoader).isNull();
}

@Test
void shouldReturnExtensionClassLoaderWhenLoadExtensionClass() {
    // Given
    Class<Shell> extensionClass = Shell.class;
    // When
    ClassLoader classLoader = extensionClass.getClassLoader();
    // Then
    assertThat(classLoader).isNotNull();
    assertThat(classLoader).isInstanceOf(getExtensionClassLoaderClass());
}

@Test
void shouldReturnApplicationClassLoaderWhenLoadApplicationClass() {
    // Given
    Class<MyClass> applicationClass = MyClass.class;
    // When
    ClassLoader classLoader = applicationClass.getClassLoader();
    // Then
    assertThat(classLoader).isNotNull();
    assertThat(classLoader).isInstanceOf(getApplicationClassLoaderClass());
}

W wyniku widać, iż **Class Loader** dla klasy `String` jest tak zwanym **Nullowym Class Loader'em**, ponieważ nie jest on napisany w **Javie**. Natomiast dwa pozostałe to już klasy **Javowe**.

### Hierarchiczność

**Class Loader'y** komunikują się ze sobą w sposób **hierarchiczny**. Jeśli w aktualnym **Class Loader'rze** ktoś zażąda klasy, która nie została jeszcze załadowana to **Class Loader** odpytuje swojego **ojca** (**Class Loader'a** wyżej w **hierarchii**). Jeśli ojciec także nie posiada danego zasobu **hierarchia** pnie się w górę. Jeśli ostatni w hierachii **Class Loader** (w tym przypadku **Bootstrap**) nie załaduje żądanej klasy, to wtedy aktualny Class Loader próbuje ją załadować. Jeśli ładowanie się nie powiodło to występuje wyjątek `ClassNotFoundException` lub `NoClassDefFoundError`.

### ClassNotFoundException vs NoClassDefFoundError

Dwa wyjątki związane z **Class Loader'ami** to `ClassNotFoundException` oraz `NoClassDefFoundError`. Wyjątek `ClassNotFoundException` występuje wtedy, gdy **Class Loader** nie znajduje klasy na **class path'ie**:

@Test
void shouldThrowClassNotFoundExceptionWhenCannotFindClassOnClassPath() {
    // When
    Executable executable = () -> Class.forName("random.name");
    // Then
    assertThrows(ClassNotFoundException.class, executable);
}

`NoClassDefFoundError` występuje wtedy, gdy klasa została załadowana przez **Class Loader**, ale podczas tworzenia nowej instancji lub ładowania jej wystąpił błąd (ten test był cięższy do napisania):

@Test
void shouldThrowNoClassDefFoundErrorWhenCannotLoadClass() {
    // Given
    MyBrokenWrapper wrapper = new MyBrokenWrapper();
    // When
    Executable executable = wrapper::create;
    // Then
    assertThrows(NoClassDefFoundError.class, executable);
}

class MyBrokenClass {

    static int value;

    static {
        value = 1/0;
    }

}

class MyBrokenWrapper {

    MyBrokenClass create() {
        try {
            new MyBrokenClass();
        } catch (ExceptionInInitializerError e) {

        }
        return new MyBrokenClass();
    }

}

### Github

Całość jak zawsze na [Github'ie](https://github.com/kchrusciel/CodeCouple/tree/master/DefaultClassLoader).