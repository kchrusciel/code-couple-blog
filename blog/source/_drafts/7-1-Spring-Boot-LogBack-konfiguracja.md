---
title: '#7.1 Spring Boot - LogBack - konfiguracja'
tags:
  - logback
  - spring
  - spring boot
id: '889'
categories:
  - - Inne
  - - Spring Boot
---

Kontynuując temat logowania przy użycia frameworku **LogBack** dziś przedstawię wam jak skonfigurować plik `logback-spring.xml` aby logowanie działo w taki sposób jaki potrzebujemy.
<!-- more -->
## Główne ustawienia

Jak pisałem w poprzednim [WPISIE](http://codecouple.pl/2016/09/13/7-spring-boot-logowanie-aplikacji-logback/), naszą konfigurację definiujemy w pliku `logback-spring.xml`. Na sam początek zacznijmy od deklaracji:

<?xml version="1.0" encoding="UTF-8"?>
<configuration debug="true" scan="true" scanPeriod="30 seconds">
...
</configuration>

Wszystkie ustawienia muszą znajdować się w sekcji configuration. Opcja `debug` oznacza sprawdzanie błędów w pliku. Flaga `scan` ustawia sprawdzanie pliku czy wystąpiły zmiany, natomiast odstęp czasu pomiędzy kolejnym skanowaniem ustawiamy w `scanPeriod`, domyślna wartość to jedna minuta.

## Zmienne

Zmienne deklarujemy poprzez słowo kluczowe property:

<property name="LOG\_DIR" value="Logs" />

Natomiast odwołujemy się do nich tak jak w Mavenie:

${LOG\_PATH}

<property name="LOG\_ARCHIVE\_DIR" value="${LOG\_PATH}/Archive" />

Możemy także użyć zmiennej `timestamp` która wbudowana jest w **LogBack'a**. Zmienna ta generuje dla nas `timestamp`(możemy dzięki temu opisywać nasze pliki z konkretną datą), możemy także określi jak będzie on wyglądał. Do określenia patternu wykorzystujemy `SimpleDateFormat`.

<timestamp key="bySecond" datePattern="yyyyMMdd'T'HHmmss"/>
...
<file>${LOG\_PATH}/logfile-${bySecond}.log</file>

## Wyświetlanie na konsoli

Za wyświetlanie informacji w konsoli odpowiada klasa `ch.qos.logback.core.ConsoleAppender` którą otrzymujemy dzięki dziedziczeniu z pliku

<appender name="Console-Logger" class="ch.qos.logback.core.ConsoleAppender">
    <layout>
        <pattern>%d{HH:mm:ss.SSS} \[%thread\] %-5level %logger{36} - %msg%n</pattern>
    </layout>
</appender>

W sekcji layout->pattern określamy format logów.

## Zapis do pliku

Za wyświetlanie informacji w konsoli odpowiada klasa `ch.qos.logback.core.FileAppender` którą otrzymujemy dzięki dziedziczeniu z pliku

<appender name="File-Logger" class="ch.qos.logback.core.FileAppender">
    <layout>
        <pattern>%d{HH:mm:ss.SSS} \[%thread\] %-5level %logger{36} - %msg%n</pattern>
    </layout>
</appender>

asss

## Więcej

http://logback.qos.ch/manual/configuration.html