---
title: java.time.Clock - testowanie czasu
tags:
  - java
  - testing
id: '3284'
categories:
  - - Java
  - - Testing
date: 2018-11-02 12:12:28
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/05/testingLogo.png)

Proces testowania przez wielu z nas traktowany jest podobnie jak sztuka. Dobre testy powinny spełniać wiele czynników by mogły być nazwane "dobrymi". Jednym z nich jest brak zależność od czasu. Nasze testy powinny być tak szybkie jak to tylko możliwe oraz nie powinny zależeć od czynników zewnętrznych (mówimy o **testach jednostkowych**). Aby pozbyć się zależności czasowych **Java 8** dostarczyła nam nową klasę `java.time.Clock`.
<!-- more -->
### Zły przykład

Zaczniemy od klasy `ClassWhichDependOnTime`, która zależy od czasu (przepraszam za `Date` w **Javie 8**):

class ClassWhichDependsOnTime {

    boolean isGoingToExpireToday(ClassWithFixedTime classWithFixedTime) {
        long result = classWithFixedTime.getDate().getTime() - new Date().getTime();
        return result >= 0 && TimeUnit.MILLISECONDS.toDays(result) == 0;
    }

}

W wyniku metody `isGoingToExpireToday` dostaniemy informację czy dziś wygaśnie ważność klasy `ClassWithFixedTime`:

class ClassWithFixedTime {

    private final Date date;

    ClassWithFixedTime(Date date) {
        this.date = date;
    }

    Date getDate() {
        return date;
    }

}

Napiszmy test do tego kodu:

class ClassWhichDependsOnTimeTest {

    @Test
    void shouldReturnTrueWhenDateIsSameAsToday() {
        // Given
        Date date = DateUtils.addHours(new Date(), 2);
        ClassWithFixedTime fixedTime = new ClassWithFixedTime(date);
        ClassWhichDependsOnTime bad = new ClassWhichDependsOnTime();
        // When
        boolean goingToExpireToday = bad.isGoingToExpireToday(fixedTime);
        // Then
        assertThat(goingToExpireToday).isTrue();
    }

}

Jest godzina 10:00 i uruchamiamy nasz **test**. Wszystko przechodzi **poprawnie**. Koło godziny 23:00 nasz kolega z zespołu postanawia wrzucić coś do developa, odpalają się testy, a tutaj:

java.lang.AssertionError: 
Expecting:
 <true>
to be equal to:
 <false>
but was not.

  at ClassWhichDependsOnTimeTest.someTestWhichDependsOnTime(ClassWhichDependsOnTimeTest.java:23)

Niestety, nasze testy nie są dobrymi testami, ponieważ zależą od czasu. Odwróćmy zależność.

### Clock na ratunek

Rozwiązaniem tego problemu jest klasa `java.time.Clock`, która powinna być dostarczona jako zależność:

class GoodClassWhichDependsOnTime {

    private final Clock clock;

    GoodClassWhichDependsOnTime(Clock clock) {
        this.clock = clock;
    }

    boolean isGoingToExpireToday(ClassWithFixedTime classWithFixedTime) {
        long result = clock.millis() - classWithFixedTime.getDate().getTime();
        return result >= 0 && TimeUnit.MILLISECONDS.toDays(result) == 0;
    }

}

Teraz nasze testy będą wyglądać następująco:

class GoodClassWhichDependsOnTimeTest {

    @Test
    void shouldReturnTrueWhenDateIsSameAsToday() {
        // Given
        Date date = getExpirationDate(21);

        ClassWithFixedTime fixedTime = new ClassWithFixedTime(date);
        Clock clock = Mockito.mock(Clock.class);

        when(clock.millis()).thenReturn(getCurrentDateInMillis());

        GoodClassWhichDependsOnTime good = new GoodClassWhichDependsOnTime(clock);
        // When
        boolean goingToExpireToday = good.isGoingToExpireToday(fixedTime);
        // Then
        assertThat(goingToExpireToday).isTrue();
    }

    private Date getExpirationDate(int hour) {
        Calendar expirationDate = Calendar.getInstance();
        expirationDate.set(2018, Calendar.NOVEMBER, 1, hour, 30, 30);
        return expirationDate.getTime();
    }

    private long getCurrentDateInMillis() {
        Calendar expirationDate = Calendar.getInstance();
        expirationDate.set(2018, Calendar.NOVEMBER, 1, 22, 30, 30);
        return expirationDate.getTimeInMillis();
    }

}

Od teraz test ten jest zależny od przekazanych wartości w metodzie `when()`, a nie czynników zewnętrznych.

### Inne metody

Ponadto, klasa `Clock` dostarcza kilka przydatnych metod:

*   `Clock.systemDefaultZone()` - zwraca aktualną datę w systemowej strefie czasowej
*   `Clock.fixed()` - zwraca datę przekazaną jako parametr metody fixed
*   `clock.milis()` - zwraca datę w milisekundach
*   `clock.instant()` - zwraca datę jako `Instant`

### GitHub

Całość jak zawsze na [GitHubie](https://github.com/kchrusciel/CodeCouple/tree/master/ClockTest).