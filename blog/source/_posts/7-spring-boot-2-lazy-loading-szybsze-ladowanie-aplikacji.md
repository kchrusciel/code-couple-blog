---
title: '#7 Spring Boot 2 – Lazy Loading - szybsze ładowanie aplikacji'
tags:
  - spring boot
  - spring boot 2
id: '3948'
categories:
  - Java
  - Spring
  - Spring Boot
date: 2019-06-07 12:01:09
author: 'Krzysztof Chruściel'
---

![](https://raw.githubusercontent.com/kchrusciel/code-couple-blog-assets/main/2017/12/springBoot2Art.png)

Kolejna nowa funkcjonalność/usprawnienie, która udostępniona została w wersji **2.2.0** frameworku **Spring Boot 2**, dotyczy szybszego startowania aplikacji. Autorzy Springa udostępnili nowy wpis, który można umieścić w pliku `application.properties`. **Wpis** ten sprawia, że nasza aplikacja uruchamia się szybciej. Zapraszam do lektury, aby dowiedzieć się, co to za nowa właściwość!
<!-- more -->
### Lazy Initialization

**Spring Boot** słynie z dostarczania całej gamy autokonfiguracji związanych z różnymi integracjami. Powoduje to, że na **classpathie** znajdują się ogromne ilości klas, które muszą być **zweryfikowane** i **zainicjalizowane**. Proces ładowania tych klas może znacząco wydłużyć czas uruchamiania aplikacji.

**Beany** w **Springu** domyślnie są ładowane w momencie startu aplikacji (są określane jako _eager_). Jednakże, nie wszystkie beany są nam potrzebne od razu. Aby **przyspieszyć** proces, możemy odroczyć ładowanie (i tworzenie) **beanów** do momentu, gdy rzeczywiście zostaną wykorzystane. Jest to tak zwane **leniwe** ładowanie (które w **Springu** jest realizowane za pomocą adnotacji `@Lazy`).

W **Spring Boot 2** w wersji **2.2.0** pojawiła się nowa **właściwość**, którą można dodać do pliku `application.properties`:

```properties
spring.main.lazy-initialization=true
```

Sprawia ona, że wszystkie **beany** domyślnie stają się **leniwe**, co może znacznie **przyspieszyć** ładowanie aplikacji. Należy jednak pamiętać o tym, że jeśli nasza logika biznesowa była uruchamiana w konstruktorze **beana**, to zostanie ona wykonana dopiero w trakcie jego pierwszego wykorzystania!