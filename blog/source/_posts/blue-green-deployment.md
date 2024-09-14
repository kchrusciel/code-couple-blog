---
title: Blue-Green-Deployment
tags:
  - blue green deployment
  - CD
  - design pattern
id: '1579'
categories:
  - - Wzorce projektowe
date: 2017-04-14 15:45:44
author: 'Krzysztof Chruściel'
---

[![blueGreenDeployment](http://codecouple.pl/wp-content/uploads/2017/03/blueGreenDeployment.png)](http://codecouple.pl/wp-content/uploads/2017/03/blueGreenDeployment.png)[Ciągłe dostarczanie oprogramowania](https://en.wikipedia.org/wiki/Continuous_delivery) sprawiło powstanie wielu ciekawych wzorców związanych z różnymi fazami developmentu. Jedną z tych faz jest **deployment**. No właśnie, ale jak wdrożyć nową wersję aplikacji na produkcję, z której korzystają klienci? Jednym z dostępnych rozwiązań jest wzorzec **Blue-Green-Deployment**.
<!-- more -->
Celem tego wzorca jest zminimalizowanie ryzyka związanego z wdrożeniem nowej wersji na produkcję. W tym wzorcu posiadamy dwa identyczne (o ile to możliwe) lub jak najbardziej zbliżone do siebie środowiska, które nazywane są odpowiednio **Blue** oraz **Green**.

Zakładamy, że na środowisku **Blue** znajduje się aktualnie nasza wersja produkcyjna i cały ruch kierowany jest na to środowisko przy wykorzystaniu  **Router'a** (na przykład [NGINX](https://www.nginx.com/resources/wiki/)).**[![blueGreenDeployment1](http://codecouple.pl/wp-content/uploads/2017/04/blueGreenDeployment1.png)](http://codecouple.pl/wp-content/uploads/2017/04/blueGreenDeployment1.png)**

Gdy mamy już gotową wersję (w pełni przetestowaną itd.) umieszczamy ją na drugim środowisku **Green**. Teraz ustawiamy nasz **Router,** aby kierował cały ruch także na środowisko **Green.[![blueGreenDeployment2](http://codecouple.pl/wp-content/uploads/2017/04/blueGreenDeployment2.png)](http://codecouple.pl/wp-content/uploads/2017/04/blueGreenDeployment2.png)**

Gdy aplikacja na środowisku **Green** jest stabilna kierujemy główny ruch na to środowisko.

[![blueGreenDeployment3](http://codecouple.pl/wp-content/uploads/2017/04/blueGreenDeployment3.png)](http://codecouple.pl/wp-content/uploads/2017/04/blueGreenDeployment3.png)

Teraz możemy usunąć tymczasowe połączenie na środowisku **Green** i ustawić tymczasowe połączenie na środowisku Blue (dzięki temu nie tracimy danych i możemy zrobić **rollback**)

[![blueGreenDeployment4](http://codecouple.pl/wp-content/uploads/2017/04/blueGreenDeployment4.png)](http://codecouple.pl/wp-content/uploads/2017/04/blueGreenDeployment4.png)

Teraz możemy usunąć środowisko **Blue** jeśli nie jest nam już potrzebne.[![blueGreenDeployment5](http://codecouple.pl/wp-content/uploads/2017/04/blueGreenDeployment5.png)](http://codecouple.pl/wp-content/uploads/2017/04/blueGreenDeployment5.png)

Nie usuwamy oczywiście od razu środowiska **Blue,** ponieważ w przypadku szybkiej awarii albo braku przetestowania jakiegoś komponentu możemy znów przestawić cały ruch z powrotem na to środowisko.

Oczywiście takie rozwiązanie sprawdzi się tylko wtedy, gdy mamy bardzo dobrze zaprojektowany system. W aplikacji z wbudowaną bazą stracimy informacje pomiędzy wersjami. Powinniśmy zaprojektować aplikację tak, aby w momencie zmiany ruchu na drugie środowisko mieć możliwość przełączenia jej w tryb **read-only.** Tryb ten oznacza, iż aplikacja nadal pracuje i jest zasilana danymi przez jakiś czas.

Powinniśmy traktować to drugie środowisko jako **staging** (czyli miejsce gdzie trzymamy naszą przetestowaną aplikację na środowisku maksymalnie podobnym do produkcyjnego). Cały ten proces powtarzamy cyklicznie. W kolejnej iteracji to środowisko **Blue** jest naszym **stagingiem**, natomiast **Green** produkcją.

Wzorzec ten może być także stosowany jako "**plan awaryjny**". Możemy na obu środowiskach trzymać tą samą wersję i zasymulować **awarię** na jednym ze środowisk. Dzięki temu możemy **przetestować** zachowanie aplikacji w przypadku awarii, zobaczyć gdzie straciliśmy dane, co zawiodło i w następnym **release** naprawić to.

No dobra ale jak poradzić sobie z bazą? Za jakiś czas napiszę o **Flyway** lub **Liquibase** ;)