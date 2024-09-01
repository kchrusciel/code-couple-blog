---
title: '#9 Spring Boot - Scheduling'
tags:
  - java
  - scheduled task
  - scheduling
  - spring
  - spring boot
id: '940'
categories:
  - - Java
  - - Spring Boot
date: 2016-12-22 20:01:06
---

![schedulerpost](http://codecouple.pl/wp-content/uploads/2016/12/SchedulerPost.png)

W tym wpisie chciałam przedstawić proces tworzenia planowanych zadań. W Spring Boocie jest to wyjątkowo proste. Nie musimy tworzyć żadnych plików konfiguracyjnych. Wszystko opiera się na dwóch adnotacjach. Przekonajcie się sami.
<!-- more -->
W pom.xml potrzebujemy tylko i wyłącznie podstawowej zależności startera spring boot'owego.

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter</artifactId>
    <version>1.4.2.RELEASE</version>
</dependency>

Nasza klasa główna musi mieć adnotację `@EnableScheduling`

@SpringBootApplication
@EnableScheduling
public class SchedulerApplication {
    public static void main(String\[\] args) {
        SpringApplication.run(new Object\[\] { SchedulerApplication.class }, args);
    }
}

Teraz przejdźmy do naszej klasy z zadaniami, które mają się wykonywać co określony interwał czasowy. Nad klasą dodajemy adnotację `@Component`, a nad metodą, która ma być wywoływana dodajemy `@Scheduled` z odpowiednim parametrem (dostępne parametry opisane poniżej).

@Component
public class ScheduledTask {
    private static final Logger log = LoggerFactory.getLogger(ScheduledTask.class);
    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm:ss");

    @Scheduled(fixedRate = 5000)
    public void executeTask() {
        log.info("Task executed at {}", dateFormat.format(new Date()));
    }
}

Po uruchomieniu naszej aplikacji co 5 sekund w konsoli wyświetlany będzie komunikat z metody `executeTask()` ![scheduler](http://codecouple.pl/wp-content/uploads/2016/12/Scheduler-1.png)

### **Parametry atrybutu @Scheduled:**

**1\. cron = "0 0 0 \* \* \*"** Parametr ten jest [CRON'owym](http://pl.docs.pld-linux.org/uslugi_cron.html) wyrażeniem składającym się z sześciu pól reprezentujących kolejno: sekundy, minuty, godziny, dni miesiąca, miesiące oraz dni tygodnia. Oddzielone są one spacjami. Miesiące i dni tygodnia mogą być podawane jako trzy pierwsze litery ich angielskich nazw lub jako liczby (dni tygodnia liczymy od 1: poniedziałek = 1, wtorek = 2 itd.).

Znak **\*** oznacza każdą wartość, a znak **?** oznacza niesprecyzowaną wartość. Użyć możemy jej kiedy np. chcemy wywoływać usługę w każdy piątek miesiąca i nie interesuje nas jakie to będą dni, to na 4 pozycji ustawiamy ?. Tak samo jeśli chcemy wywoływać usługę każdego 5 dnia miesiąca nie zważając na to jaki to będzie dzień tygodnia, to na 6 pozycji ustawiamy ?.

Poniżej parę przykładów:

*   `* 9 12 * * *` - co sekundę przez minutę od godz. 12:09:00 każdego dnia
*   `0 0 2-4 * * *` - godz.2:00:00, 3:00:00 i 4:00:00 każdego dnia
*   `0 * 6,19 * * 2` - 6:00:00 i 19:00:00 w każdy wtorek
*   `0 0/30 10 * JAN *` - 10:00:00, 10:30:00 każdego dnia stycznia
*   `0 0 12 * * MON-FRI` - 12:00:00 od poniedziałku do piątku
*   `0 0 0 3 5 ?` - każdego 3 maja o północy

**2\. fixedDelay** Czas w milisekundach pomiędzy ostatnio zakończonym zadaniem a rozpoczęciem następnego. Poprzednie zadanie musi być zakończone. **3\. fixedDelayString** Tak samo jak fixedDelay, ale parametr jest typu String, a nie long. **4\. fixedRate** Czas w milisekundach pomiędzy wywołaniami zadań. Poprzednie zadanie nie musi być zakończone. **5\. fixedRateString** Tak samo jak fixedRate, ale parametr jest typu String, a nie long. **6\. initialDelay** Opóźnienie w milisekundach przed wykonaniem pierwszego zadania fixedRate() lub fixedDelay(). **7\. initialDelayString** Tak samo jak initialDelay, ale parametr jest typu String, a nie long. **8\. zone** Strefa czasowa, dla której zadanie będzie wykonywane.

### **Zmiana parametru @Scheduled w trybie runtime:**

Wartość parametru adnotacji @Scheduled można ustawić w trakcie działania programu. Można wykorzystać do tego metodę `configureTasks` z interfejsu `SchedulingConfigurer`. Przyjmuje ona w parametrze obiekt klasy `ScheduledTaskRegistrar`, na którym możemy wywołać metody pozwalające nam zmienić interesujący nas parametr. Do powyższego przykładu dodałam klasę konfiguracyjną, w której po 20 sekundach od uruchomienia programu wartość `fixedRate` zmienia się z 5 sekund na 1. Zamiast wykorzystanej przeze mnie metody `addFixedRateTask` możemy użyć `addFixedDelayTask` lub `addTriggerTask`. Więcej szczegółów [TUTAJ](http://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/scheduling/config/ScheduledTaskRegistrar.html).

@Configuration
@EnableScheduling
public class SchedulerConfig implements SchedulingConfigurer {

    @Bean
    public ScheduledTask scheduledTask() {
        return new ScheduledTask();
    }

    @Override
    public void configureTasks(ScheduledTaskRegistrar taskRegistrar) {
        final LocalDateTime dateChange = LocalDateTime.now().plusSeconds(20);
            taskRegistrar.addFixedRateTask(new Runnable() {
                @Override
                public void run() {
                    if(LocalDateTime.now().isAfter(dateChange)) {
                        scheduledTask().executeTask();
                    }
                }
            }, 1000);
    }
}

Wynik działania zmodyfikowanego programu poniżej. Przez 20 pierwszych sekund (14:55:46-14:56:06) task uruchamiany jest co 5 sekund, a później co 1 sekundę.

![SchedulingRuntime](http://codecouple.pl/wp-content/uploads/2016/12/SchedulingRuntime.png) Cały projekt można znaleźć [TUTAJ](https://github.com/apieszczek/CodeCouple/tree/master/Scheduling). Scheduling wykorzystać możemy przy cyklicznym wysyłaniu maili (np. przy wysyłaniu ofert). Jeżeli chcecie się dowiedzieć czegoś więcej zapraszam [TUTAJ](http://docs.spring.io/spring/docs/current/spring-framework-reference/html/scheduling.html).

Zachęcam również do obejrzenia video:

https://www.youtube.com/watch?v=TEMsEcdAsbY