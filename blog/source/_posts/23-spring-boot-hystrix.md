---
title: '#23 Spring Boot - Hystrix'
tags:
  - circuit breaker
  - hystrix
  - spring boot
id: '2386'
categories:
  - - Spring Boot
date: 2017-11-24 12:11:34
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)

**FailFast** to podejście, w którym w jak najszybszym czasie dostajemy informację o tym, że coś działa niepoprawnie. Jednym z rozwiązań realizujących tą technikę jest biblioteka **Hystrix** ze stajni **Netflix'a**. Swoje rozwiązanie realizują oni jako **CircuitBreaker**, czyli bezpiecznik, który jeśli dzieje się coś niepożądanego zostaje włączony.
<!-- more -->
### Zasada działania

W architekturze mikroserwisów odpytujemy inne usługi o informacje, które wymagane są do realizacji naszej logiki. Często odpytujemy usługi, które nie są tworzone przez nas. Może zdarzyć się, iż usługa nie działa poprawnie, lub jest niedostępna. Wtedy "opakowujemy" naszą logikę odpowiedzialną za odpytywanie innych usług, jako komendę **Hystrix'ową**. W przypadku wystąpienia błędu, wywoływana jest metoda (ang. _fallback method_) odpowiedzialna za obsługę zdarzenia krytycznego.  Jeśli dalej będziemy odpytywać niedziałającą lub wolno działającą usługę, na pewno jej to nie pomoże. Nasze kolejne odpytywania mogą jeszcze bardziej zwolnić usługę. **Hystrix** zapobiega takim praktykom. W momencie, gdy biblioteka widzi, iż usługa nie odpowiada lub działa niepoprawnie zostaje wtedy włączony bezpiecznik (ang. _circuit breaker_). Po włączeniu bezpiecznika automatycznie zwracana jest wartość metody fallback. Dzięki temu, usługa zewnętrzna ma czas na restart lub realizację zadań, co umożliwi jej ponowne poprawne działanie. Wyłączenie bezpiecznika następuję wtedy, gdy usługa, którą odpytujemy działa już poprawnie. Tyle teorii, jeśli nadal jest to niejasne, kod wszystko wyjaśni!

### Włączamy Hystrix'a

Zaczynamy od dodania zależności **Mavenowej**:

<dependency>
   <groupId>org.springframework.cloud</groupId>
   <artifactId>spring-cloud-starter-hystrix</artifactId>
</dependency>

Aby uruchomić **Hystrix'a** w naszej aplikacji należy użyć adnotacji `@EnableCircuitBreaker`:

@SpringBootApplication
@EnableCircuitBreaker
public class HystrixExampleApplication {

   public static void main(String\[\] args) {
      SpringApplication.run(HystrixExampleApplication.class, args);
   }
}

### Tworzymy kontroler

Aby skorzystać z **Hystrix'a** należy użyć adnotacji `@HystrixCommand`, a jako parametr `fallbackMethod` wskazać metodę, która będzie wywoływana w przypadku błędu. Naszym błędem, będzie wylosowanie liczby większej niż 5. **Uwaga!** Metoda `fallbackMethod` musi mieć takie same parametry jak metoda z adnotacją.

@RestController
class RandomController {

    @GetMapping("/")
    @HystrixCommand(fallbackMethod = "fallback")
    String getRandomNumber(){
        int result = new Random().nextInt(10);
        if (result > 5) {
            throw new RuntimeException("¯\\\\\_(ツ)\_/¯");
        }
        return String.format("The number is {%d}", result);
    }

    String fallback(){
        return "Hystrix is working!";
    }

}

### Wartości domyślne

Bardzo ważnym aspektem związanym z pracą biblioteki **Hystrix** jest poznanie wartości domyślnych. Domyślny timeout dla commendy to jedna sekunda. Hystrix zbiera także statystki z ostatnich **dziesięciu sekund** w przesuwnym oknie czasowym. Na podstawie tych statystyk podejmowana jest decyzja czy włączyć bezpiecznik. Aby bezpiecznik się włączył (przejście w stan **OPEN**) w danym oknie czasowym musi być spełnionych kilka warunków:

*   minimum 50 %  żądań zakończonych niepowodzeniem
*   tych żądań musi być minimum 20

Po włączeniu bezpiecznika wywoływana jest metoda fallback, jednakże nie trwa to w nieskończoność. Po okołu 5 sekundach nasz bezpiecznik przechodzi w stan **HALF-OPEN**, co oznacza, że jedno z żądań klienta zostanie wysłane to usługi. Jeśli działa ona poprawnie, nasz bezpiecznik się wyłącza (przechodzi w stan **CLOSED**).

### Testujemy!

Aby przetestować naszą aplikację udajemy się pod nasz endpoint i odświeżamy kilka razy. W pewnym momencie jedynym wynikiem jaki będziemy dostawać to wynik metody `fallback`, czyli "_Hystrix is working_". Oznacza to, iż włączył się bezpiecznik. Jednakże, testowanie w taki sposób nie jest najlepszym rozwiązaniem. Powinniśmy użyć jednej z dostępnych bibliotek/narzędzi do testów performance. Biblioteką, którą chcę wam zaprezentować jest **Apache Benchmark**, w skrócie `ab`. Jest to command line'owa aplikacja do przeprowadzania stres testów. Wydajemy polecenie:

ab -n 1000 -c 100 http://localhost:8080/

gdzie:

\-`n` - liczba requestów

\-`c` - liczba wątków (czyli userów)

Otrzymujemy wynik:

Benchmarking localhost (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Completed 600 requests
Completed 700 requests
Completed 800 requests
Completed 900 requests
Completed 1000 requests
Finished 1000 requests
Server Software:
Server Hostname: localhost
Server Port: 8080

Document Path: /
Document Length: 17 bytes

Concurrency Level: 100
Time taken for tests: 0.873 seconds
Complete requests: 1000
Failed requests: 732
(Connect: 0, Receive: 0, Length: 732, Exceptions: 0)
Non-2xx responses: 40
Total transferred: 194464 bytes
HTML transferred: 26024 bytes
Requests per second: 1145.41 \[#/sec\] (mean)
Time per request: 87.305 \[ms\] (mean)
Time per request: 0.873 \[ms\] (mean, across all concurrent requests)
Transfer rate: 217.52 \[Kbytes/sec\] received

Jak widzicie, ponad **70%** żądań nie wykonało się poprawnie, ponieważ **Hystrix** zauważył, że nasza usługa ma problemy. Z tego powodu został włączony bezpiecznik. W następnych wpisach pokaże wam jak dodać **dashboard** do naszego **Hystrix'a**. Pojawi się także wpis o **Turbine**. Całość jak zawsze na [GitHubie](https://github.com/kchrusciel/Spring-Boot-Examples/tree/master/spring-boot-hystrix-example).