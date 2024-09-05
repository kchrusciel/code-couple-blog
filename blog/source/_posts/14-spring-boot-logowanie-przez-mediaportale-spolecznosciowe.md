---
title: '#14 Spring Boot - logowanie przez media/portale społecznościowe'
tags:
  - java
  - login
  - signin
  - social media
  - spring
  - spring boot
id: '1010'
categories:
  - - Java
  - - Spring Boot
date: 2017-04-21 15:18:08
author: 'Krzysztof Chruściel'
---

[![springBootArt](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)

Media społecznościowe zawładnęły XXI wiekiem. Ciężko wyobrazić nam sobie aplikację, w której nie możemy zalogować się za pomocą **Facebook'a** lub **Twitter'a**. Dlatego właśnie przygotowałam krótki wpis, dzięki któremu dowiecie się jak szybko i łatwo można zaimplementować takie logowanie w kodzie swojej aplikacji wykorzystując **Spring Boot'owe** biblioteki.
<!-- more -->
Główna logika odbywa się w klasie **ConnectController**, która pod endpointem `/connect/{providerID}` wykonuje flow związane z wartością **providerID**. Providerem jest nazwa usługi np. `twitter` lub `facebook`. Następnie na podstawie nazwy usługi wykorzystywane jest odpowiednie **factory**, które tworzy połączenie. Połączenia przechowywane są w **ConnectionRepository**.

![spring_social_graf](http://codecouple.pl/wp-content/uploads/2017/04/spring_social_graf.png)  

Przejdźmy teraz do implementacji. Należy dodać zależności w naszym `pom.xml`:

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-social-twitter</artifactId>
</dependency>

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-social-facebook</artifactId>
</dependency>

W pliku `application.properties` musimy dodać `App ID` oraz `App Secret`:

\# SPRING SOCIAL FACEBOOK ([FacebookAutoConfiguration](https://github.com/spring-projects/spring-boot/tree/v1.5.2.RELEASE/spring-boot-autoconfigure/src/main/java/org/springframework/boot/autoconfigure/social/FacebookAutoConfiguration.java))
spring.social.facebook.app-id\= \# your application's Facebook App ID
spring.social.facebook.app-secret\= \# your application's Facebook App Secret

\# SPRING SOCIAL TWITTER ([TwitterAutoConfiguration](https://github.com/spring-projects/spring-boot/tree/v1.5.2.RELEASE/spring-boot-autoconfigure/src/main/java/org/springframework/boot/autoconfigure/social/TwitterAutoConfiguration.java))
spring.social.twitter.app-id\= \# your application's Twitter App ID
spring.social.twitter.app-secret\= \# your application's Twitter App Secret

Aby odczytać te wartości w przypadku Twitter'a musimy mieć zarejestrowane konto na stronie [Twitter Application Management](https://apps.twitter.com/). Kody znajdują się w zakładce **Keys and Access Tokens.** W przypadku Facebook'a musimy posiadać konto na [Facebook Developers](https://developers.facebook.com/). Dane dostępne są w zakładce **Ustawienia->Podstawowe**.

Jeśli chcemy wykorzystać mało spektakularne wbudowane widoki musimy dodać jeszcze jedną linię.

spring.social.auto\_connection\_views=true

Dzięki temu nie musimy pisać ani jednej linii kodu i mamy gotowe logowanie. Wchodzą teraz pod adres `/connect/twitter` zobaczymy taki widok:

![spring_social_view1](http://codecouple.pl/wp-content/uploads/2017/04/spring_social_view1.png)

Łączymy się z **Twitterem** i zostajemy poproszeni o zalogowanie się na swoje konto:

![spring_social_view2](http://codecouple.pl/wp-content/uploads/2017/04/spring_social_view2.png)

A to widok po zalogowaniu:

![spring_social_view3](http://codecouple.pl/wp-content/uploads/2017/04/spring_social_view3.png) Analogiczne widoki otrzymamy dla **Facebook'a**.

Widzicie jakie to proste? Mamy ustawione tak naprawdę tylko propertiesy, a całość załatwia za nas **Spring Social**. Widoki te oczywiście możemy dostosować do własnych potrzeb. Należy przede wszystkim usunąć wpis o domyślnych widokach z properties'ów. Potem stworzyć swoje widoki w plikach _**{p****roviderID}Connect**_ i _**{p****roviderID}Connected**_ (w naszym przypadku twitterConnect i twitterConnected) i umieścić je w folderze _**connect**_.

Należy zauważyć, że **Spring Social** to nie tylko **Facebook** czy **Twitter**. Możemy wykorzystać go również do połączeń z wieloma innymi usługami:

![](http://codecouple.pl/wp-content/uploads/2017/04/spring_social_services-1024x408.png)

Jednym z ciekawszych projektów jest [Ecobee](https://github.com/gregturn/spring-social-ecobee), czyli system do zarządzania **termostatami**. Patrząc na spis dostępnym usług widzimy, że nie wszystkie dotyczą mediów społecznościowych, dlatego nawet sam kierownik projektu **Gary Russell**, jest zdania, że określenie Social nie jest do końca poprawne. Może lepsze byłoby Connect!