---
title: Python - specjalna zmienna __name__
tags:
  - python
id: '359'
categories:
  - - Python
  - - Testing
date: 2016-02-27 12:26:36
author: 'Krzysztof Chruściel'
---

Czy podczas importowania modułów **Python'owych** zastanawiałeś się w jakim celu wykorzystywane jest sprawdzenie:

if \_\_name\_\_ == '\_\_main\_\_':

Jeśli tak to zapraszam do krótkiego artykułu, w którym omówię tą specjalną zmienną.
<!-- more -->
Podczas uruchamiania skryptu **Python'owego** inicjalizowane są specjalne zmienne. Jedną z nich jest **\_\_name\_\_,** która przechowuje nazwę modułu. Nazwa modułu może się różnić od sposobu uruchomienia skryptu. W momencie uruchomienia bezpośrednio skryptu (nie z importu), moduł przyjmuje nazwę **\_\_main\_\_.** Można to sprawdzić w łatwy sposób:

print('First module name is {}'.format(\_\_name\_\_))
First module name is \_\_main\_\_

Teraz dodajmy sobie nowy pusty plik, w którym  zaimportujemy pierwszy moduł i wywołamy w nim tą samą funkcję:

import Training
print('Second module name is {}'.format(\_\_name\_\_))
First module name is Training
Second module name is \_\_main\_\_

Jak widzicie zmienna **\_\_name\_\_** pierwszego modułu przyjęła nazwę pliku (zawsze przyjmuje nazwę pliku bez ścieżki). Natomiast drugi moduł jako, iż był uruchamiany otrzymał nazwę **\_\_main\_\_.** Napiszmy kod, który jeszcze lepiej nam to zobrazuje. W pierwszym module napiszmy:

print('Ten tekst o najlepszym blogu CodeCouple.pl wyświetli się zawsze')

if \_\_name\_\_ == '\_\_main\_\_':
    print('Uruchamiamy bezpośrednio')
else:
    print('Uruchamiamy z importu')

Natomiast w drugim pliku:

import Training
print('Second module name is {}'.format(\_\_name\_\_))

W przypadku uruchomienia bezpośrednio modułu pierwszego otrzymamy wynik:

Ten tekst o najlepszym blogu CodeCouple.pl wyświetli się zawsze
Uruchamiamy bezpośrednio

Natomiast gdy uruchomimy drugi moduł, który importuje pierwszy moduł otrzymamy:

Ten tekst o najlepszym blogu CodeCouple.pl wyświetli się zawsze
Uruchamiamy z importu
Second module name is \_\_main\_\_

Sprawdzenie czy **\_\_name\_\_** jest równe **\_\_main\_\_** ma na celu sprawdzenie czy plik jest uruchamiany bezpośrednio, czy poprzez import. Do czego przyda nam się ta wiedza? Otóż najczęściej wykorzystywana jest do pisania/wywoływania **testów**. Ponieważ najczęściej importujemy jakieś moduł, wtedy takie sprawdzenie eliminuje nam odpalenie tych testów. Natomiast dla nas jako autorów jest to dobre miejsce, aby uruchomić testy.