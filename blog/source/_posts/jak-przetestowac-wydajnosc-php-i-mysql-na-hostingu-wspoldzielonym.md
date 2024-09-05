---
title: Jak przetestować wydajność PHP i MySQL na hostingu współdzielonym?
tags:
  - hosting
  - mysql
  - php
  - testing
  - wordpress
id: '4427'
categories:
  - - Testing
date: 2021-05-30 13:18:37
author: 'Krzysztof Chruściel'
---

Test wydajności PHP i MySQL na hostingu to bardzo dobry pomysł. Dzięki niemu możesz określić, jaka jest prędkość i przepustowość serwera w zakresie przetwarzania zapytań do baz danych - a tym samym, jak poradzi sobie z aplikacją czy stroną internetową. Zobacz, jak szybko przeprowadzić taki test.
<!-- more -->
To wpis gościnny, którego autorem jest [Mateusz Mazurek](https://mateuszmazurek.pl). Mateusz w ramach projektu Jak Wybrać Hosting tworzy [ranking najlepszych hostingów](https://jakwybrachosting.pl/), w ramach którego sprawdza, testuje i recenzuje usługi hostingowe oraz publikuje poradniki z zakresu wyboru i użytkowania hostingu.

Decydując się na hosting współdzielony musisz się liczyć z rozmaitymi limitami - takimi jak ograniczenia jednoczesnych procesów PHP czy połączeń HTTP. W przypadku tych kwestii - możesz po prostu sprawdzić zastosowane ograniczenia w ofercie i na tej podstawie oszacować, w jaki sposób mogą one wpłynąć to na prędkość Twojej strony internetowej.

Jednak niektóre parametry w ogóle nie są prezentowane w ofertach - mimo tego, że mają bardzo duży wpływ na funkcjonowanie strony internetowej na danym serwerze. W takiej sytuacji trzeba je samodzielnie przetestować. Jedną z takich kwestii wartych przetestowania jest wydajność PHP i MySQL.

### PHP i MySQL - a wydajność serwera

Dynamiczne strony internetowe wykorzystują zarówno PHP, jak i MySQL. Język PHP wysyła zapytanie do bazy danych, a zwrócone dane są następnie wyświetlana jako treść strony. Jeżeli te dwa elementy okażą się tzw. “wąskim gardłem” hostingu, może to mieć wpływ na szybkość wyświetlania się strony (lub uruchomienia danej aplikacji internetowej). W końcu - jeżeli czas potrzebny na przetworzenie zapytania będzie się wydłużać, to wyświetlenie witryny także potrwa dłużej.

Gdy mowa o testowaniu strony internetowej, od razu nasuwają się rozwiązania takie jak Google PageSpeed Insights. Owszem - testowanie strony internetowej z wykorzystaniem tego narzędzia daje pewien ogląd na temat wydajności witryny. Co najważniejsze - ocenia ją pod kątem Core Web Vitals, czyli kluczowych wskaźników, mających wpływ na ocenę jakości strony przez wyszukiwarkę.

**Jednak sam raport PageSpeed Insights niewiele m****ó****wi na temat samego serwera**. Dzięki testowi dowiesz się, czy Twoja strona ma poprawny HTML, CSS, czy obrazki nie są zbyt duże oraz czy poszczególne skrypty nie blokują się wzajemnie. Owszem - to bardzo ważne dla działania strony, jednak nie dowiesz się stąd niczego na temat wydajności PHP i MySQL na hostingu. Żeby przetestować hosting pod kątem tych dwóch aspektów, potrzebne będzie Ci bardziej specjalistyczne narzędzie.

### Benchmark PHP - przydatne, uniwersalne narzędzie

Dzięki bezpłatnemu skryptowi Benchmark PHP możesz przeprowadzić szybki test wydajności PHP i MySQL na serwerze. **Wystarczy go pobrać i zainstalować na serwerze, a następnie uruchomić, aby otrzymać precyzyjne wyniki dotyczące tego, ile czasu potrzeba na przetworzenie operacji.**

Na szybkość PHP wpływ ma zastosowana wersja języka. Jeżeli masz możliwość wyboru - skorzystaj z jak najnowszej wersji. Pamiętaj o tym, że im nowsza generacja PHP - tym większa wydajność.

Żeby przeprowadzić test, wystarczy kilka prostych kroków.

1.  Pobierz [plik testowy](https://github.com/vanilla-php/benchmark-php/archive/master.zip)
2.  Otwórz plik _php_ w edytorze tekstowym i w sekcji _Setup_ uzupełnij dane dostępowe do bazy danych MySQL, którą chcesz testować. Nie zapomnij, że aby skrypt był aktywny, musisz usunąć znaczniki “/\*” i “\*/” na początku i końcu sekcji.
3.  Umieść plik benchmark.php na serwerze.
4.  Wpisz adres domeny i lokalizację pliku na serwerze w przeglądarce, np.: twojadomena.pl/test/benchmark.php

Po uruchomieniu programu, otrzymasz wyniki w poniższej formie.

\[caption id="attachment\_4428" align="aligncenter" width="459"\]![](https://codecouple.pl/wp-content/uploads/2021/05/Picture-1-459x1024.jpg) Wyniki przedstawiane po uruchomieniu skryptu Benchmark PHP.\[/caption\]

Sekcja _Benchmark_ odnosi się do wydajności interpretera PHP. Przedstawia ona m.in. szybkość wykonywania operacji matematycznych przez serwer, a także iteracji pętli i przetwarzania zapytań warunkowych. Natomiast _MySQL_ \- odnosi się do szybkości bazy danych, gdzie badany jest m.in. czas reakcji bazy na przesłane zapytanie. **Im ni****ższe wyniki - tym wyższa wydajność serwera (szybsze przetwarzanie zapytań).**

Test warto przeprowadzić o różnych porach dnia. Pamiętaj, że na hostingu współdzielonym, dostępność niektórych zasobów może zmieniać się na przestrzeni czasu.

### Testy na WordPressie

**Do przeprowadzenia testu hostingu współdzielonego możesz także wykorzystać** **WordPressa**. Oczywiście nie mówię tutaj o testowaniu samej szybkości strony internetowej - chodzi o wykorzystanie wtyczki do sprawdzenia wydajności PHP i MySQL.

Żeby to zrobić:

1.  Pobierz wtyczkę [WPPerformanceTester](https://wordpress.org/plugins/wpperformancetester/).
2.  Zainstaluj ją i aktywuj na swojej stronie opartej na WordPress.
3.  Uruchom wtyczkę (_Narzędzia_ -> _WP Performance Tester_).
4.  Kliknij w Begin _Performance Test_

Wtyczka wykonuje szereg testów, dotyczących np. szybkości wykonywania funkcji matematycznych. Wykonuje m.in. 1 000 000 iteracji pętli oraz testuje 1 000 000 instrukcji warunkowych. Testowane są także podstawowe funkcje MySQL (połączenie, zapytanie, wersję oraz kodowanie).

Po przeprowadzonym benchmarku otrzymasz wyniki w następującej formie:

![](https://codecouple.pl/wp-content/uploads/2021/05/Picture-2.jpg)

Jak widzisz - raport pokazuje informacje dotyczące zarówno PHP jak i MySQL. Jak je czytać? Sekcja _Server Performance Benchmarks_ odnosi się do wydajności baz danych. **Im ni****ższy wynik w sekcji Total - tym lepiej radzi sobie serwer z przetwarzaniem zapytań**.

Z kolei sekcja _WordPress Performance Benchmarks_ odnosi się do wydajności PHP **w kontekście silnika WordPressa**. W sekcji _Execution Time_ wynik powinien być niższy niż 1 sekunda (im mniej, tym lepiej). Natomiast w _Queries Per Second_ \- im wyższy wynik, tym większa jest liczba zapytań obsługiwanych w ciągu sekundy. Jeżeli wartość ta przekracza 1000 - bardzo dobrze świadczy to o wydajności hostingu.

### Wnioski

Wiesz już, w jaki sposób możesz przetestować wydajność PHP i MySQL, jednak tak naprawdę… co Ci daje taka wiedza? Oczywiście wiadomo, że im szybciej i więcej, tym lepiej, ale czy w ogóle warto zaprzątać sobie głowy tymi tematami?

Oczywiście, że tak. **Jeżeli zależy Ci na dobrych wynikach strony w wyszukiwarkach, ale także na maksymalizowaniu użyteczności Twojej witryny - warto zatroszczyć się o każdy parametr, kt****ó****ry pozwoli na jej szybsze załadowanie - choćby o kilkanaście milisekund.**

Przeprowadzenie testów PHP i MySQL to naprawdę dobry pomysł, jeżeli masz możliwość skorzystania z okresu testowego na hostingu. Żeby wyciągnąć wnioski z powyższych testów, najlepiej porównywać wyniki z prób przeprowadzanych na różnych serwerach. W ten sposób jesteś w stanie wskazać, który z nich zapewnia lepsze osiągi.

Gdy już zobaczysz, który z hostingów oferuje najwyższą wydajność - skonfrontuj to z jego innymi parametrami, takimi jak m.in. rodzaj dysku twardego, limity czy kwestie związane z bezpieczeństwem. Dzięki temu **uda Ci si****ę wybrać serwer, kt****ó****ry pozwoli płynnie działać Twojej stronie internetowej - a przynajmniej jej w tym nie przeszkodzi**.