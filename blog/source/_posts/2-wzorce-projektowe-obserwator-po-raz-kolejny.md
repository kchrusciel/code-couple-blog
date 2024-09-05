---
title: '#2 Wzorce projektowe: Obserwator po raz kolejny'
tags:
  - design pattern
  - observer
id: '1560'
categories:
  - - Java
  - - Wzorce projektowe
date: 2017-03-31 14:25:55
author: 'Krzysztof Chruściel'
---

[![designPatternArt](http://codecouple.pl/wp-content/uploads/2017/03/designPatternArt.png)](http://codecouple.pl/wp-content/uploads/2017/03/designPatternArt.png)

Ile to już wody upłynęło od czasu wydania książki z wzorcami projektowymi "**Gang of Four**" na temat wzorców projektowych. Planuję napisać kilka artykułów na temat **programowania reaktywnego,** a jakby nie patrzeć **wzorzec obserwator** ma z tym paradygmatem programowania wiele wspólnego.
<!-- more -->
### 1. Obserwator

**Wzorzec obserwator** jest **wzorcem behawioralnym**. Jak sama nazwa mówi jest to wzorzec do obserwowania/nasłuchiwania na jakieś zdarzenie (np. zmianę stanu). Jeśli to zdarzenie wystąpi, wszystkie obiekty które "zapisały" się do nasłuchiwania na ten **event** zostaną o tym fakcie poinformowane. Tworzy się tu relacja **jeden-do-wielu,** która łączy ze sobą grupę obiektów, które zostaną poinformowane o zmianie stanu.

### 2\. Hierarchia klas

Tak prezentuję się hierarchia klas z konkretną implementacją:

[![observerClassDiagram](http://codecouple.pl/wp-content/uploads/2017/03/observerClassDiagram.png)](http://codecouple.pl/wp-content/uploads/2017/03/observerClassDiagram.png) Najważniejsze dwa interfejsy to **Observer** oraz **Subject**.

### 3. Observer

Czyli nasz **obserwator**.  Obiekt, który chce obserwować, posiada w sobie tylko jedną metodę `update()` (nie musi być ona tak nazwana jednakże jest to "good practice"). Metoda ta wykonuję logikę, która wywoływana jest w momencie pojawienia się nowego zdarzenie. Zdarzenie to publikowane jest przez **Subject** (nazywanego też czasem **Publisher**).

### 4. Subject

Interfejs, który posiada trzy metody:

*   `registerObserver` - dodaj subskrybenta,
*   `unregisterObserver` - usuwa z listy subskrybentów,
*   `notifyObservers` - poinformuj wszystkich subskrybentów z listy.

### 5. Jak korzystać

Jako przykład tworzymy Subject/Publisher'a, który publikuje informację o nowym wpisie na blogu:

public class Blog implements Subject, Publisher {

    /\*\* Publish message. \*/
    private static final String publishMessage = "Article: %s added";

    /\*\* List with all blog subscribers. \*/
    private List<Observer> blogSubscribers;

    /\*\*
     \* Constructor of {@link Blog}.
     \*/
    public Blog() {
        this.blogSubscribers = new ArrayList<>();
    }

    @Override
    public void registerObserver(Observer observer) {
        blogSubscribers.add(observer);
    }

    @Override
    public void unregisterObserver(Observer observer) {
        blogSubscribers.remove(observer);
    }

    @Override
    public void notifyObservers() {
        blogSubscribers.forEach(Observer::update);
    }

    @Override
    public void publish(String articleName) {
        System.out.println(String.format(publishMessage, articleName));
        notifyObservers();
    }
}

Teraz utworzymy subskrybentów naszego bloga, którzy chcą otrzymywać informację o nowych wpisach:

public class BlogSubscriber implements Observer {

    /\*\* Message with information about new article. \*/
    private static final String message = "Hi %s, you have %d new articles to read";

    /\*\* User name. \*/
    private final String userName;
    /\*\* Number of new articles to read. \*/
    private int newArticles;

    /\*\*
     \* Constructor of {@link BlogSubscriber}.
     \*
     \* @param userName the user name.
     \*/
    public BlogSubscriber(String userName) {
        this.userName = userName;
    }

    @Override
    public void update() {
        newArticles++;
        System.out.println(String.format(message, userName, newArticles));
    }
}

Na koniec musimy stworzyć klienta, który będzie korzystał z naszego rozwiązania:

public class Main {

    public static void main(String\[\] args) {
        createBlogChannel();
    }

    private static void createBlogChannel() {
        Blog blog = new Blog();

        BlogSubscriber subscriberAgnieszka = new BlogSubscriber("Agnieszka");
        blog.registerObserver(subscriberAgnieszka);

        blog.publish("Observer");

        BlogSubscriber subscriberKrzysztof = new BlogSubscriber("Krzysztof");
        blog.registerObserver(subscriberKrzysztof);

        blog.unregisterObserver(subscriberAgnieszka);

        blog.publish("Design");

    }
}

A w wyniku otrzymamy:

Article: Observer added
Hi Agnieszka, you have 1 new articles to read
Article: Design added
Hi Krzysztof, you have 1 new articles to read
Article: DesignSecond added
Hi Krzysztof, you have 2 new articles to read
Article: DesignThird added
Hi Krzysztof, you have 3 new articles to read

### 6. Reaktywny obserwator

[![reactiveObserver](http://codecouple.pl/wp-content/uploads/2017/03/reactiveObserver.png)](http://codecouple.pl/wp-content/uploads/2017/03/reactiveObserver.png) **Observable** obserwuje jakieś zdarzenie i informuje o tym eventem. **Observer** chce obserwować ten event więc subskrybuje się do **Observable**.

public interface Observer<T> {
    void onCompleted();

    void onError(Throwable var1);

    void onNext(T var1);
}

*   onNext, gdy pojawi się nowy event,
*   onError, gdy podczas przetwarzania strumieni wystąpił błąd,
*   onCompleted informuje obserwatorów, że skończył się strumień lub przetwarzanie strumienia.

public interface Observable<T> {

    public Subscription subscribe(Observer<? super T> subscriber);

}

Daje możliwość subskrybcji. Całość znajdziecie na [GitHubie](https://github.com/kchrusciel/ObserverExample).