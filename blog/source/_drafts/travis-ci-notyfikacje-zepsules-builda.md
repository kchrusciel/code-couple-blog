---
title: Travis CI + notyfikacje - zepsułeś build'a!
tags:
  - ci
  - continuous delivery
  - travis ci
id: '3669'
categories:
  - - Java
---

![](https://codecouple.pl/wp-content/uploads/2019/02/travisci.png)

W poprzednim wpisie stworzyliśmy naprawde prosty proces ciągłej intregacji. W przypadku gdy testy nie przeszły nasz build również nie zakończył się sukcesem. W Travis CI zostało to przedstawione jako "czerowny" build. Jednakże aby dowiedzieć się czy nas proces budowania zakończył się sukcesem musimy co jakiś czas sprawdzać Travis'a. Rozwiązaniem tego problemu są notyfikacje, które poinformują nas o wydarzeniach w procesie budowania.
<!-- more -->
### Zanim zaczniemy...

asas

### Notyfikacje

sas

### Email

Pierwszym a zarazem domyślnym sposobem komunikacji są tradycyjne wiadomości email. Aby wskazać adresy na jakie ma zostać wysłany email należy wykorzystać poniższy wpis:

notifications:
  email:
    - code@codecouple.pl
    - couple@codecouple.pl

Ponadto możemy wyłączyć całkowicie notyfikacje **email**:

notifications:
  email: false

dsad ![](https://codecouple.pl/wp-content/uploads/2019/02/travis-email.png)

Czasem może zdarzyć się że nie otrzymaliśmy powiadomienia na email. Travis CI zastrzega, iż wysyła email tylko na [adresy umieszczone](https://github.com/settings/emails) w serwisie GitHub.

### Slack

Drugim sposobem informowania nas o postępach jest aplikacja **Slack**. Aktualnie **Slack** jest jednym z najpopularniejszych komunikatorów wykorzystywanych w branży **IT**. Aby dodać integrację należy wejść pod adres [https://my.slack.com/services/new/travis](https://my.slack.com/services/new/travis) i wybrać kanał, na który chcemy aby publikowane były wiadomości:

![](https://codecouple.pl/wp-content/uploads/2019/02/travis-channel.png)

Po wybraniu odpowiedniego kanału ukaże się kolejna strona. Na tej stronie znajdziemy wpis, który musimy wstawić w pliku .travis.yml:

![](https://codecouple.pl/wp-content/uploads/2019/02/travis-channel-cred.png)

sasa

### Inne sposoby

Oprócz opisanych powyżej sposobów **Travis CI** potrafi **integrować** się również z:

*   [IRC](https://docs.travis-ci.com/user/notifications/#configuring-irc-notifications) (ktoś jeszcze używa?)
*   [Campfire](https://docs.travis-ci.com/user/notifications/#configuring-campfire-notifications)
*   [Flowdock](https://docs.travis-ci.com/user/notifications/#configuring-flowdock-notifications)
*   [Hipchat](https://docs.travis-ci.com/user/notifications/#configuring-hipchat-notifications) (został zmieniony na Slack'a)
*   [Pushover](https://docs.travis-ci.com/user/notifications/#configuring-pushover-notifications)
*   [Webhook](https://docs.travis-ci.com/user/notifications/#configuring-webhook-notifications)
*   [Opsgenie](https://docs.travis-ci.com/user/notifications/#configuring-opsgenie-notifications)

### Więcej

Więcej informacji na temat notyfikacji znajdziecie na stronie [https://docs.travis-ci.com/user/notifications/](https://docs.travis-ci.com/user/notifications/).

### Github

Całość jak zawsze na Github'ie.