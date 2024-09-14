---
title: Python - gettery i settery - @property
tags:
  - encapsulation
  - python
id: '417'
categories:
  - - Python
date: 2016-03-04 15:02:15
author: 'Krzysztof Chruściel'
---

**Gettry** i **settery** nazywane też **akcesorami**/**mutatorami,** wykorzystywane są odpowiednio do pobierania i ustawiania wartości atrybutu obiektu. Zapewniają one **enkapsulacje** danych. W **Pythonie** istnieje kilka przykładów, które na pierwszy rzut oka nie są trywialne. Przyjrzyjmy się im dokładniej.
<!-- more -->
Na początku zaprojektujmy sobie prostą klasę:

class CodeCouple(object):


    def \_\_init\_\_(self, name):
        self.\_\_name = name

    def get\_name(self):
        return self.\_\_name

    def set\_name(self, name):
        self.\_\_name = name

Utworzyliśmy klasę **CodeCouple,** która ma jedno prywatne pole name. Dodaliśmy **gettery** i **settery** jako zwykłe metody. Przyjrzyjmy się ich wywołaniu:

agnieszka = CodeCouple('Agnieszka')
krzysztof = CodeCouple('Empty')
print(agnieszka.get\_name())

krzysztof.set\_name('Krzysztof')
print(krzysztof.get\_name())

code\_couple = CodeCouple('Fill')
code\_couple.set\_name(krzysztof.get\_name() + ' ' + agnieszka.get\_name())
print(code\_couple.get\_name())

Agnieszka
Krzysztof
Krzysztof Agnieszka

Jak widzicie wywołanie "code\_couple.set\_name(krzysztof.get\_name() + ' ' + agnieszka.get\_name())" nie jest zbyt ładne, nie jest w stylu **Pythonic**. Ponieważ nie zmieniamy logiki pobierania i ustawiania pola, nie trzeba tworzyć **getterów** i **setterów**, a wystarczy jedynie zadeklarować pole name jako publiczne:

class CodeCouple(object):


    def \_\_init\_\_(self, name):
        self.name = name

agnieszka = CodeCouple('Agnieszka')
krzysztof = CodeCouple('Empty')
print(agnieszka.name)

krzysztof.name = 'Krzysztof'
print(krzysztof.name)

code\_couple = CodeCouple('Fill')
code\_couple.name = krzysztof.name + ' ' + agnieszka.name
print(code\_couple.name)

Agnieszka
Krzysztof
Krzysztof Agnieszka

Otrzymaliśmy taki sam wynik, jednakże utraciliśmy **enkapsulacje** (w tym przypadku jej nie potrzebowaliśmy). W późniejszym czasie okazuje się jednak, że chcemy dodać logikę ustawiania, więc chcemy zapewnić także **enkapsulacje**. Kolejny przykład: zakładamy, że jeśli imię to "Agnieszka" - ustawiamy "beautiful", jeśli "Krzysztof" - "ugly", a w przypadku braku "Agnieszka" oraz "Krzysztof" ustawiamy pole na "CodeCouple":

    def \_\_init\_\_(self, name):
        self.set\_name(name)

    def get\_name(self):
        return self.\_\_name

    def set\_name(self, name):
        if name == 'Agnieszka':
            self.\_\_name = 'beautiful'
        elif name == 'Krzysztof':
            self.\_\_name = 'ugly'
        else:
            self.\_\_name = 'CodeCouple'

agnieszka = CodeCouple('Agnieszka')
print(agnieszka.get\_name())

krzysztof = CodeCouple('Krzysztof')
print(krzysztof.get\_name())

code\_couple = CodeCouple('UglyKrzysztof')
print(code\_couple.get\_name())

Jak widać wszystko działa poprawnie, jednakże ludzie korzystają najczęściej z wywołania zaprezentowanego wcześniej czyli:

 krzysztof.name = 'Krzysztof'

Jak zapewnić **enkapsulacje** z jednoczesnym wywołaniem w stylu zmienna.pole = 'wartość'? Odpowiedzieć to dekoratory **properties,** czyli mechanizm wbudowany w **Pythona**. Przepiszemy wcześniejszy przykład, aby pokazać zastosowanie dekoratora **@property**:

class CodeCouple(object):


    def \_\_init\_\_(self, name):
        self.name = name

    @property
    def name(self):
        return self.\_\_name

    @name.setter
    def name(self, name):
        if name == 'Agnieszka':
            self.\_\_name = 'beautiful'
        elif name == 'Krzysztof':
            self.\_\_name = 'ugly'
        else:
            self.\_\_name = 'CodeCouple'

agnieszka = CodeCouple('Agnieszka')
print(agnieszka.name)

krzysztof = CodeCouple('Krzysztof')
print(krzysztof.name)

code\_couple = CodeCouple('UglyKrzysztof')
print(code\_couple.name)

beautiful
ugly
CodeCouple

Jak widzicie wynik jest ten sam, ale zachowana jest enkapsulacja oraz wywołanie w pożądanym stylu. Aby osiągnąć ten efekty należy użyć dekoratora **@property,** który identyfikuje metodę jako getter. Aby dodać setter należy użyć **@name.setter**, gdzie name musi być takie samo jak nazwa pola. Dekorator **@property** ma poważną wadę: niepowiązane ze sobą klasy nie mają możliwości współdzielenia tej samej implementacji. Aby rozwiązać ten problem powstały deskryptory, ale o tym innym razem!