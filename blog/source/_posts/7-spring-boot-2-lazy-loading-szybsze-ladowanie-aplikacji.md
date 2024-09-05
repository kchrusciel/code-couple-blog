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
---

![](https://codecouple.pl/wp-content/uploads/2017/12/springBoot2Art.png)

Kolejna nowa funkcjonalność/usprawnienie, która udostępniona będzie w wersji **2.2.0** frameworku **Spring Boot 2** dotyczyć będzie szybszego startowania aplikacji. Autorzy Spring'a dostarczyli nowy wpis, który można umieścić w pliku `application.properties`. **Wpis** ten sprawi, iż nasza aplikacja będzie uruchamiać się szybciej. Zapraszam do lektury, aby dowiedzieć się co to za nowy wpis!
<!-- more -->
### Lazy Initialization

**Spring Boot** słynie z tego, iż dostarcza całą game autokonfiguracji związanych z różnymi integracjami. Powoduje to, iż na **classpathie** znajdują się ogromne ilości klas, które muszą być **zweryfikowane** i **zainicjalizowane**. Proces ładowania tych klas może bardzo wydłużyć uruchamianie aplikacji.

**Beany** w **Spring'u** domyślnie są ładowane w momencie startu aplikacji (są oznaczone jako _eager_). Jednakże, nie wszystkie beany od razu są nam potrzebne. Aby **przyśpieszyć** proces możemy odroczyć ładowanie (i tworzenie) **beanów** do momentów kiedy rzeczywiście będą nam potrzebne. Jest to tak zwane **leniwe** ładowanie (które realizowane jest w **Spring'u** za pomocą adnotacji `@Lazy`).

W **Spring Boot 2** w wersji **2.2.0** pojawił się nowy **wpis**, który można dodać do pliku `application.properties`:

```
spring.main.lazy-initialization=true
```

Sprawia on, że wszystkie **beany** stają się **leniwie**, co może znacznie **przyśpieszyć** ładowanie aplikacji. Należy jednak pamiętać o tym, że jeśli nasza logika biznesowa uruchamiana była w konstruktorze **beana**, to zostanie ona wykonana dopiero w trakcie jego pierwszego wykorzystania!