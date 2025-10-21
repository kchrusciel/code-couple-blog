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

![](https://raw.githubusercontent.com/kchrusciel/code-couple-blog-assets/main/2017/02/java-logo.png)

**Class Loadery** to mechanizm odpowiedzialny za ładowanie klas. Pełnią one bardzo istotną rolę w trakcie działania Wirtualnej Maszyny Javy (**JVM**). Class Loadery to klasy napisane w **Javie**... No dobrze, to kto załadował pierwszą klasę? Zapraszam do wpisu, aby się tego dowiedzieć!
<!-- more -->
### ClassLoader

**Class Loader** jest mechanizmem, który ładuje klasy z postaci binarnej do postaci wykonywalnej na Wirtualnej Maszynie Javy. Klasy te ładowane są **dynamicznie**, co oznacza, że są dostarczone tylko wtedy, gdy są potrzebne, na podstawie nazwy wraz z **pakietem/ścieżką**. W Javie Class Loadery występują w **hierarchii**.

### Hierarchia

Poniższy obrazek prezentuje **hierarchię Class Loaderów**:

![](https://raw.githubusercontent.com/kchrusciel/code-couple-blog-assets/main/2018/12/class_loader_hierachy-1024x461.png)

### Bootstrap Class Loader

Pierwszym **Class Loaderem** w hierarchii jest tak zwany **Bootstrap**/**Null**/**Primordial** Class Loader. Jest to Class Loader napisany w **kodzie natywnym**, którego zadaniem jest dostarczenie wszystkich elementów z folderu `$JAVA_HOME/lib/*.jar`. Znajduje się tam między innymi `rt.jar`, który zawiera podstawowe klasy, takie jak `String` czy **kolekcje**. Ponadto ładowane są Javowe Class Loadery. Każdy kolejny typ Class Loadera jest już napisany w **Javie**.

### Extension Class Loader

Kolejny **Class Loader** jest odpowiedzialny za dostarczenie dodatkowych narzędzi, które znajdują się w folderze `$JAVA_HOME/lib/ext/*.jar` lub w dowolnym innym folderze zdefiniowanym w zmiennej systemowej `java.ext.dirs`. W folderze `ext` można znaleźć między innymi pliki binarne projektu **Nashorn** (który jest *deprecated* od Javy 11). **Extension Class Loader** jest drugim w hierarchii Class Loaderem.

### System Class Loader

Ostatnim obowiązkowym **Class Loaderem** jest **System Class Loader** (często nazywany też **Application Class Loader**). Ładuje on wszystkie **klasy**, które znajdują się na tak zwanym **classpathie**. **Classpath** to wartość, która zawiera informacje o klasach i ich ścieżkach, jakie mają być załadowane do **JVM**. Classpath można ustawić na kilka sposobów:

* **Zmienna środowiskowa**
* **Wiersz poleceń**
* **Manifest**

#### Zmienna środowiskowa

**Zmienną środowiskową** odpowiedzialną za dostarczenie ścieżek do klas jest `CLASSPATH`. W tej zmiennej przechowujemy ścieżki do plików `.class` oraz `.jar`. Ścieżki rozdzielamy znakiem `:` dla systemów **Unix/Linux/macOS** i `;` dla systemów **Windows**. Przykładowa zmienna środowiskowa to: `CLASSPATH=path/to/classes:path/to/jars`.

#### Wiersz poleceń

Podczas uruchamiania programu z **wiersza** poleceń (`java Run`) można wskazać własny **classpath**. Odbywa się to poprzez użycie przełączników `-cp` lub `-classpath`. Należy pamiętać, że tak przekazane wartości zmiennej **classpath** nadpisują zmienną globalną `CLASSPATH`. Domyślny `CLASSPATH` to folder, w którym został uruchomiony kod.

#### Manifest

Jeśli uruchamiamy aplikację jako archiwum (`java -jar`), wtedy wartości `-cp`, `-classpath` oraz `CLASSPATH` zostaną zignorowane. W przypadku archiwum, informacje o **classpathie** powinny znajdować się wewnątrz pliku **manifest** (tym razem podajemy ścieżki względne, które rozdzielamy **spacjami**):

```shell
Main-Class: pl.codecouple.Runner
Class-Path: lib/code.jar lib/couple.jar
```

### Konflikt nazw

Jeśli w `CLASSPATH` znajdują się dwie klasy o identycznych nazwach w tych samych pakietach, to tylko pierwsza z nich na **classpathie** zostanie załadowana.

### Sprawdzamy

Jeśli w naszym kodzie mamy widoczność na daną klasę, możemy pobrać **Class Loader**, przez który została załadowana:

```java
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
```

W wyniku widać, że **Class Loader** dla klasy `String` jest tak zwanym **Nullowym Class Loaderem**, ponieważ nie jest on napisany w **Javie** (jest natywny). Natomiast dwa pozostałe to już klasy **Javowe**.

### Hierarchiczność

**Class Loadery** komunikują się ze sobą w sposób **hierarchiczny** (mechanizm delegacji). Jeśli w aktualnym **Class Loaderze** ktoś zażąda klasy, która nie została jeszcze załadowana, to Class Loader odpytuje swojego **rodzica** (**Class Loadera** wyżej w **hierarchii**). Jeśli rodzic także nie posiada danego zasobu, **hierarchia** pnie się w górę. Jeśli ostatni w hierarchii **Class Loader** (w tym przypadku **Bootstrap**) nie załaduje żądanej klasy, to wtedy aktualny Class Loader sam próbuje ją załadować. Jeśli ładowanie się nie powiodło, występuje wyjątek `ClassNotFoundException` lub `NoClassDefFoundError`.

### ClassNotFoundException vs NoClassDefFoundError

Dwa wyjątki związane z **Class Loaderami** to `ClassNotFoundException` oraz `NoClassDefFoundError`.

Wyjątek **`ClassNotFoundException`** występuje wtedy, gdy **Class Loader** nie znajduje klasy na **classpathie**:

```java
@Test
void shouldThrowClassNotFoundExceptionWhenCannotFindClassOnClassPath() {
    // When
    Executable executable = () -> Class.forName("random.name");
    // Then
    assertThrows(ClassNotFoundException.class, executable);
}
```

**`NoClassDefFoundError`** występuje wtedy, gdy klasa została załadowana przez **Class Loader**, ale podczas inicjalizacji (np. w bloku statycznym) wystąpił błąd i jej definicja nie mogła zostać utworzona:

```java
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
        // Ta operacja kończy się błędem inicjalizacji
        value = 1/0;
    }

}

class MyBrokenWrapper {

    MyBrokenClass create() {
        try {
            // Pierwsza próba użycia MyBrokenClass spowoduje błąd inicjalizacji
            new MyBrokenClass();
        } catch (ExceptionInInitializerError e) {
            // Wyjątek jest łapany, ale klasa jest już "zepsuta" w JVM
        }
        // Druga próba użycia rzuca NoClassDefFoundError
        return new MyBrokenClass();
    }

}
```

### Github

Całość jak zawsze na [GitHubie](https://github.com/kchrusciel/CodeCouple/tree/master/DefaultClassLoader).