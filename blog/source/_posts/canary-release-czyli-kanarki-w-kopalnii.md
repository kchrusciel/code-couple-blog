---
title: Canary Release - czyli kanarki w kopalnii
tags:
  - canary release
  - continuous delivery
  - design pattern
  - wzorce projektowe
id: '1685'
categories:
  - - Wzorce projektowe
date: 2017-06-16 15:27:03
---

[![canary-release-logo](http://codecouple.pl/wp-content/uploads/2017/04/canary-release-logo.png)](http://codecouple.pl/wp-content/uploads/2017/04/canary-release-logo.png)

**Kanarki** wykorzystywane były w kopalniach do wczesnego wykrywania zagrożeń. Przez swoją mniejszą masę bardziej niż ludzie odczuwały efekt ulatniającego się metanu w kopalniach. Po wykryciu trującego gazu kanarki były zamroczone lub umierały dzięki czemu można było na czas ewakuować górników. Wczesne wykrywanie **błędów/zagrożeń** przed innymi nawiązuje do [kolejnego wzorca](http://codecouple.pl/2017/04/14/blue-green-deployment/) jakim jest **Kanarkowe wydanie** (ang. Canary release) którego nazwa nawiązuję do kanarków wykorzystywanych w kopalniach.
<!-- more -->
**Prawdziwe błędy wyjdą na produkcji**! Wzorzec ten jest bardzo podobny do wzorca [BlueGreenDeployment](http://codecouple.pl/2017/04/14/blue-green-deployment/) którego opisywałem już na blogu. Musimy posiadać dwa identyczne środowiska. **Router** kieruje cały ruch na nasze aktualne środowisko produkcyjne.

[![](http://codecouple.pl/wp-content/uploads/2017/05/canaryRelease1-1.png)](http://codecouple.pl/wp-content/uploads/2017/05/canaryRelease1-1.png)

Jeśli postanowimy wydać nową wersję umieszczamy ją na identyczny środowisku i zaczynamy kierować ruch na nową wersję. Jednakże kierujemy tylko jakiś **niewielki** procent ruchu (w [BlueGreenDeployment](http://codecouple.pl/2017/04/14/blue-green-deployment/) był to cały ruch).

[![](http://codecouple.pl/wp-content/uploads/2017/05/canaryRelease2.png)](http://codecouple.pl/wp-content/uploads/2017/05/canaryRelease2.png)

O tym, jak duży procent ma to być decydują różne czynniki. Możemy wykorzystać czynniki **demograficzne** lub **profile użytkowników**, na przykład użytkownicy którzy często korzystają z nowych funkcji dostaną je od razu. **Facebooku** wykorzystywał swoich pracowników do wstępnego **kanarkowego testowania** nowej wersji aplikacji. Jeśli u pracowników nie pojawiały się **krytyczne** błędy udostępniali oni nową wersję specyficznym **regionom**. Jeśli w poszczególnych regionach nie wystąpiły problemy z aplikacją zostaje ona udostępniona dla wszystkich. Wzorzec ten pozwala testować aplikację na produkcji z prawdziwymi użytkownikami a w przypadku awarii udostępnia mechanizm szybkiego **rollbacku** (wystarczy przekierować cały ruch na środowisku numer jeden). Można także testować kilka wersji naraz jednakże powinniśmy ograniczać tą praktykę do minimum!