---
title: SableCC + IntelliJ - krótka instrukcja obsługi
tags:
  - gramatyka
  - Intellij Idea
  - interpreter
  - java
  - kompilator
  - parser
  - SableCC
  - token
id: '585'
categories:
  - - Java
date: 2016-06-02 08:00:36
author: 'Krzysztof Chruściel'
---

**SableCC** jest generatorem parserów dla Javy. Więcej informacji możecie znaleźć [TUTAJ](http://www.sablecc.org/). W swoim artykule chciałam skupić się na konfiguracji IntelliJ, skompilowaniu prostej gramatyki napisanej właśnie w **SableCC** i przetestowaniu jej z wykorzystaniem własnego interpretera napisanego w Javie.
<!-- more -->
Zacznijmy od pobrania programu. [TUTAJ](http://www.sablecc.org/downloads) znajdziecie najnowszą stabilną wersję sableCC, którą należy pobrać i rozpakować. Do poprawnego działania potrzebne będzie nam JDK w odpowiedniej wersji. Teraz przystąpmy do ustawień. Otwórzmy okno _Project Settings_ (CTRL+ALT+SHIFT+S) -> zakładka _Modules ->_ karta _Dependencies._ Klikając na plusa (ATL+INSERT) dodajmy plik .JAR z folderu _lib_ w lokalizacji, w której rozpakowaliśmy paczkę z sableCC.   ![Bez tytułu1](http://codecouple.pl/wp-content/uploads/2016/05/Bez-tytułu1.jpg) Teraz stwórzmy plik z gramatyką (\*.sable) i dodajmy go do naszego projektu. Dla przykładu stworzyłam gramatykę (grammar.sable) bardzo prostego kalkulatora.

Package calculator ;

Helpers
    digit = \['0' .. '9'\] ;
    add = '+';
    sub = '-';
    div = '/';
    multi = '\*';

Tokens
    integer = digit+;
    operation = add  sub  div  multi;

Productions
    program = \[left\]:integer operation \[right\]:integer;

Co tak naprawdę znajduje się w naszej gramatyce:

*   **package:** nazwa pakietu, w którym mają nam się tworzyć parsery i leksery po skompilowaniu gramatyki,
*   **helpers:** pomocnicze znaki, które wykorzystujemy do tworzenia tokenów,
*   **tokens:** podstawowe jednostki leksykalne,
*   **productions:** reguły naszej gramatyki.

Następnie stworzymy narzędzie do kompilowania naszej gramatyki. Wejdźmy w ustawienia (CTRL+ALT+S) -> _Tools_ -> _External Tools._ Klikając na plusa (ALT+INSERT) dodajmy nowe narzędzie. ![Bez tytułu2](http://codecouple.pl/wp-content/uploads/2016/05/Bez-tytułu2.jpg) Teraz ustawmy wszystkie potrzebne pola:

*   **Name:** nazwa naszego narzędzia, np. _"SableCC Compiler",_
*   **Program:** ścieżka do pliku _javaw.exe_ z folderu JDK,
*   **Parameters:** \-classpath <ścieżka do pliku sablecc.jar> org.sablecc.sablecc.SableCC <ścieżka do naszego pliku z gramatyką>

![Bez tytułu3](http://codecouple.pl/wp-content/uploads/2016/05/Bez-tytułu3.jpg) Mamy już wszystko, co potrzebne do skompilowania gramatyki, więc do dzieła. Wyszukujemy nasz plik z gramatyką w strukturze projektu, a następnie prawym przyciskiem myszy wybieramy _ExternalTool_ i nasze narzędzie (SableCC Compiler). ![Bez tytułu5](http://codecouple.pl/wp-content/uploads/2016/05/Bez-tytułu5.jpg) Po skompilowaniu powinny nam się pojawić 4 nowe pakiety (analysis, lexer, parser, node) w pakiecie, który podaliśmy w pliku z gramatyką. ![Bez tytułu7](http://codecouple.pl/wp-content/uploads/2016/05/Bez-tytułu7.jpg) Ostatnim krokiem zostało napisanie kompilatora, który odczyta naszą gramatykę i zwróci odpowiedni wynik. Dodajmy nową klasę _Interpreter:_

package calculator.interpreter;

import calculator.analysis.DepthFirstAdapter;
import calculator.node.AProgram;

/\*\*
 \* Created by CodeCouple
 \*/
public class Interpreter extends DepthFirstAdapter {
    public void caseAProgram(AProgram node) {
        String l = node.getLeft().getText().trim();
        String r = node.getRight().getText().trim();
        String sign = node.getOperation().getText().trim();

        double left = new Double(l).doubleValue();
        double right = new Double(r).doubleValue();
        double result = 0;

        switch(sign) {
            case ("+"):
                result = left + right; break;
            case ("-"):
                result = left - right; break;
            case ("\*"):
                result = left \* right; break;
            case ("/"):
                result = left / right; break;
        }
        System.out.println(left + " " + sign + " " + right + " = " + result);
    }
}

Oraz klasę startową _Main:_

package calculator.runner;

import calculator.interpreter.Interpreter;
import calculator.lexer.Lexer;
import calculator.node.Start;
import calculator.parser.Parser;

import java.io.\* ;

/\*\*
 \* Created by CodeCouple
 \*/
public class Main {
    public static void main(String\[\] args) {
        if (args.length > 0) {
            try {
                Lexer lexer = new Lexer (new PushbackReader(new FileReader(args\[0\]), 1024));
                Parser parser = new Parser(lexer);
                Start ast = parser.parse() ;
                Interpreter interpreter = new Interpreter () ;
                ast.apply(interpreter) ;
            }
            catch (Exception e) {
                System.out.println (e) ;
            }
        } else {
            System.exit(1);
        }
    }
}

Teraz dodajmy do programu plik tekstowy _expression.txt_, w którym będziemy podawać wyrażenia do obliczenia:

2+2

Ustawmy parametry programu _Run->Edit Configurations...->Program arguments: <_ścieżka do naszego pliku z wyrażeniem>: ![Bez tytułu8](http://codecouple.pl/wp-content/uploads/2016/05/Bez-tytułu8.jpg) Teraz wystarczy skompilować i uruchomić program. W konsoli powinniśmy otrzymać następujący wynik: ![SableCCresult](http://codecouple.pl/wp-content/uploads/2016/06/SableCCresult.jpg)