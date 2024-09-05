---
title: '#7 Spring Boot - logowanie aplikacji - LogBack'
tags:
  - java
  - spring boot
id: '847'
categories:
  - - Spring Boot
date: 2016-09-13 12:25:52
author: 'Krzysztof Chruściel'
---

> Skąd brać informacje jak nie z logów aplikacji. W Spring Boot'cie dzięki temu, że wszystko jest automatyczne i łatwo konfigurowalne możemy dostosować logowanie do naszych potrzeb. Wykorzystamy do tego bardzo dobrze znany plik application.properties. Wpis ten dotyczy konfiguracji rozwiązania jakim jest `LogBack`.
<!-- more -->
## Podstawowe ustawienia

Aby móc korzystać z logowania, musimy dodać odpowiednią zależność w naszym `pom.xml` (jeśli korzystamy z `Maven'a`). Jeśli korzystamy ze starteru:

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>

Mamy od razu dostarczone biblioteki do logowania. Jeśli nie korzystamy ze `spring-boot-starter-web` możemy wykorzystać starter do logowania:

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-logging</artifactId>
</dependency> 

## Wypisanie logów

Do logowania w naszej aplikacji wykorzystamy `SLF4J`. Jest on fasadą, czyli możemy przygotować sobie nasze wpisy, a następnie podpiąć interesujący nas framework jak **LogBack** lub `Log4J2`. Najprościej, aby wypisać coś do logu użyjemy `LoggerFactory`:

@Controller
@RequestMapping("/logger")
public class LoggerController {

    private static final Logger logger = LoggerFactory.getLogger(LoggerController.class);

