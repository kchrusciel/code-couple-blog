---
title: '#1 Spring Boot - banner/logo'
tags:
  - java
  - spring
  - spring boot
id: '569'
categories:
  - - Java
  - - Spring Boot
date: 2016-05-28 10:44:47
---

![](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)

Gdy prace nad naszą aplikacją w **Spring Boot'cie** rozpoczynają się lub dobiegają końca fajnie byłoby zmienić logo, które pojawia się po uruchomieniu aplikacji. W samym logo można wyświetlić więcej informacji na temat aplikacji. Znajdować mogą się tam miedzy innymi informacje o aktualnej wersji aplikacji oraz **Spring Boot'a**, zapraszamy!
<!-- more -->
### Domyślne logo

Po uruchomieniu aplikacji **Spring Boot'owej** ukazuje nam się następujące logo:

[![logoSpringBoot](http://codecouple.pl/wp-content/uploads/2016/05/logoSpringBoot.png)](http://codecouple.pl/wp-content/uploads/2016/05/logoSpringBoot.png)

### Wyłączenie logo

W **IntelliJ Idea** można wyłączyć wyświetlania log'a aplikacji we frameworku **Spring Boot**. Opcje tą znajdziemy tylko w płatnej wersji oprogramowania. W ustawienia uruchomienia aplikacji znajduje się check _Hide Banner_, który należy zaznaczyć:

[![springBootHideBanner](http://codecouple.pl/wp-content/uploads/2016/05/springBootHideBanner.png)](http://codecouple.pl/wp-content/uploads/2016/05/springBootHideBanner.png)

### Własne logo

Jeśli chcemy zmienić domyślne logo, należy utworzyć plik `banner.txt` w folderze `resources`:

[![bannerStruct](http://codecouple.pl/wp-content/uploads/2016/05/bannerStruct.png)](http://codecouple.pl/wp-content/uploads/2016/05/bannerStruct.png)

W pliku tym możemy wstawić dowolny tekst, który zostanie wyświetlony podczas uruchamiania aplikacji:

[![logoSpringBootText](http://codecouple.pl/wp-content/uploads/2016/05/logoSpringBootText.png)](http://codecouple.pl/wp-content/uploads/2016/05/logoSpringBootText.png)

### Generator

Jeśli chcemy, aby nasze logo było bardziej _fancy_ możemy wykorzystać [generator ASCII](http://patorjk.com/software/taag/#p=display&f=Big&t=CodeCouple.pl%0A).

[![logoSpringBootCC](http://codecouple.pl/wp-content/uploads/2016/05/logoSpringBootCC.png)](http://codecouple.pl/wp-content/uploads/2016/05/logoSpringBootCC.png)

Kolejne informacje jakie możemy umieścić w logo są zawarte [TUTAJ](http://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-spring-application.html) wykorzystując właściwości projektu:

Application: ${application.title}
Version: ${application.version}
Spring Boot version: ${spring-boot.version}

### Kolorki!

Możemy także zmieniać kolory naszego logo poprzez wykorzystanie **Ansi Color**:

${AnsiColor.RED} NAPIS

[A tutaj znajduje się link](https://github.com/snicoll-demos/spring-boot-4tw-uni/blob/master/spring-boot-4tw-web/src/main/resources/banner.txt) do kota:

[![logoSpringBootColor](http://codecouple.pl/wp-content/uploads/2016/05/logoSpringBootColor.png)](http://codecouple.pl/wp-content/uploads/2016/05/logoSpringBootColor.png)