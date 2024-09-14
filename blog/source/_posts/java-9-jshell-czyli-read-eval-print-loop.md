---
title: Java 9 - JShell czyli read-eval-print loop
tags:
  - java
  - java 9
  - JShell
  - REPL
id: '2742'
categories:
  - - Java
date: 2018-03-09 12:13:28
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/02/java-logo.png)

**Java 9** jest już z nami oficjalnie od pewnego czasu, pewnie u niektórych osób działa już na produkcji. Najnowsza wersja nie przyniosła aż tak dużych zmian jak **Java 8**. Oprócz modularności czy zmian związanych ze składnią tak zwanych _syntactic sugar_, pojawił się mechanizm, który występuje w wielu innych językach, a mianowicie **REPL** (ang. _Read-Eval-Print Loop_). W **Javie 9** nazywa się **JShell** i jest najczęściej wykorzystywany do prototypowania oraz nauki języka.
<!-- more -->
### Czy wogóle warto?

Zanim zaczniesz czytać ten artykuł chciałbym przekonać Cię, że warto to narzędzie poznać. Istnieje kilka dziedzin, w których **JShell** może nam pomóc:

*   **nauka** - bardzo dobre narzędzie do nauki programowania dla juniorów
*   **sprawdzanie corner case'ów** - jeśli zdarzyło wam się przygotowywać do certyfikacji z **Javy**, bardzo często pojawiają się tam językowe "smaczki", które w łatwy sposób możemy wykonać w powłoce
*   **prototypowanie** - do prototypowania nowych featurów
*   **eskperymentowanie** - na przykład z nowymi bibliotekami

### Java 9

Aby móc zacząć zabawę z **JShell'em** należy zainstalować **Javę 9**. Jeśli nie chcemy zbytnio "śmiecić" sobie na środowisku możemy wykorzystać narzędzie [jEnv](http://www.jenv.be/) (niedostępne na **Windows'a**). Sprawdzamy czy mamy dobrą **Jave**:

$ java -version
java version "9"
Java(TM) SE Runtime Environment (build 9+178)
Java HotSpot(TM) 64-Bit Server VM (build 9+178, mixed mode)

Jeśli jesteśmy już pewni, iż mamy na środowisku **Jave 9**, uruchamiamy **JShell'a**:

$ jshell
 Welcome to JShell -- Version 9
 For an introduction type: /help intro

jshell>

### Zmienne

**Sztandarowy przykład** wykonywany przy pierwszym kontakcie z **REPL'em** to dodanie dwóch liczb:

jshell> 2+2
$1 ==> 4

Wynik naszej operacji został przypisany do zmiennej `$1`, która od teraz dostępna jest przez cały czas działania powłoki. Możemy wykorzystać tą wartość na wiele sposobów:

jshell> $1
$1 ==> 4

jshell> int x = $1
x ==> 4

jshell> $1 += 100
$4 ==> 104

### Metody

W łatwy sposób możemy deklarować także metody:

jshell> String toUpperCase(String stringToChange) {
...> return stringToChange.toUpperCase();
...> }
 created method toUpperCase(String)

jshell> toUpperCase("codecouple")
$6 ==> "CODECOUPLE"

### Klasy

Krok dalej to tworzenie klas. Tutaj działamy podobnie jak z metodami:

jshell> class Code {
...> }
 created class Code

### Komendy

**Powłoka** dostarcza nam także funkcjonalności ułatwiające pracę z nią. Dodatkowe funkcjonalności możemy uruchomić poprzez wywołania **komend**. **Komendy** w powłoce poprzedzone są znakiem `/`. Lista przydatnych **komend**:

*   **/list** - lista wywołanych poleceń
*   **/imports** - zaimportowane biblioteki (dostajemy kilka domyślnie)
*   **/methods** - dostępne metody
*   **/vars** - dostępne zmienne
*   **/types** - dostępne typy
*   **/edit** - edycja snippetu
*   **/save** - zapis snippetów
*   **/help** - chyba nie trzeba tłumaczyć ;)
*   **/reset** - czyści stan powłoki
*   **/exit** - kończymy pracę z **JShell'em**

### Edytor

Pamiętacie jeszcze **Swing'a**? Tak, taką bibliotekę **Javową** do tworzenia **UI**... Jeśli chcemy wyedytować stworzony przez nas snippet (na przykład metodę `toUpperCase`) możemy w prosty sposób wyedytować są poprzez użycie komendy `/edit nazwa_snippetu/numer_snippetu` i domyślnie objawi nam się edytor **Swing'owy**:

jshell> /edit toUpperCase

![](http://codecouple.pl/wp-content/uploads/2018/02/jshellEditor.png) Jeśli ktoś ma złe wspomnienia ze **Swing'iem**, można w łatwy sposób zmienić edytor `/set edit nazwa_naszego_edytora`.

### Podpowiadanie składni

Jeśli zaczęliśmy już tęsknić za **IDE** z powodu braku podpowiadania składni, wystarczy wcisnąć `TAB`:

jshell> Sys
System

jshell> System.out
out

jshell> System.out.print
print(     printf(    println(

jshell> System.out.print()

jshell> jshell> System.out.print()
void PrintStream.print(String s)
Prints a string.If the argument is null then the string "null" is printed. Otherwise, the
string's characters are converted into bytes according to the platform's default character
encoding, and these bytes are written in exactly the manner of the #write(int) method.

Parameters:
s - The String to be printed

### Snippety

Czasem istnieje potrzeba, aby ponownie uruchomić powłokę z już przygotowanymi **snippetami**. Możemy zrobić to w łatwy sposób korzystając z komendy `/save nazwa_pliku`:

jshell> /save mysnippets.jsh

Następnie podczas uruchamiania **JShell'a** wystarczy go wskazać

jshell mysnippets.jsh

### Więcej

Jeśli zainteresował was temat **REPL'a**, polecam wam **user's guide**:

*   [https://docs.oracle.com/javase/9/jshell/toc.htm](https://docs.oracle.com/javase/9/jshell/toc.htm)

Oraz bardzo dobre wystąpienie **Kuby Marchwickiego**: https://www.youtube.com/watch?v=sxDt5kliA2c