    @RequestMapping(method = RequestMethod.GET)
    public String showLog(){

        logger.info("You can log something");
        logger.warn("You can log something");
        logger.debug("You can log something");
        logger.error("You can log something");

        return "some\_page";
    }

## Ustawienia w pliku application.properties

Wykorzystując plik `application.properties` możemy ustawić następujące wartości:

logging.config\= \# Location of the logging configuration file. For instance \`classpath:logback.xml\` for Logback
logging.exception-conversion-word\=%wEx \# Conversion word used when logging exceptions.
logging.file\= \# Log file name. For instance \`myapp.log\`
logging.level.\*\= \# Log levels severity mapping. For instance \`logging.level.org.springframework=DEBUG\`
logging.path\= \# Location of the log file. For instance \`/var/log\`
logging.pattern.console\= \# Appender pattern for output to the console. Only supported with the default logback setup.
logging.pattern.file\= \# Appender pattern for output to the file. Only supported with the default logback setup.
logging.pattern.level\= \# Appender pattern for log level (default %5p). Only supported with the default logback setup.
logging.register-shutdown-hook\=false \# Register a shutdown hook for the logging system when it is initialized. 

Jeśli chcemy zmodyfikować standardowe ustawienia **LogBack'a** musimy dodać plik `logback.xml` do naszego folderu `resources`. Według dokumentacji, lepszym rozwiązaniem jest dodanie pliku `logback-spring.xml.` Dzięki temu mamy pewność, że zostanie wybrany nasz plik. Możemy także zmienić lokalizację pliku z ustawieniami wykorzystując `logging.config=classpath:config/log/logback-spring.xml`. Lokalizację pliku, gdzie będą zapisywane logi ustawimy poprzez `logging.file=logs/codecouple.log`.

**UWAGA!**, jeśli ustawimy obie wartości, czyli `logging.file=codecouple.log` oraz `logging.path=my/folder/logs,` zostaną one zignorowane. Jeśli potrzebujemy ustawić specyficzną ścieżkę pliku, należy wpisać to w taki sposób `logging.file=my/folder/logs/codecouple.log`. To kiedy ustawiamy dwie wartość? Jeśli chcemy z nich skorzystać w `logback-spring.xml`.

Logi z poziomu `DEBUG` nie będą się wyświetlały, ponieważ w domyślnej konfiguracji przygotowanej przez `Spring'a` ten poziom jest wyłączony (ma to sens w przypadku środowiska produkcyjnego, w pierwotnej konfiguracji `LogBack` w pliku `base.xml` logowanie poziomu `DEBUG` jest włączone.). Jeśli jednak pracujemy na środowisku developerskim wystarczy ustawić `logging.level.*=DEBUG` gdzie \* oznacza nazwę pakietu, w którym chcemy to ustawić, np `logging.level.org.springframework.web=DEBUG` lub `logging.level.pl.codecouple.controllers=DEBUG`.

## Ustawienia w pliku logback-spring.xml

Jeśli jednak zdecydowaliśmy się ustawiać logowanie w pliku `logback-spring.xml`, możemy dodać następujący wpis:

<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <include resource="org/springframework/boot/logging/logback/base.xml"/>
    <logger name="pl.codecouple.omomfood.offers" level="DEBUG"/>
</configuration>

Dzięki temu nie musimy ustawiać `loggin.level.*` w `application.properies` tylko wszystkie ustawienia konfigurujemy w tym pliku. Możemy także korzystać w nim ze zmiennych globalnych:

*   `${PID}` - ID aktualnego procesu.
*   `${LOG_FILE}` - jeśli `logging.file` jest ustawiona.
*   `${LOG_PATH}` - jeśli `logging.path` jest ustawiona.

Plik `base.xml,` w którym znajduje się standardowa konfiguracja LogBack'a, zawiera także odwołanie do pliku `console.appender.xml,   ` który przechowuje informacje o konfiguracji logów dla konsoli oraz do pliku `file-appender.xml,` który przechowuje informacje o konfiguracji logów dla pliku. Możemy przykładowo w naszym pliku `logback-spring.xml` ustawić, że chcemy tylko logowanie do pliku z wyłączeniem konsoli:

<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <include resource="org/springframework/boot/logging/logback/defaults.xml" />
    <property name="LOG\_FILE" value="${LOG\_FILE:-${LOG\_PATH:-${LOG\_TEMP:-${java.io.tmpdir:-/tmp}}/}spring.log}"/>
    <include resource="org/springframework/boot/logging/logback/file-appender.xml" />
    <root level="INFO">
        <appender-ref ref="FILE" />
    </root>
</configuration>

## Logi a profile

Bardzo fajnym dodatkiem w Spring Boot'cie jest możliwość konfiguracji logów zależnych od profilu. Tak jak pisałem wcześniej chcielibyśmy, aby na środowisku deweloperksim (nasz profil `dev`) były logowane wszystkie poziomy razem z `DEBUG` oraz aby były tylko wypisywane na konsoli. Natomiast dla naszego środowiska produkcyjnego (nasz profil `prod`) chcemy zapisywać logi tylko do pliku od poziomu `ERROR`:

<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <include resource="org/springframework/boot/logging/logback/base.xml" />
    <springProfile name="prod">
        <logger name="pl.codecouple.omomfood.offers" level="ERROR" additivity="false">
            <appender-ref ref="FILE" />
        </logger>
    </springProfile>
    <springProfile name="dev">
        <logger name="pl.codecouple.omomfood.offers" level="DEBUG" additivity="false">
            <appender-ref ref="CONSOLE" />
        </logger>
    </springProfile>
</configuration>

## Tips & Tricks

Jeśli korzystacie z **IntelliJ** pomocne może być dodanie **LiveTemplate** dla loggerów:

[![livetemplatelog](http://codecouple.pl/wp-content/uploads/2016/09/LiveTemplateLog.png)](http://codecouple.pl/wp-content/uploads/2016/09/LiveTemplateLog.png) Lub drugim rozwiązaniem, bardziej inwazyjnym jest zastosowanie **Lombok'a**. W `pom.xml` należy dodać odpowiednią zależność:

<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <version>1.16.10</version>
    <scope>provided</scope>
</dependency>

Następnie możemy już korzystać z adnotacji **Lombok'a**:

 @Slf4j
 public class LogExample {
 }

Wygeneruje następujący kod:

 public class LogExample {
     private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(LogExample.class);
 }

Teraz można korzystać już z naszego loggera poprzez odwołania do zmiennej `log`.

## Więcej informacji

Więcej informacji możecie znaleźć [TUTAJ](http://docs.spring.io/spring-boot/docs/current/reference/html/howto-logging.html).