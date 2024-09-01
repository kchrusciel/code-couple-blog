---
title: Java + GitHub + Travis CI + Heroku
tags: []
id: '4151'
categories:
  - - Java
---

![](https://codecouple.pl/wp-content/uploads/2019/11/heroku.png)

Powracamy z kontynuacją serii o **CI/CD**. Dziś zintegrujemy nasz proces budowania pochodzący z **Travis CI** z darmowym hostingiem oferowany przez usługę **Heroku**. **Heroku** jest platformą, która od wielu lat dostarcza **darmowy** (jak i płatny) hosting dla rozwiązań napisanych w wielu językach w tym Go, PHP, Python czy też **Javie**. Ponadto posiada bardzo dobrze przygotowane integracje z innymi serwisami w tym z **Travis CI**, zapraszamy po szczegóły!
<!-- more -->
### Poprzedni wpis

Dzisiejszy wpis jest kontynuacją serii o **CI/CD**. Aby lepiej zrozumieć idee tego wpisu najlepiej zapoznać się z poprzednim wpisem [Java Travis CI czyli darmowe continuous integration](https://codecouple.pl/2019/02/08/java-travis-ci-czyli-darmowe-continuous-integration/).

### Konto na Heroku

Na samym początku musimy [założyć konto na Heroku](https://signup.heroku.com/):

![](https://codecouple.pl/wp-content/uploads/2019/11/heroku-signup-1024x533.png)

### Dodajemy aplikację

Po założeniu konta pora na stworzenie **pierwszej** aplikacji:

![](https://codecouple.pl/wp-content/uploads/2019/11/heroku-add-app.png)

### Integracja z GitHub

Dodaliśmy aplikację, teraz musimy wskazać, że będzie ona korzystać z **GitHub'a** jako źródła kodu (klikamy _Connect to GitHub_):

![](https://codecouple.pl/wp-content/uploads/2019/11/heroku-github-1024x939.png)

### Wybieramy repozytorium

Po ustawieniu integracji z **GitHub** pora na wskazanie **repozytorium** z którego będziemy korzystać do **umieszczania** aplikacji w chmurze:

![](https://codecouple.pl/wp-content/uploads/2019/11/heroku-repository-choose-1024x165.png)

### Automatyczny deployment

**Włączamy** automatyczny deployment i pamiętamy aby **zaznaczyć** checkbox _Wait for CI to pass before deploy_: ![](https://codecouple.pl/wp-content/uploads/2019/11/heroku-enable-deploy-1024x247.png)

### Sprawdzamy integracje

Jeśli wszystko poszło po naszej myśli to na **GitHubie** na wybranym repozytorium powinien pojawić się nowy wpis w sekcji **Webhook**:

![](https://codecouple.pl/wp-content/uploads/2019/11/heroku-webhook-1024x498.png)

### Heroku Command Line

asas

### Łączymy Heroku z Travis CI

asas

### Sprawdzamy działanie

asas