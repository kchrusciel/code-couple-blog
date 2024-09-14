---
title: Niekompletny GitFlow?
tags:
  - GIT
  - gitflow
id: '1636'
categories:
  - - GIT
date: 2017-04-28 16:00:14
author: 'Krzysztof Chruściel'
---

[![git-logo](http://codecouple.pl/wp-content/uploads/2017/04/git-logo.png)](http://codecouple.pl/wp-content/uploads/2017/04/git-logo.png)[W jednym z pierwszych artykułów opisywałem GitFlow](http://codecouple.pl/2016/02/11/gitflow-workflow-model-pracy-z-gitem/) jako metodykę pracy z **Gitem**. Zaczynamy teraz wdrażać ten model w firmie i zaczynają pojawiać się problemy/pytania. No właśnie, **GitFlow** miał rozwiązywać wszystkie problemy i odpowiadać na wszystkie pytania, czy aby na pewno?
<!-- more -->
### Słowem wstępu

Korzystamy z systemu **BitBucket,** dlatego też zdecydowaliśmy się na połączenie pracy **GitFlow** + **PullRequest**. Zablokowane jest mergowanie zmian do brancha **develop** oraz **master** bez **PullRequesta**. **PullRequest** to tak naprawdę prośba o **CodeReview**, z tą różnicą, że cały flow przebiega w systemie **BitBucket Server**.

### 1. Kto powinien mergować - czyli nieskończona pętla

W samym systemie **BitBucket Server** możemy na różne sposoby zdefiniować politykę pracy z **Pull Requestami**. Jednym z dostępnych obostrzeń jest to, iż nasza zmiana musi być zatwierdzona przez minimum jedną osobę. Załóżmy teraz hipotetycznie, że dostajemy **Pull Requesta** do przejrzenia, nie rzucamy naszej pracy od razu, bo nas kolega poprosił o **CodeReview**. Minęło kilka dni, zaczynamy przeglądać kod wszystkie zmiany są w porządku, ale przycisk do mergowania jest nieaktywny bo jest konflikt. To nie jest nasz kod, więc odrzucamy tego **Pull Requesta** i ten kolega też nie rzuca się od razu do rozwiązania konfliktów. Mija kilka dni i znów wysyła do nas do zatwierdzenia, sytuacja się zapętla.

Można by umówić się tak, że po rozwiązaniu konfliktów mergowanie wykonuje autor **Pull Requesta** ale to nie przejdzie, bo ustawiony jest minimum jeden **approver**. Po za tym zatwierdzanie komuś zmian bez ich przeglądania nie jest dobry rozwiązaniem, bo w momencie zatwierdzenia zmian bierzemy także za nie odpowiedzialność.

Rozwiązaniem mogłyby być mniejsze zmiany i mniejszy **coupling** wprowadzanego kodu.

### 2. Co powinno być w branchu release - bugfixy?

Kolejne pytanie, co powinien zawierać branch release? Czy to jest czas na start testów integracyjnych czy czas na testy regresyjne, a może na pisanie dokumentacji? Nie jest to nigdzie jasno opisane i pojawia się problem co z błędami, które pojawią się po testach? Czy powinny być naprawiane jako **bugfix** w obrębie **release** brancha? Jeśli tak, to w momencie, gdy jest to jakiś krytyczny błąd to dopóki dopóty ten branch nie zostanie zmergowany do **developa**, błąd nadal będzie występował u "chłopaków z developmentu".

Można spróbować radzić sobie z tym w taki sposób, aby po każdym **bugfixie** na **release** branchu mergować tego brancha z **developem**,

### 3. Mergowanie brancha release - za dużo zmian

Kolejną fajną funkcją w **BitBucket Server** jest **automerging**. Jeśli stworzymy sobie **release** brancha i po wykonaniu akcji związanych z **release** branchem mamy możliwość **zmergowania** go. Zgodnie z **GitFlow** branch **release** powinien być zmergowany do brancha **master** oraz **develop**, czyli stworzyć dwa **Pull Requesty**? Nie, wystarczy jeden. Należy wskazać, iż chcemy zmergować nasz branch **release** do brancha **master**, a **automerging** automatycznie pokaże nam, że zmerguje nasze zmiany do **mastera** i **developa**. Fajna funkcjonalność, sporo ułatwia ale za razem utrudnia. Otóż po wybraniu brancha, do którego chcemy mergować (w naszym przypadku **master**), pojawiają się wszystkie zmiany w stosunku **release/master**. No właśnie, ale **release** wychodzi z **developa**, więc widzimy bardzo dużo zmian jeśli nasza faza developmentu trwała bardzo długo. Sprawdzanie tych zmian jest bezsensowne, ponieważ i tak przed zmergowaniem tych zmian do **developa** wszystkie były sprawdzane poprzez **Pull Requesty**. Można zawsze nie korzystać z **automerga** i mergować nasz branch **release** do **developa** i wtedy rzeczywiście sprawdzimy zmiany jakie zostały wykonane w branchu **release**, jednakże znów kosztuje nas to pracę, bo znów musimy tworzyć **Pull Requesta**, żeby zmergować tego brancha do **mastera**, co jest mocno nadmiarowe.

Jak wy radzicie sobie z tymi problemami?