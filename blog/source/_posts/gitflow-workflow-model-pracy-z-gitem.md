---
title: Gitflow Workflow - model pracy z Git'em
tags:
  - GIT
id: '153'
categories:
  - - GIT
date: 2016-02-11 09:13:22
author: 'Krzysztof Chruściel'
---

**GIT** - czyli najpopularniejszy system kontroli wersji. Zyskał on swoją popularność między innymi dzięki bardzo prostej pracy z **branchami** ([Więcej informacji na temat systemów kontroli wersji](http://codecouple.pl/2016/02/05/system-kontroli-wersji-opis-oraz-definicje/)). Po pewnym czasie developerzy zauważyli, iż dałoby się uogólnić model pracy z **GIT'em,** czyli **Workflow,** lub jak też bywa nazwany w kontekście GIT - Gitflow.
<!-- more -->
Na początku przyjrzyjmy się rysunkowi, który przedstawia schemat pracy w modelu **Gitflow**:

[![gitflow](http://codecouple.pl/wp-content/uploads/2016/02/gitflow.png)](http://codecouple.pl/wp-content/uploads/2016/02/gitflow.png) Głównymi gałęziami są:

*   **Master**
*   **Develop**

Pracę rozpoczynamy od utworzenia dwóch gałęzi, **master** oraz **develop**. W branchu master umieszczamy wersję ostateczną, czyli released. W gałęzi **develop** umieszczamy wszystkie **branche** związane z dodaniem nowej funkcjonalności. **Master** i **develop** to tzw. gałęzie nieśmiertelne lub wieczne, ponieważ powinny one istnieć przez cały proces wytwarzania oprogramowania.

**Master** - przechowuje tylko wersję finalną i oznaczana jest tag'iem, czyli numerem wersji. **Develop** - zawiera wersję developerską, czyli taką, do której wprowadzane są zmiany. Po utworzeniu dwóch głównych linii rozwojowych pora na omówienie linii poboczny (gałęzie ulotne):

*   **Feature**
*   **Hotfix**
*   **Release**

Każdy z tych **branchy** należy stosować zgodnie z jego przeznaczeniem!

**Feature** - jest to gałąź, która ma swój korzeń w **develop** oraz powinna kończyć się w **develop** (w przypadku porzucenia rozwoju funkcjonalności nie scalamy z **develop**). Przechowujemy tutaj wszystkie nowe funkcjonalności oraz elementy, które mają być przetestowane przed wdrożeniem na produkcję. Nazewnictwo:

*   nie ma tutaj jednoznaczniej nazwy identyfikującej
*   nie używać nazw zastrzeżonych: **master**, **develop**, **hotfix**\-\* lub **release**\-\*

**Tworzenie feature brancha:**

$ git checkout -b feature-datapicker develop

**Scalenie feature brancha z develop:**

$ git checkout develop
Switched to branch 'develop' 
$ git merge --no-ff feature-datapicker
Updating ea1a84b..05e1287
(Summary of changes) 
$ git branch -d feature-datapicker
Deleted branch feature-datapicker (was 05e1287). 
$ git push origin develop

**\--no --ff** - czyli "_no_ _fast forward_" jest to opcja, na którą warto zwrócić uwagę. Ustawienie tych flag powoduje utworzenie pustego **commita** w przypadku, gdy nie było zmian w **develop'ie.** Dzięki temu mamy możliwość przywrócenia zmian po wprowadzeniu jakiegoś **feature'a**, który miał kilka **commitów**. Gdy nie ustawimy tych flag, a w **develop'ie** nie będzie innych zmian niż nasze, wtedy występuje automatyczne przesunięcie "_fast_ _forward_" wskaźnika poprzez **feature** do **develop**. Poniżej znajduje się rysunek prezentujący koncepcje "_no_ _fast forward_".

[![fast-forward-merge](http://codecouple.pl/wp-content/uploads/2016/02/fast-forward-merge.jpg)](http://codecouple.pl/wp-content/uploads/2016/02/fast-forward-merge.jpg)

**Hotfix** - jest do gałąź, która ma swój korzeń w **master**. Wykonywane są w niej zadania, które związane są z naprawą błędów w aktualnie wydanej wersji. Wtedy wszyscy programiści powinni skupić się na tym zadaniu. Po rozwiązaniu problemu bardzo ważne jest scalenie brancha **hotfix** z branchami **master** oraz **develop**. W **master** umieszczona jest wersja bez błędu (każdorazowe umieszczenie czegoś w gałęzi master oznacza **release**). Należy także scalić poprawkę z **develop'em**, aby móc pracować na najnowszej wersji (czyli tej z poprawką). Nazewnictwo:

*   **hotfix**\-\* - gdzie \* oznacza nazwę błędu lub naprawy

**Tworzenie hotfix brancha:**

$ git checkout -b hotfix-0.5.1 master
Switched to a new branch "hotfix-0.5.1" 
$ do\_some\_fix
$ git commit -a -m "Fixed some bug"
\[hotfix-0.5.1 59a69bb\] Fixed some bug
1 files changed, 1 insertions(+), 1 deletions(-)

**Zatwierdzenie zmian:**

$ git commit -m "Fixed few things"
\[hotfix-0.5.1 deda8a7\] Fixed few things
10 files changed, 15 insertions(+), 5 deletions(-)

**Wydanie wersji z poprawką:**

$ git checkout master
Switched to branch 'master' 
$ git merge --no-ff hotfix-0.5.1
Merge made by recursive.
(Summary of changes) 
$ git tag -a 0.5.1

**Scalenie z develop:**

$ git checkout develop
Switched to branch 'develop' 
$ git merge --no-ff hotfix-0.5.1
Merge made by recursive.
(Summary of changes)

**Po wykonanej naprawie można usunąć brancha:**

$ git branch -d hotfix-0.5.1
Deleted branch hotfix-0.5.1 (was deda8a7).

**Release** - jeżeli uznaliśmy, że mamy już wystarczającą ilość nowych funkcji (wszystkie branche **feature** muszą być scalone z **develop** \- jeśli nie, to pójdą w następnym wydaniu) tworzymy gałąź **release**. Wychodzi ona z **develop'a** i kończy tym samym dany etap pracy. Utworzenie tej linii oznacza także chęć wydania wersji. W gałęzi **release** dodajemy notatki, aktualizujemy dokumentacje, a także dokonujemy lekkich napraw przed samym wydaniem (to jest też dobry czas na testy integracyjne, QA itp.). Po skończeniu pracy musimy scalić nasz **release** z **master'em** oraz **develop'em.** Z **master'em** \- aby wydać wersję (dodajemy tag), natomiast z **develop'em** \- aby była aktualna wersja do pracy. Nazewnictwo:

*   **release**\-\* - gdzie \* oznacza numer wydania

**Tworzenie release brancha:**

$ git checkout -b release-0.5 develop
Switched to a new branch "release-0.5" 
$ do\_some\_modification
$ git commit -a -m "Release version 0.5" 
\[release-0.5 84d2494\] Release version 0.5
1 files changed, 1 insertions(+), 1 deletions(-)

**Wydanie wersji:**

$ git checkout master
Switched to branch 'master' 
$ git merge --no-ff release-0.5
Merge made by recursive.
(Summary of changes) 
$ git tag -a 0.5

**Scalenie z develop:**

$ git checkout develop
Switched to branch 'develop' 
$ git merge --no-ff release-0.5
Merge made by recursive.
(Summary of changes)

**Po wykonanych zmianach branch można usunąć:**

$ git branch -d release-0.5
Deleted branch release-0.5 (was 84d2494).