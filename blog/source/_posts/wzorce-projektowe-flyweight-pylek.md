---
title: '#1 Wzorce projektowe: Flyweight (Pyłek)'
tags:
  - design pattern
  - flyweight
  - pyłek
  - wzorce projektowe
id: '685'
categories:
  - - Clean Code
  - - Java
  - - Wzorce projektowe
date: 2016-06-26 11:57:17
---

![designPatternArt](http://codecouple.pl/wp-content/uploads/2017/03/designPatternArt.png)

Postanowiłam zacząć serię wpisów o wzorcach projektowych. Dążymy przecież do tworzenia kodu idealnego, tworząc go zastanawiamy się czy można go jakoś uprościć, zmodyfikować tak, żeby działał bardziej wydajnie oraz dało się go rozbudować w łatwy sposób. Dlaczego nie skorzystać z rozwiązań, które już istnieją? Pierwszy na tapecie **flyweight**, czyli mówiąc po polsku **pyłek**. Jest to **wzorzec strukturalny**, który przydaje się w aplikacjach, które korzystają z większej liczby identycznych obiektów.
<!-- more -->
W rozwiązaniu tego wzorca tworzymy tylko unikatowe obiekty. W momencie tworzenia nowego obiektu, sprawdzane jest czy egzemplarz o takich samych parametrach istnieje już w pamięci. Jeśli tak, to pobieramy go, a jeśli nie, tworzymy nowy. Obiekty te są **immutable** (niezmienne), czyli przygotowujemy klasę tak aby nie dało się jej zmodyfikować. Natomiast gdy zajdzie potrzeba zmiany danych wtedy tworzona jest nową instancja. Dzięki wykorzystaniu **pyłku** zmniejszamy ilość wykorzystywanej pamięci. Przykładem zastosowania tego wzorca jest obsługa obiektów typu String w **JRE**.

  Spróbujmy teraz zaimplementować **flyweight.** Stwórzmy klasę _Relation._

final public class Relation {
    final private String description;

    public Relation(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }

}

Następnie tworzymy klasę _FlyweightFactory,_ w której będzie cała logika omawianego wzorca. W metodzie _createRelation_ sprawdzamy, czy obiekt o podanym opisie już istnieje. Jeśli nie, to tworzymy ten obiekt i wyświetlamy komunikat użytkownikowi. W przeciwnym wypadku pobieramy obiekt z tym parametrem (w naszym przypadku z HashMapy).

public class FlyweightFactory {
    private Map<String, Relation> relations = Collections.synchronizedMap(new HashMap());

    public synchronized Relation createRelation(String description){
        Relation relation = (Relation)relations.get(description);
        if(relation == null) {
            relation = new Relation(description);
            relations.put(description, relation);
            System.out.println("Creating new relation: " + relation.getDescription());
        }
        return relation;
    }
}

  Na koniec wywołujemy w pętli tworzenie obiektów w naszej fabryce pyłków.

public class Test {
    public static void main(String\[\] args) throws InterruptedException {
        FlyweightFactory flyweightFactory = new FlyweightFactory();
        for(int i = 0; i < 100; i++) {
            flyweightFactory.createRelation("Aga+Krzys");
        }
    }
}

 

A poniżej wynik naszej aplikacji. Widzimy, że pomimo 100 wywołań tworzenia obiektu, obiekt tworzy się tylko raz. W pozostałych 99 przypadkach pobierany jest utworzony już obiekt.

Creating new relation: Aga+Krzys
Process finished with exit code 0