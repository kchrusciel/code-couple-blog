---
title: '#4 Spring Basic – Bean Scopes'
tags: []
id: '2507'
categories:
  - - Spring
---

![](https://acntech.no/content/images/2016/10/logo-spring-103x60.png)

Tworzone przez nas **beany** mogę mieć określony sposób tworzenia. Domyślna konfiguracja **Spring'a** traktuje każdy bean jako **singleton**, oznacza to, iż w całym kontekście Spring'a istnieje tylko jedna instancja danego **beana**. Jeśli wstrzykujemy nasz **bean** w kilku miejscach operujemy na tej samej instancji. **Spring** dostarcza mechanizm do zmiany sposoby tworzenia beanów.
<!-- more -->
Dobranie odpowiedniego typu tworzenia beanów, może mieć znaczący wpływ na naszą aplikację. Dobierając odpowiedni typ, należy działać rozsądnie. Poniżej znajduje się opis różnych typów zasięgów:

### Singleton

Jak pisałem we wstępie, wszystkie beany domyślnie są **singletonami**. Możemy oczywiście dodać adnotację `@Scope("singleton")` nad naszym beanem, jednakże jest to redundantne. Nowo utworzony bean trzymany jest w cache i każdy odwołanie odczytuje wartość z cache. Jak zachowuje się **singleton**:

\[snipped\]

### Prototype

Kolejnym typem jest `@Scope("prototype")`. Jest całkowitą odwrotnością zasięgu **singleton**. Otóż przy każdym wstrzyknięciu beany tworzona jest nowa instancja:

\[snipped\]

### WebApplicationContext

Opisy znajdujące się poniżej nie będą działały ze "zwykłym" kontekstem. Do poprawnego działa wymagany jest kontekst webowy, na przykład: `XmlWebApplicationContext`.

### Request

Przechodzimy do pierwszego typu, który wymaga kontekstu webowego. `@Scope("request")` oznacza, iż nasz bean będzie tworzony za każdym razem gdy w systemie zostanie utworzone nowe żądanie, które będzie korzystało z tego beana:

\[snipped\]

### Session

Szerszym zakresem w porównaniu do request scope jest `@Scope("session")` czyli zasięg sesyjny. Tworzony będzie jeden bean na sesje, taki typ tworzenia może być wykorzystywany w mechanizmach logowania:

\[snipped\]

### Application

Kolejny typ z serii webowych czyli `@Scope("application")`. Nasz bean będzie dostępny przez cały czas działania aplikacji, przydatny do trzymania preferencji aplikacji:

\[snipped\]

### More

Istnieje także zasięg `@Scope("websocket")`, który ma taki sam cykl życia jak WebSockety. Możemy także tworzyć własny zasięg, [więcej można przeczytać tutaj](https://docs.spring.io/spring/docs/5.0.2.RELEASE/spring-framework-reference/core.html#beans-factory-scopes-custom).

### GitHub

Całość jak zawsze na GitHubie.