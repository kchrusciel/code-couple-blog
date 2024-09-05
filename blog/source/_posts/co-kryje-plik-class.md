---
title: Co kryje plik .class?
tags:
  - bytecode
  - class
id: '2931'
categories:
  - Java
date: 2018-06-15 12:01:35
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

Dziś zejdziemy poziom niżej w stosunku do kodu, z którym mamy styczność na co dzień. Postaram się pokazać wam co znajduje się w skompilowany pliku **.class** oraz jaki ma to wpływ na JVM'a na przykładzie aplikacji enterprise, czyli **HelloWorld**. W samym skompilowanym pliku oprócz **kodu bajtowego** z instrukcjami dla JVM, znajdziemy także metadane. Jeśli chcesz się dowiedzieć co dokładnie siedzi w środku, zapraszam!
<!-- more -->
### HelloWorld

Na samym początku napiszemy sobie nic innego, jak prostego enterprisowego **Hello World'a**:

```java
public class Main {

    public static void main(String[] args) {
        System.out.println("Hello World!");
    }

}
```

Po skompilowaniu kodu, sprawdzamy [bytecode](http://codecouple.pl/2016/03/20/java-bytecode/) zawarty w pliku `.class`. Aby podejrzeć **bytecode** w postaci zjadliwej dla człowieka, a nie maszyny, możemy wykorzystać narzędzie `javap`, najlepiej z przełącznikiem `-v` (lub dłuższa wersja `-verbose`):

```shell
javap -v Main
...
 Last modified 2018-06-04; size 414 bytes
 MD5 checksum 32f25b22120117d0d8533ce5b228d31c
 Compiled from "Main.java"
public class Main
 SourceFile: "Main.java"
 minor version: 0
 major version: 51
 flags: ACC_PUBLIC, ACC_SUPER 
Constant pool:
 #1 = Methodref #6.#15 // java/lang/Object."<init>":()V
 #2 = Fieldref #16.#17 // java/lang/System.out:Ljava/io/PrintStream;
 #3 = String #18 // Hello World!
 #4 = Methodref #19.#20 // java/io/PrintStream.println:(Ljava/lang/String;)V
 #5 = Class #21 // Main
 #6 = Class #22 // java/lang/Object
 #7 = Utf8 <init>
 #8 = Utf8 ()V
 #9 = Utf8 Code
 #10 = Utf8 LineNumberTable
 #11 = Utf8 main
 #12 = Utf8 (\[Ljava/lang/String;)V
 #13 = Utf8 SourceFile
 #14 = Utf8 Main.java
 #15 = NameAndType #7:#8 // "<init>":()V
 #16 = Class #23 // java/lang/System
 #17 = NameAndType #24:#25 // out:Ljava/io/PrintStream;
 #18 = Utf8 Hello World!
 #19 = Class #26 // java/io/PrintStream
 #20 = NameAndType #27:#28 // println:(Ljava/lang/String;)V
 #21 = Utf8 Main
 #22 = Utf8 java/lang/Object
 #23 = Utf8 java/lang/System
 #24 = Utf8 out
 #25 = Utf8 Ljava/io/PrintStream;
 #26 = Utf8 java/io/PrintStream
 #27 = Utf8 println
 #28 = Utf8 (Ljava/lang/String;)V
{
 public Main();
 flags: ACC_PUBLIC 
 Code:
 stack=1, locals=1, args_size=1
 0: aload_0 
 1: invokespecial #1 // Method java/lang/Object."<init>":()V
 4: return 
 LineNumberTable:
 line 1: 0

 public static void main(java.lang.String[]);
 flags: ACC_PUBLIC, ACC_STATIC 
 Code:
 stack=2, locals=1, args_size=1
 0: getstatic #2 // Field java/lang/System.out:Ljava/io/PrintStream;
 3: ldc #3 // String Hello World!
 5: invokevirtual #4 // Method java/io/PrintStream.println:(Ljava/lang/String;)V
 8: return 
 LineNumberTable:
 line 4: 0
 line 5: 8
}
```

W pliku `.class` dane przechowywane są w formacie **HEX**. Możemy podejrzeć nasz plik korzystając z dowolnego edytor'a **HEX'ów** (polecam command linowy `xxd`):

```shell
00000000: cafe babe 0000 0033 001d 0a00 0600 0f09  .......3........
00000010: 0010 0011 0800 120a 0013 0014 0700 1507  ................
00000020: 0016 0100 063c 696e 6974 3e01 0003 2829  .....<init>...()
00000030: 5601 0004 436f 6465 0100 0f4c 696e 654e  V...Code...LineN
00000040: 756d 6265 7254 6162 6c65 0100 046d 6169  umberTable...mai
00000050: 6e01 0016 285b 4c6a 6176 612f 6c61 6e67  n...(\[Ljava/lang
00000060: 2f53 7472 696e 673b 2956 0100 0a53 6f75  /String;)V...Sou
00000070: 7263 6546 696c 6501 0009 4d61 696e 2e6a  rceFile...Main.j
00000080: 6176 610c 0007 0008 0700 170c 0018 0019  ava.............
00000090: 0100 0c48 656c 6c6f 2057 6f72 6c64 2107  ...Hello World!.
000000a0: 001a 0c00 1b00 1c01 0004 4d61 696e 0100  ..........Main..
000000b0: 106a 6176 612f 6c61 6e67 2f4f 626a 6563  .java/lang/Objec
000000c0: 7401 0010 6a61 7661 2f6c 616e 672f 5379  t...java/lang/Sy
000000d0: 7374 656d 0100 036f 7574 0100 154c 6a61  stem...out...Lja
000000e0: 7661 2f69 6f2f 5072 696e 7453 7472 6561  va/io/PrintStrea
000000f0: 6d3b 0100 136a 6176 612f 696f 2f50 7269  m;...java/io/Pri
00000100: 6e74 5374 7265 616d 0100 0770 7269 6e74  ntStream...print
00000110: 6c6e 0100 1528 4c6a 6176 612f 6c61 6e67  ln...(Ljava/lang
00000120: 2f53 7472 696e 673b 2956 0021 0005 0006  /String;)V.!....
00000130: 0000 0000 0002 0001 0007 0008 0001 0009  ................
00000140: 0000 001d 0001 0001 0000 0005 2ab7 0001  ............\*...
00000150: b100 0000 0100 0a00 0000 0600 0100 0000  ................
00000160: 0100 0900 0b00 0c00 0100 0900 0000 2500  ..............%.
00000170: 0200 0100 0000 09b2 0002 1203 b600 04b1  ................
00000180: 0000 0001 000a 0000 000a 0002 0000 0004  ................
00000190: 0008 0005 0001 000d 0000 0002 000e       ..............
```

No dobra, wiemy, że nasza metoda z **HelloWorld** zawarta jest w:

…**b2** 0002 **12** 03 **b6** 0004 **b1** 0000…

Czytając po kolei możemy odczytać:

*   b2 - `getstatic` - pobiera element statyczny
*   12 - `ldc` - ładuje wartość na stos z constant pool
*   b6 - `invokevirtual` - wywołuje metodę i odkłada wynik na stosie (tutaj mamy wypisywanie, więc nic nie odkładamy na stosie)
*   b1 - `return` - to nic innego jak wyjście z metody

Jeśli wrócimy do pliku w postaci **HEX**, widzimy, iż w tym pliku znajduje się dużo więcej informacji. Oprócz **kodu bajtowego** znajdują się tutaj także informacje o klasie, które opisane są przez:

#### My Very Cute Animal Turns Savage In Full Moon Areas

![](http://www.faeriewood.com/Images/Full_size/catceltic.png)

Każda litera tego zdania ma znaczenie. Już wyjaśniam.

P.S muszą być **koty**!

### Struktura

Zanim przejdziemy do wyjaśnień opowieści o kocie, należy zapoznać się ze strutkturą skompilowanej klasy:

```shell
ClassFile {
    u4             magic;
    u2             minor\_version;
    u2             major\_version;
    u2             constant\_pool\_count;
    cp\_info        constant\_pool\[constant\_pool\_count-1\];
    u2             access\_flags;
    u2             this\_class;
    u2             super\_class;
    u2             interfaces\_count;
    u2             interfaces\[interfaces\_count\];
    u2             fields\_count;
    field\_info     fields\[fields\_count\];
    u2             methods\_count;
    method\_info    methods\[methods\_count\];
    u2             attributes\_count;
    attribute\_info attributes\[attributes\_count\];
}
```

### M - Magic Number

**Magiczny numer**, wykorzystywany jest do jednoznacznego identyfikowania typu pliku. W przypadku plików `.class` jest to **HEX** o wartości **0xCAFEBABE**. Mimo, iż pierwsze skojarzenia prowadzą nas na "_Java, kawa więc pewnie dlatego CAFE BABE_", jednakże historia tego **magic number** jest trochę inna:

> "We used to go to lunch at a place called St Michael's Alley. According to local legend, in the deep dark past, the [Grateful Dead](https://en.wikipedia.org/wiki/Grateful_Dead "Grateful Dead") used to perform there before they made it big. It was a pretty funky place that was definitely a Grateful Dead Kinda Place. When [Jerry](https://en.wikipedia.org/wiki/Jerry_Garcia "Jerry Garcia") died, they even put up a little Buddhist-esque shrine. When we used to go there, we referred to the place as Cafe Dead. Somewhere along the line it was noticed that this was a HEX number. I was re-vamping some file format code and needed a couple of [magic numbers](https://en.wikipedia.org/wiki/Magic_number_(programming) "Magic number (programming)"): one for the persistent object file, and one for classes. I used CAFEDEAD for the object file format, and in [grepping](https://en.wikipedia.org/wiki/Grep "Grep") for 4 character hex words that fit after "CAFE" (it seemed to be a good theme) I hit on BABE and decided to use it. At that time, it didn't seem terribly important or destined to go anywhere but the trash-can of history. So CAFEBABE became the class file format, and CAFEDEAD was the persistent object format. But the persistent object facility went away, and along with it went the use of CAFEDEAD - it was eventually replaced by RMI.

Jeśli wartość ta jest niepoprawna, **JVM** rzuca wyjątek typu `java.lang.ClassFormatError.`

### V - Version

Kolejna wartość określa wersję w jakiej został wygenerowany plik. Jeśli **JVM** wykryje, iż wersja pliku `.class` jest niewspierana, dostaniemy wyjątek typu `java.lang.UnsupportedClassVersionError`. Tak prezentują się wartości wersji:

*   Java SE 10 = 54 (0x36 hex)
*   Java SE 9 = 53 (0x35 hex)
*   Java SE 8 = 52 (0x34 hex)
*   Java SE 7 = 51 (0x33 hex)
*   Java SE 6.0 = 50 (0x32 hex)
*   mniejsze numery - wcześniejsze wersje

W naszym HelloWorld (Java 7 here ;)):

```
00000000: cafe babe 0000 0033 001d 0a00 0600 0f09  .......3........
```

### C - Constant Pool

Pula ta przechowuje wszystkie informacje o stałych w klasie, między innymi nazwy pól czy metod:

```shell
Constant pool:
 #1 = Methodref #6.#15 // java/lang/Object."<init>":()V
 #2 = Fieldref #16.#17 // java/lang/System.out:Ljava/io/PrintStream;
 #3 = String #18 // Hello World!
 #4 = Methodref #19.#20 // java/io/PrintStream.println:(Ljava/lang/String;)V
 #5 = Class #21 // Main
 #6 = Class #22 // java/lang/Object
 #7 = Utf8 <init>
 #8 = Utf8 ()V
 #9 = Utf8 Code
 #10 = Utf8 LineNumberTable
 #11 = Utf8 main
 #12 = Utf8 (\[Ljava/lang/String;)V
 #13 = Utf8 SourceFile
 #14 = Utf8 Main.java
 #15 = NameAndType #7:#8 // "<init>":()V
 #16 = Class #23 // java/lang/System
 #17 = NameAndType #24:#25 // out:Ljava/io/PrintStream;
 #18 = Utf8 Hello World!
 #19 = Class #26 // java/io/PrintStream
 #20 = NameAndType #27:#28 // println:(Ljava/lang/String;)V
 #21 = Utf8 Main
 #22 = Utf8 java/lang/Object
 #23 = Utf8 java/lang/System
 #24 = Utf8 out
 #25 = Utf8 Ljava/io/PrintStream;
 #26 = Utf8 java/io/PrintStream
 #27 = Utf8 println
 #28 = Utf8 (Ljava/lang/String;)V
```

Informacje z tej puli ładowane są do obszaru pamięci zwanego **permament generation** (dokładniej do **metaspace**).

### A - Access Flags

W tej części znajdziemy informacje na temat flag dostępowych do klasy:

| Nazwa flagi    | Wartość |
|----------------|:-------:|
| ACC_PUBLIC     | 0x0001  |
| ACC_FINAL      | 0x0010  |
| ACC_SUPER      | 0x0020  |
| ACC_INTERFACE  | 0x0200  |
| ACC_ABSTRACT   | 0x0400  |
| ACC_SYNTHETIC  | 0x1000  |
| ACC_ANNOTATION | 0x2000  |
| ACC_ENUM       | 0x4000  |

### T - This Class

Na kolejnych dwóch bajtach znajdziemy informacje o aktualnej klasie. Tak naprawdę przechowywany jest tutaj indeks do wpisu w **Constant Pool'u**, gdzie znajdują się bardziej szczegółowe informacje jak nazwa, czy typ klasy.

### S - Super Class

Podobnie jak **This Class** zawiera indeks do wpisu w **Constant Pool'u**. W naszym przypadku klasą **SUPER** dla klasy **Main** jest **Object**.

### IFMA - Interfaces, Fields, Methods i Attributes

Tak jak wskazują nazwy, kolejne obszary zawierają informacje o interfejsach wykorzystywanych w klasie, polach, metodach oraz o dodatkowych atrybutach.

### Ale po co mi to wszystko?

Wyobraźmy sobie skrajną sytuację, w której korzystamy z biblioteki X. Okazało się, iż w bibliotece X, ważna dla nas metoda jest typu **private** (a miała być **public** w wersji 1.1.1). Robisz zgłoszenie na **GitHub'ie**, okazuje się, że rzeczywiście jest błąd, jednakże nowa wersja będzie wydana dopiero za pół roku... Jedyne co możemy zrobić, to zmodyfikować plik `.class`. Nigdy nie mamy pewności, że ten błąd zostanie naprawiony za pół roku. Oczywiście, jest to sytuacja skrajna, ale czasem życie zmusza nas do takich rozwiązań.

Ponadto na **off-heapie** w obszarze **metaspace** znajdują się dane z załadowanej przez **classloader** klasy. Informacje, które zostały załadowane (z pliku `.class`) i są wykorzystywane w aplikacji. Warto wiedzieć, gdzie przed załadowaniem takie informacje się znajdują. Warto mieć także świadomość, iż pliki `.class` nie są zbytnio bezpieczne, jeśli możemy bez problemu zmienić modyfikator dostępu ;).