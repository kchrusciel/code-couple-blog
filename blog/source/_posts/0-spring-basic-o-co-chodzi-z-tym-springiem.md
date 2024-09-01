---
title: '#0 Spring Basic – o co chodzi z tym Springiem'
tags:
  - dependency injection
  - DI
  - Inversion of Control
  - IoC
  - java
  - kontener
  - spring
id: '2513'
categories:
  - - Spring
date: 2018-02-02 12:05:55
---

![](https://codecouple.pl/wp-content/uploads/2018/02/spring-by-pivotal.png)

Rozpoczynamy kolejny cykl wpisów. Tym razem na tapecie framework **Spring**. Zamierzamy przedstawić wam podstawowe funkcjonalności **Spring'a**. Wiele osób zaczyna przygodę ze **Spring'iem** od **Spring Boot'a**, bez zrozumienia co dzieje się pod spodem. Poruszymy tematy takie jak tworzenie beanów, zasięg beanów czy rodzaje wstrzykiwania zależności. Jednakże, na początek zapraszamy na wpis wprowadzający do **Spring'a**,
<!-- more -->
### Trochę historii

"_Jeśli chcesz, aby coś było drogie nazwij to enterprise_" takimi słowami **Jakub Nabrdalik** opisał sposób myślenia architektów projektujących **Jave** w wersji **Enterprise Edition**. Pierwsze wersje były ociężałym kolosem, w którym tworzenie aplikacji nie należało do najłatwiejszych zadań (ale można było na tym zarabiać!). W tym czasie pojawiło się  również kilka książek jak radzić sobie w tym środowisku. W roku **2002** została wydana książka "_Expert One-on-One J2EE Design and Development_" autorstwa **Rod'a Johnsona**. Był to poradnik jak przetrwać z **Java EE** (skrót od ang. _Enterprise Edition_). Trzy lata później pojawiła się kolejna pozycja, która jest bardzo ważną książka w całych dziejach **Javy** \- "_Expert One-on-One J2EE Development Without EJB_". Bez **EJB** (ang. _Enterprise Java Bean_)? Ale jak to? **Rod** udowodnił jak wiele pomysłów architektów **Javy EE** nie sprawdziło się w realnych projektach oraz jak skomplikowane jest to rozwiązanie. W książce tej, znajdują się także propozycje jak radzić sobie bez **EJB**, na podstawie których powstał zalążek **Spring'a**.

### Rod Johnson

**Rok 2005,** na świat wychodzi książka "_Professional Java Development with the Spring Framework_". Jest to już pierwsza oficjalna książka na temat **Spring'a**. Myślenie **Rod'a Johnsona** było kompletną odwrotnością w stosunku do ekipy z **Sun'a** (**Sun** został kupiony przez **Oracle**). Wybierzemy dobrze działające i sprawdzone rozwiązania, a na ich bazie stworzymy swój **framework**. Ponadto będziemy dostarczać domyślne konfiguracje, ale w przeciwieństwie do **Javy EE**, pozwolimy Ci w łatwy sposób dostosowywać je do swoich potrzeb. Wraz z kolejnymi latami **Java EE** starała się dogonić **Spring'a** i zaimplementować u siebie rozwiązania, które z powodzeniem wykorzystywane były w **Spring'u**. Niestety (albo "stety") opieszałość firmy **Sun**, a potem **Oracle** doprowadziła do tego, iż **Spring** jest jednym z najpopularniejszych **framework'ów** do tworzenia aplikacji w **Javie**. Aktualnie różnice obu **framework'ów** zacierają się. Który wybrać? To już zależy od was.

### Kontener IoC

**Killer featurem Spring'a** jest własny, bardzo dobrze działający **kontener IoC**. Kontener ten odpowiedzialny jest za tworzenie i zarządzanie obiektami, które nazywane są ziarnami (ang. _bean,_ tak też będę je dalej nazywał). Przeniesienie odpowiedzialności tworzenia obiektów zwane jest wzorcem **Inversion of Control.** W przypadku **Spring'a** to kontener tworzy i zarządza **beanami**. [**Dependency Injection**](http://codecouple.pl/2017/12/29/3-wzorce-projektowe-wstrzykiwanie-zaleznosci/) jest jednym ze sposobów realizacji wzorca **IoC**. Dzięki temu, że **Spring** posiada **własny kontener** można z powodzeniem stosować **wstrzykiwanie zależności**. Stosując **DI** nasz kod staje się bardziej **testowalny** (można wstrzykiwać zamockowane zależności) oraz zmniejsza się ilość powiązań pomiędzy innymi komponentami. W podejściu odwrotnym (bez stosowania **odwróconej kontroli**) to klasa tworzy obiekty powiązane oraz wie jakiego mają być typu. To powoduje, iż klasa staje się z nimi bardzo silnie związana.

![](https://codecouple.pl/wp-content/uploads/2018/02/spring_ioc-1024x634.png)

Powyższy obrazek prezentuję jak działa kontener w **Spring'u**. Przygotowujemy proste obiekty typu **POJO** (ang. Plain Old Java Object), które następnie tworzone są przez kontener w taki sposób w jaki zdefiniowaliśmy je w konfiguracji. W świecie **Javy** stosowanie **wstrzykiwania zależności** jest standardem, a bardzo duży wkład w to ma właśnie **Spring Framework**.

### Varia

Zapraszamy na kolejne wpisy z serii **#Spring Basics**. Jeśli sama koncepcja **odwróconego sterowania** nie jest dla Ciebie do końca jasna, [zapraszamy do tego artykułu](https://codecouple.pl/2017/12/29/3-wzorce-projektowe-wstrzykiwanie-zaleznosci/).