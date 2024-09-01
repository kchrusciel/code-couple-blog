---
title: JSF 2.2 - nowości
tags:
  - java
  - JSF
id: '76'
categories:
  - - JSF
date: 2016-02-07 12:15:59
---

Choć od premiery frameworku **Java Server Faces** minęło już sporo czasu (premiera: 2013-05-21), dopiero niedawno musiałem wykorzystać nowe funkcje zawarte w **JSF** w wersji **2.2**. Wprowadzono kilka nowych komponentów oraz pojawiło się wsparcie dla **HTML5**.
<!-- more -->
**1\. Wsparcie dla HTML5** W najnowszej wersji JSF zostało wprowadzone wspracie dla kompenetów HTML5. Odbywa się to poprzez dodatkową bibliotekę nazywaną **passthrough**.

```
xmlns:pt="http://xmlns.jcp.org/jsf/passthrough"
```

Aby korzystać z tej biblioteki wystarczy używać nagłówka **pt**.

```
<h:form id="form">
    <h:inputText id="email" value="#{managedBean.email}"
    pt:type="email" pt:placeholder="Email here..."/>
</h:form>
```

**2\. ViewScoped dla CDI** **ViewScoped** był brakującym elementem w relacjach **JSF** i **CDI**. Domyślnie **CDI** nie posiada wsparcia dla komponetów o zasięgu **ViewScoped**. Z racji, iż **CDI** jest "rozszerzalny", JSF pomaga uzyskać zasięg **ViewScoped** przy użyciu **javax.faces.view.ViewScoped**. **3. Atrybut resetValues** W komponentach typu **AJAX** pojawiła się nowa opcja **resetValues**. Czyści ona dane z pól formularza zawartych w atrybucie **render**.

```
<h:commandLink value="Dodaj jeden" action="#{managedBean.dodajWartosc}">
     <f:ajax render="wartosc" resetValues="true"/>
</h:commandLink>
```

**4\. Nowy komponent inputFile** Komponent do dodawania plików

```
<h:inputFile id="file" value="#{managedBean.file}"/>
```

**5\. Lepsze wsparcie dla kolekcji** Została wprowadzona obsługa elementów kolekcji zwartych w pakiecie **java.util.Collection**. Operowanie elementami w tabeli **h:dataTabel** jest teraz bardziej efektywne. **6\. Więcej** W tym artykule przedstawiłem najnowsze funkcjonalności, które zostały przeze mnie wykorzystane. Oczywiście to nie wszystkie nowości wprowadzone w **JSF 2.2**. Jeśli chcesz się dowiedzieć więcej:

*   [Strona frameworku JSF](https://javaserverfaces.java.net/)
*   [JSR 344](https://jcp.org/en/jsr/detail?id=344)

A ja czekam na **JSF 2.3**.