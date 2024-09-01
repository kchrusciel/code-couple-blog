---
title: '#Kata – The bowling game'
tags:
  - kata
  - the bowling game
id: '2066'
categories:
  - - Java
  - - Kata
date: 2017-09-01 12:05:44
---

[![](http://codecouple.pl/wp-content/uploads/2017/08/katas.png)](http://codecouple.pl/wp-content/uploads/2017/08/katas.png)

**The bowling game** jest kolejną propozycją ćwiczenia, która zostało mocno spopularyzowana przez **Wujka Boba**. Związana jest ona z grą w kręgle. W tym ćwiczeniu bardzo ciekawym elementem jest system naliczania punktów. W bardzo dobry sposób sprawdza tok algorytmicznego myślenia.
<!-- more -->
Jak napisałem we wstępie, ćwiczenie to dotyczy **gry w kręgle** (ang. bowling game). Od klienta dostajemy kilka wymagań:

*   Jeśli wszystkie twoje rzuty (ang. roll/throw) były chybione to wynik końcowy wynosi **zero**
*   W każdym rzucie został strącony tylko jeden kręgiel (ang. pin). Wynik końcowy wynosi **20**.
*   W pierwszej turze (ang. frame) został trafiony **spare**, następnie zostały strącone trzy kręgle. Wynik końcowy wynosi **16**.
*   W pierwszej turze został trafiony **strike**, następnie zostały strącone trzy i cztery kręgle. Reszta rzutów była chybiona. Wynik końcowy wynosi **24**.
*   Wszystkie rzuty to **strikes.** Wynik końcowy wynosi **300**.

Podczas gry w kręgle obowiązują pewne zasady:

*   Jest dziesięć tur
*   Jest dziesięć kręgli
*   W każdej turze możemy wykonać dwa rzuty
*   Jeśli w jednej turze w wyników dwóch rzutów osiągniemy wynik 10 to do tej tury zostanie doliczony wynik kolejnego rzutu - **spare**
*   Jeśli w jednej turze w jednym rzucie osiągniemy wynik 10 to do tej tury zostanie doliczony wynik kolejnych dwóch rzutów - **strike**

Moja propozycja **Javowa**:

public class BowlingGameTest {

    BowlingGame game = new BowlingGame();

    //Should return zero as a score when all rolls are missed

    @Test
    public void shouldReturnZeroWhenAllRollsAreMissed() throws Exception {
        // When
        IntStream.range(0,20).forEach(roll->game.roll(0));
        int score = game.getScore();
        // Then
        assertThat(score).isEqualTo(0);
    }

    //Should return 20 as a score when you knock down one pin per roll

    @Test
    public void shouldReturnTwentyWhenKnockDownOnePinPerRoll() throws Exception {
        // When
        IntStream.range(0,20).forEach(roll->game.roll(1));
        int score = game.getScore();
        // Then
        assertThat(score).isEqualTo(20);

    }

    //Should return 16 as a score when you knock down spare in first frame followed by three

    @Test
    public void shouldReturnSixTeenWhenSpareIsKnockDown() throws Exception {
        // When
        game.roll(5);
        game.roll(5);
        game.roll(3);
        IntStream.range(0,17).forEach(roll->game.roll(0));
        int score = game.getScore();
        // Then
        assertThat(score).isEqualTo(16);
    }

    //Should return 24 as a score when you knock down strike in first frame followed by three and four

    @Test
    public void shouldReturnTwentyFourWhenStrikeIsKnockDown() throws Exception {
        // When
        game.roll(10);
        game.roll(3);
        game.roll(4);
        IntStream.range(0,17).forEach(roll->game.roll(0));
        int score = game.getScore();
        // Then
        assertThat(score).isEqualTo(24);
    }

    //Should return 300 as a score when you knock down all strikes

    @Test
    public void shouldReturnThreeHundredsWhenAllStrikesAreKnockDown() throws Exception {
        // When
        IntStream.range(0,20).forEach(roll->game.roll(10));
        int score = game.getScore();
        // Then
        assertThat(score).isEqualTo(300);
    }

    private class BowlingGame {

        int\[\] rolls = new int\[21\];
        int roll = 0;

        int index = 0;

        int getScore() {
            int score = 0;
            for(int frame = 0; frame<10; frame++){
                if(isStrike()) { 
                    score += 10 + rolls\[index+1\] + rolls\[index+2\];
                    index++;
                }
                else if(isSpare()){ 
                    score += 10 + rolls\[index+2\];
                    index+=2;
                } else{
                    score+=rolls\[index\] + rolls\[index+1\];
                    index+=2;
                }
            }
            return score;
        }

        private boolean isSpare() {
            return rolls\[index\] + rolls\[index+1\] == 10;
        }

        private boolean isStrike() {
            return rolls\[index\] == 10;
        }

        void roll(int pins) {
            rolls\[roll++\] = pins;
        }
    }

Kod jak zawsze w całości na [GitHubie](https://github.com/kchrusciel/Katas).