---
title: '#2 Spring Boot - application.properties'
tags:
  - java
  - spring
  - spring boot
id: '634'
categories:
  - - Java
  - - Spring Boot
date: 2016-06-14 09:00:06
---

Dzisiejszy wpis **Spring Boot'owy** dotyczy konfiguracji właściwości aplikacji (ang. **application properties**). **Spring Boot** idealnie nadaje się do **PoC** (ang. **Proof Of Concept**) dzięki temu, że wykorzystuje podejście **deklaratywne,** czyli określamy co chcemy osiągnąć, a nie jak.
<!-- more -->
**Właściwości** są bardzo wydajnym mechanizmem dostarczanym przez **Spring Boot'a**. Same właściwości można ustawiać na kilka sposobów:

*   w pliku **application.properties** - zwykły plik tekstowy, który korzysta z wbudowanych **właściwości**,
*   w pliku **application.yml** - zwykły plik tekstowy, który wykorzystuje notację **YAML**,
*   używając **zmiennych środowiskowych** - wykorzystywane w rozwiązaniach **Cloud'owych**,
*   używając **linii poleceń** \- poprzez uruchomienie aplikacji z linii poleceń i dodanie parametru.

Domyślnie plik konfiguracyjny znajduje się w folderze **resources** (**Spring Boot** będzie szukał pliku ustawionego na **classpath'ie**). Kolejność wyszukiwania pliku **application.properties**:

*   folder **/config,** który znajduje się w głównym katalogu - **resources/config,**
*   aktualny katalog - **resources,**
*   **/config** ustawiony na classpath'ie,
*   główny classpath.

## Ustawienie właściwości z CLI

Aby **ustawić/dodać** własne właściwości z linii poleceń, należy podczas uruchamiania naszego **artefaktu** podać wartość.

java -jar CodeCouple-0.1.0-SNAPSHOT.jar --my.property=CodeCouple

## Wstrzykiwanie właściwości

Możemy także korzystać z naszych właściwości poprzez wstrzyknięcie ich do pola z użyciem adnotacji **@Value**. Wtedy możemy wykorzystywać je w naszych klasach.

@Value("${my.property}")
private String value;

## Własna klasa właściwości

Wstawmy teraz do naszego pliku następujące dane:

myapp.name = name
myapp.description = desc

Kolejną opcją jest wykorzystanie klasy **POJO,** która jest jakby "**ORM'em**" dla naszych właściwości. Klasę tworzymy poprzez dodanie adnotacji **@ConfigurationProperties**(prefix = "myapp") - gdzie "**myapp**" to nazwa początkowa mojej właściwości.

@Component
@ConfigurationProperties(prefix = "myapp")
public class CustomProperties {
    private String name;
    private String description;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}