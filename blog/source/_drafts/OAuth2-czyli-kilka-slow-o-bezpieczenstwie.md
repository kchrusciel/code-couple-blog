---
title: OAuth2 - czyli kilka słów o bezpieczeństwie
tags: []
id: '2623'
categories:
  - - Python
---

Protokół **OAuth2** jest jednym z najpopularniejszy protokołów wykorzystywanych do autoryzacji aplikacji. Wszędzie tam, gdzie podczas logowania do aplikacji wykorzystujemy dane z aplikacji **Google** czy **GitHub** możemy mieć pewność iż korzystamy ze standardu **OAuth2**. Na pierwszy rzut oka sposób działania tego protokołu wydaje się trudny, dlatego w tym wpisie postaramy się to trochę rozjaśnić. Zapraszamy!
<!-- more -->
### Po co? Na co? Dlaczego?

Rozproszona architektura pozwala w łatwy sposób rozwiązać takie problemy jak skalowalność czy szybsze dostarczanie. Jednakże powoduje powstanie nowych problemów. Jednym z nich jest sposób zabezpieczania naszych zasób. Dotychczas posiadając aplikację monolityczną nasze zabezpieczenia były realizowane w jednym miejscu, teraz problem zaczyna się replikować na każdy serwis. Czy każdy serwis powinien mieć osobny mechanizm, czy może jeden wspólny? Protokół **OAuth2** stara się ustandaryzować sposób zabezpieczania zasobów, który może być z powodzeniem wykorzystywany w środowiskach rozproszonych. Przykładowo użytkownik (**client**) chce zalogować się do aplikacji (**resource server**), klika na przycisk "_zaloguj się z GitHub'em_" następnie przekierowywany jest do formularzu logowania (**consent screen**) gdzie wpisuje swoje dane. Jeśli dane zostały zatwierdzone przez GitHub'a (**authroziation server**) jesteśmy z powrotem przekierowywani do aplikacji.

### Role

Zanim przejdziemy do omawiania konkretnych przepływów musimy poznać cztery role wykorzystywane w tym standardzie:

*   **resource owner** - właściciel zasobu (użytkownik portalu GitHub)
*   **client** - byt, który chce dostać dostęp do zasobu (aplikacja)
*   **resource server** - serwer zasobów (nasza aplikacja lub GitHub)
*   **authorization server** - serwer autoryzacji, który zajmuje się tokenami (na przykład GitHub)

### Ustawienia aplikacji

Aby komunikować się z serwerem autoryzacji, musimy stworzyć aplikację kliencką ([jak to zrobić na GitHub'ie](https://developer.github.com/apps/building-oauth-apps/creating-an-oauth-app/)). Podczas tworzenia aplikacji, należy uwzględnić kilka danych:

*   **client id** - unikalny identyfikator (w przypadku GitHub'a losowy ciąg)
*   **client secret** - hasło aplikacji klienckiej (w przypadku GitHub'a losowy ciąg)
*   **scopes** - opcjonalna opcja, możemy określi do jakich zasobów przydzielamy dostęp (zależne od dostawy)
*   **redirect/callback URI** - na jaki adres mamy być przekierowani po logowaniu

### Przepływy

Dokumentacja standardu **OAuth2** definiuje cztery typy przepływów:

*   **Authorization Code** - używany jest kod autoryzacji, dzięki temu **client secret** nie jest wykorzystywany wprost
*   **Implicit** - brak gwarancji iż **client secret** nie wycieknie
*   **Resource Owner Password Credentials** \- login i hasło właściciela zasobu
*   **Client Credentials** \- wykorzystująca client id oraz client secret (nie powinniśmy stosować tego produkcyjne)

### Authorization Code

Najbardziej po Grant - użytkownik ![Abstract Protocol Flow](https://assets.digitalocean.com/articles/oauth/abstract_flow.png)