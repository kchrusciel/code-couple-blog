---
title: Własny Class Loader
tags:
  - class loader
  - java
  - jvm
id: '3582'
category: Java
date: 2019-01-25 12:01:57
author: 'Krzysztof Chruściel'
---

![](https://raw.githubusercontent.com/kchrusciel/code-couple-blog-assets/main/2017/02/java-logo.png)

[W poprzednim wpisie](https://codecouple.pl/2019/01/18/class-loader-w-javie/) pozyskaliśmy informację na temat wbudowanych w **JVM** **ClassLoaderów**. Dowiedzieliśmy się także, że część z nich napisana jest w **Javie**. Informacja ta sprawia, że sami możemy napisać własny **ClassLoader**. Tworzenie własnych **ClassLoaderów** jest tematem dzisiejszego wpisu. Zapraszamy!
<!-- more -->
### ClassLoader

Domyślne **ClassLoader'y** w większości przypadków są wystarczające. Czasami jednak zachodzi potrzeba napisania własnego. **Java** dostarcza bardzo przyjemny mechanizm do tworzenia własnych **ClassLoaderów**. Sprowadza się to do stworzenia nowej klasy, która dziedziczy po abstrakcyjnej klasie `ClassLoader`. Należy także pamiętać o nadpisaniu metody `findClass`:

```java
public class OwnClassLoader extends ClassLoader {

    static final String CLASSES = "classes";

    @Override
    protected Class<?> findClass(String name) {
        byte[] bytesFromFile = getBytesFrom(name);
        return defineClass(name, bytesFromFile, 0, bytesFromFile.length);
    }

    byte[] getBytesFrom(String fileName) {
        try {
            return Files.readAllBytes(Paths.get(CLASSES, fileName + ".class"));
        } catch (IOException e) {
            return new byte[0];
        }
    }
}
```

#### loadClass

Metoda ta jest odpowiedzialna za załadowanie klasy na podstawie nazwy:

```java
protected Class<?> loadClass(String name, boolean resolve)
```

Na początku metoda ta sprawdza, czy klasa nie została już załadowana, korzystając z metody `findLoadedClass`. Jeśli klasa była już załadowana, to zostaje zwrócona. Jeśli nie, to próbujemy ją załadować, korzystając z **ClassLoadera** rodzica. Jeśli się udało, to zwracamy tę klasę, jeśli nie, to sami próbujemy ją załadować, korzystając z metody `findClass`.

W metodzie `loadClass` pojawiła się także flaga `resolve`. Jest to flaga decydująca o tym, czy po znalezieniu klasy powinny zostać wykonane "dodatkowe operacje". Czasami interesuje nas tylko to, czy ta klasa istnieje – wtedy przekazujemy `false`. Więcej o tych "dodatkowych operacjach" w kolejnym artykule.

#### findClass

Aby odnaleźć klasę po jej pełnej nazwie, musimy użyć metody `findClass`. Jest to metoda, która w domyślnej implementacji rzuca wyjątek `ClassNotFoundException`. Oznacza to, że jest to metoda, którą należy nadpisać:

```java
protected Class<?> findClass(String name) throws ClassNotFoundException {
    throw new ClassNotFoundException(name);
}
```

To my w implementacji tej metody decydujemy, skąd pochodzić będzie źródło danych dla naszej klasy. Musimy także pamiętać, że metoda ta zostanie wywołana wtedy, gdy **ClassLoader** rodzic nie znajdzie żądanej klasy u siebie.

#### defineClass

Finalna metoda `defineClass` służy do konwersji tablicy bajtów na instancję klasy. W przypadku, gdy nasza ładowana klasa ma niepoprawny format, to dostaniemy błąd `ClassFormatError`:

```java
protected final Class<?> defineClass(String name, byte[] b, int off, int len)
```

#### getParent

Kolejną istotną metodą z klasy `ClassLoader` jest metoda `getParent`. Jak [pisałem w poprzednim wpisie](https://codecouple.pl/2019/01/18/class-loader-w-javie/), **ClassLoader'y** występują **hierarchicznie**. Jeśli chcemy pobrać **rodzica** naszego **ClassLoadera**, to używamy metody `getParent`:

```java
public final ClassLoader getParent()
```

Jeśli w wyniku pobrania otrzymamy wartość `null`, to oznacza, że dostaliśmy **ClassLoader** z samej góry hierarchii, jakim jest **Bootstrap Class Loader**.

### Github

Całość jak zawsze na [Githubie](https://github.com/kchrusciel/CodeCouple/tree/master/ClassLoader).