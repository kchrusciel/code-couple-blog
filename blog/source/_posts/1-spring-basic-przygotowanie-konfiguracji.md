---
title: '#1 Spring Basic - Przygotowanie konfiguracji'
tags: []
id: '2500'
categories:
  - - Spring
date: 2019-03-22 12:02:08
author: 'Krzysztof Chruściel'
---

![](https://codecouple.pl/wp-content/uploads/2018/02/spring-by-pivotal.png)

W poprzednim wpisie opisałem czym jest **Spring** i jaki [problem rozwiązuje](https://codecouple.pl/2018/02/02/0-spring-basic-o-co-chodzi-z-tym-springiem/). Tym razem chciałem wam przedstawić jak zacząć swoją przygodę ze **Springiem**. Jako pierwszy temat zaczniemy od sposobów tworzenia konfiguracji **beanów**. **Konfiguracje** można tworzyć na dwa sposoby, **jawnie** korzystając z adnotacji `@Bean` oraz **automatycznie** korzystając z adnotacji `@Component`.
<!-- more -->
### Zależności

Aby zacząć korzystanie z frameworku **Spring** (i wszystkich dobrodziejstw **IoC**) musimy dodać do naszego projektu nową zależność `spring-context` (w tym przypadku korzystamy z narzędzia **Maven**, ale może być to dowolne inne narzędzie do zarządzania **zależnościami**):

<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context</artifactId>
    <version>5.1.4.RELEASE</version>
</dependency>

### Bean

W **Spring’u** obiekty stworzone i zarządzane przez kontener **IoC** nazywane są **Bean’ami** (są to zazwyczaj zwykłe **obiekty** z dodatkowymi możliwościami). Każdy **Bean** opisany jest poprzez `BeanDefinition`. Jest to zbiór cech i zachowań reprezentowanych przez **Bean’a**. **Bean** ma swój unikalny identyfikator, który pozwala w jednoznaczny sposób go zidentyfikować. Domyślnym **identyfikatorem** jest nazwa klasy wraz z pakietem. Od teraz wszystkie operacje wykonywane przez **Spring’a** odbywają się z wykorzystaniem **Bean’ów**. Jednakże, aby stworzyć **Bean’a** musimy dostarczyć kontenerowi **IoC** jego **konfigurację**.

![](https://codecouple.pl/wp-content/uploads/2018/02/spring_ioc-1024x634.png)

### Konfiguracja

Kontener IoC w **Spring'u** zarządza tak zwanymi **Bean'ami**. Bean tworzony jest poprzez kontener **IoC** na podstawie dostarczonej **konfiguracji**. Konfiguracją mogą być między innymi:

*   plik **XML**
*   klasy konfiguracyjne w **Javie** (najpopularniejszy aktualnie typ)
*   klasy konfiguracyjne w **Groovym**

### Konfiguracja w XML

Konfigurację w **XML** umieszczamy w nowym pliku `.xml`. Najczęściej jest to plik o nazwie `Beans.xml`, nazwa ta może być dowolna. Plik ten musi znaleźć się na tak zwanym `CLASSPATH` (w naszym przykładach będziemy umieszczać go w folderze `src/main/resources`). Wszystkie definicje **Bean’ów** umieszczamy pomiędzy znacznikami `<beans></beans>`, natomiast definicje jednego **Bean’a** umieszczamy pomiędzy `<bean></bean>`:

<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://www.springframework.org/schema/beans
http://www.springframework.org/schema/beans/spring-beans.xsd">
    <bean id="..." class="...">
        <!-- dodatkowe informacje -->
    </bean>
    <bean id="..." class="...">
        <!-- dodatkowe informacje -->
    </bean>
    <!-- kolejne definicje -->
</beans>

### Konfiguracja w Javie

**Konfigurację** w **Javie** umieszczamy najczęściej w osobnej klasie. Klasa ta powinna być oznaczona adnotacją `@Configuration`. Dla kontenera **IoC Spring’a**, jest to informacja iż tam znajdzie się konfiguracja **Bean’ów**. Konfiguracje w **Javie** dzielimy na **dwa** rodzaje:

*   jawną
*   automatyczną

### Konfiguracja jawna

Pierwszym opisywanym typem **konfiguracji** jest konfiguracja **jawna**. **Jawna**, ponieważ jawnie musimy określić w jaki sposób ma być tworzony **Bean**. Deklarację **Bean’a** oznaczamy adnotacją `@Bean`:

@Configuration
class CarConfiguration {

    @Bean
    Car carWithSummerTires(Tire summerTire) {
        return new Car(summerTire);
    }
    
    @Bean
    Tire winterTire() {
        return new WinterTire(195);
    }
    
    @Bean
    Tire summerTire() {
        return new SummerTire(215);
    }
    
    @Bean
    Car carWithWinterTires(Tire winterTire) {
        return new Car(winterTire);
    }
}

W metodach `carWithWinterTires` i `carWithSummerTires` przygotowaliśmy konfigurację klasy `Car`. Nazwy tych metodą to unikalne identyfikatory **Bean'ów** (podobnie jak wartość atrybutu `id` w pliku **XML**). Wartość tych **identyfikatorów** można zmienić korzystając z pola `name` w adnotacji `@Bean(name = "identyfikator")`.

### Konfiguracja automatyczna

Drugim opisywanym typem konfiguracji jest konfiguracja **automatyczna**. Automatyczna, ponieważ **Bean’y** tworzone są automatycznie na podstawie ich definicji. Deklarację **Bean’a** oznaczamy adnotacją `@Component`:

package pl.sda;

@Component
class Car {

    private final Tire tire;
    
    Car(final Tire tire) {
        this.tire = tire;
    }
}

Natomiast w samej **konfiguracji** należy wskazać, gdzie **Spring** ma tych komponentów szukać. Ustawiamy to za pomocą adnotacji `@ComponentScan`:

package pl.sda;

@Configuration
@ComponentScan("pl.sda")
class CarConfiguration {
}

 Jednakże, po uruchomieniu naszego kodu dostajemy **wyjątek**:

exception is org.springframework.beans.factory.NoUniqueBeanDefinitionException:
No qualifying bean of type 'pl.sda.Tire' available:
expected single matching bean but found 2:
winterTire,summerTire

Komunikat błędu jest bardzo czytelny. Przygotowaliśmy automatyczną **konfigurcję**, więc **Spring** próbuje **wstrzyknąć** pierwszą odnalezioną implementację interfejsu `Tire`. W tym przypadku odnalazł, aż dwie jego implementacje. Do wskazania interesującej nas implementacji wykorzystujemy adnotacje `@Qualifier`:

@Component
public class CarComponent {
    private Tire tire;
    
    CarComponent(@Qualifier("winterTire") Tire tire) {
        this.tire = tire;
    }
    
    void drive() {
        tire.turn();
    }
}

W ramach **konfiguracji automatycznej** zostaje do rozpatrzenia jeszcze kwestia **unikalnego** identyfikatora. W przypadku konfiguracji **XML** była to wartość atrybutu **id** lub pełna **nazwa** klasy, natomiast w przypadku konfiguracji **jawnej** nazwa metody lub parametr name adnotacji `@Bean`. Tutaj z racji, iż jest to konfiguracja **automatyczna** naszemu **Bean’owi** odpowiada nazwa klasy pisanej mała literą (dla klasy `CarSomething` będzie to `carSomething`). Wartość tą można zmienić podobnie jak przy adnotacji `@Bean`. Adnotacja `@Component` dostarcza pole value (`@Component(value = "indentyfikator")`).

### GitHub

Całość jak zawsze na **GitHubie**.