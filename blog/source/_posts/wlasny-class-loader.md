---
title: Własny Class Loader
tags:
  - class loader
  - java
  - jvm
id: '3582'
categories:
  - - Java
date: 2019-01-25 12:01:57
---

![](https://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

[W poprzednim wpisie](https://codecouple.pl/2019/01/18/class-loader-w-javie/) pozyskaliśmy informację na temat wbudowanych w **JVM** **Class Loader'ów**. Dowiedzieliśmy się także, że część z nich napisana jest w **Javie**. Informacja ta sprawia, iż sami możemy napisać własny **Class Loader**. Tworzenie własnych **Class Loader'ów** jest tematem dzisiejszego wpisu, zapraszamy!
<!-- more -->
### ClassLoader

Domyślne **Class Loader'y** w większości przypadku są wystarczające. Czasami jednak zachodzi potrzeba napisania własnego. **Java** dostarcza bardzo przyjemny mechanizm do tworzenia własnych **Class Loader'ów**.  Sprowadza się to do stworzenia nowej klasy, która dziedziczy po abstrakcyjnej klasie `ClassLoader`. Należy także pamiętać o nadpisaniu metody `findClass`:

public class OwnClassLoader extends ClassLoader {

    static final String CLASSES = "classes";

    @Override
    protected Class<?> findClass(String name) {
        byte\[\] bytesFromFile = getBytesFrom(name);
        return defineClass(name, bytesFromFile, 0, bytesFromFile.length);
    }

    byte\[\] getBytesFrom(String fileName) {
        try {
            return Files.readAllBytes(Paths.get(CLASSES, fileName + ".class"));
        } catch (IOException e) {
            return new byte\[0\];
        }
    }
}

#### loadClass

Metoda ta odpowiedzialna jest za załadowanie klasy na podstawie nazwy:

protected Class<?> loadClass(String name, boolean resolve)

Na początku metoda ta sprawdza czy klasa nie została już załadowana korzystając z metody `findLoadedClass`. Jeśli klasa była już załadowana to zostaje zwrócona. Jeśli nie, to próbujemy ją załadować korzystając z **Class Loader'a** rodzica. Jeśli się udało to zwracamy tą klasę, jeśli nie to sami próbujemy ją załadować korzystając z metody `findClass`.

W metodzie `loadClass` pojawiła się także flaga `resolve`. Jest to flaga decydująca o tym czy po znalezieniu klasy powinny zostać wykonane "dodatkowe operacje". Czasami interesuje nas tylko to czy ta klasa istnieje, wtedy przekazujemy `false`. Więcej o tych "dodatkowych operacjach" w kolejnym artykule.

#### findClass

Aby odnaleźć klasę po jej pełnej nazwie musimy użyć metody `findClass`. Jest to metoda, która w domyślnej implementacji rzuca wyjątek `ClassNotFoundException`. Oznacza to, że jest to metoda, którą należy nadpisać:

protected Class<?> findClass(String name) throws ClassNotFoundException {
    throw new ClassNotFoundException(name);
}

To my w implementacji tej metody decydujemy skąd pochodzić będzie źródło danych dla naszej klasy. Musimy także pamiętać, iż metoda ta zostanie wywołana wtedy, gdy Class Loader rodzic nie znajdzie żądanej klasy u siebie.

#### defineClass

Finalna metoda `defineClass` służy do konwersji tablicy bajtów na instancję klasy. W przypadku, gdy nasza ładowana klasa ma niepoprawny format to dostaniemy błąd `ClassFormatError`:

protected final Class<?> defineClass(String name, byte\[\] b, int off, int len)

#### getParent

Kolejną istotną metodą z klasy `ClassLoader` jest metoda `getParent`. Jak [pisałem w poprzednim wpisie](https://codecouple.pl/2019/01/18/class-loader-w-javie/) **ClassLoader'y** występują **hierarchicznie**. Jeśli chcemy pobrać **rodzica** naszego **Class Loader** to używamy metody `getParent`:

public final ClassLoader getParent()

Jeśli w wyniku pobrania otrzymamy wartość `null` to oznacza, że dostaliśmy **Class Loader** z samej góry hierarchii jakim jest **Bootstrap Class Loader**.

### Github

Całość jak zawsze na [Github'ie](https://github.com/kchrusciel/CodeCouple/tree/master/ClassLoader).