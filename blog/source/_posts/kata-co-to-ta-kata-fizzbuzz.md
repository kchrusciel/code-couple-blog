---
title: '#Kata - co to ta Kata? - FizzBuzz'
tags:
  - fizzbuzz
  - kata
id: '2063'
categories:
  - - Java
  - - Kata
  - - Testing
date: 2017-08-18 12:05:25
author: 'Krzysztof Chruściel'
---

[![](http://codecouple.pl/wp-content/uploads/2017/08/katas.png)](http://codecouple.pl/wp-content/uploads/2017/08/katas.png)

Godzina 5.00, za oknami ciemno, pora na codzienne ćwiczenia. Zgodnie z definicją: "Kata - wysoce sformalizowany rodzaj ćwiczeń stosowanych w wielu tradycyjnych sztukach i sportach walki...", "Są to sekwencje technik ataku i obrony, połączone z określonym poruszaniem, przyjęciem ściśle określonej pozycji i sposobu oddychania. Niektóre techniki w kata mają charakter wyłącznie symboliczny."
<!-- more -->
**Kata** w kontekście **IT** to codzienne krótkie ćwiczenia (najlepiej do 30 minut), w których wykonujemy powtarzalne czynności. W ciągu tych ćwiczeń rozwiązujemy dowolne zadanie jak na przykład opisane poniżej **FizzBuzz**. Podczas treningu używamy skrótów, składni języka, gita czy specyficznych **frameworków**. Takie codzienne powtarzanie czynności pozwala nam być zawsze w "formie". **Kata** są także dobrym rozwiązaniem do nauki nowej technologii. Cykliczne powtarzanie utrwala w naszej głowie mechanizmy specyficzne dla danej technologii.

**FizzBuzz** jest szybkim ćwiczeniem często stosowanym na rozmowach kwalifikacyjnych, aby sprawdzić jak kandydat porusza się w IDE oraz jakie stosuje podejście przy programowaniu. Ćwiczenie to jest także często wykonywane w połączeniu z **TDD**.

*   Wypisz wszystkie liczby od 1 do 100
*   Jeśli liczba jest podzielna przez trzy wypisz "**Fizz**"
*   Jeśli liczba jest podzielna przez pięć wypisz "**Buzz**"
*   Jeśli liczba jest podzielna przez trzy i pięć wypisz "**FizzBuzz**"

Moja proponowana implementacja w **Javie**:

public class FizzBuzzTest {

    private FizzBuzz fizzBuzz = new FizzBuzz();

    //Should return 'Fizz' when number is divisible by three

    @Test
    public void shouldReturnFizzWhenNumberIsDivisibleByThree() throws Exception {
        // When
        String result = fizzBuzz.check(3);
        // Then
        assertThat(result).contains("Fizz");
    }


    //Should return 'Buzz' when number is divisible by five

    @Test
    public void shouldReturnBuzzWhenNumberIsDivisibleByFive() throws Exception {
        // When
        String result = fizzBuzz.check(5);
        // Then
        assertThat(result).contains("Buzz");
    }


    //Should return 'FizzBuzz' when number is divisible by five

    @Test
    public void shouldReturnFizzBuzzWhenNumberIsDivisibleByFiveAndThree() throws Exception {
        // When
        String result = fizzBuzz.check(15);
        // Then
        assertThat(result).contains("FizzBuzz");
    }

    //Should return number when number is not divisible by five and three

    @Test
    public void shouldReturnNumberWhenNumberIsNotDivisibleByFiveAndThree() throws Exception {
        // When
        String result = fizzBuzz.check(1);
        // Then
        assertThat(result).contains("1");
    }


    private class FizzBuzz {

        static final String FIZZ = "Fizz";
        static final String BUZZ = "Buzz";

        String check(int number) {
            String result = "";
            if(isDividedByThree(number)){
                result+= FIZZ;
            }
            if(isDividedByFive(number)){
                result+= BUZZ;
            }
            return result.isEmpty() ? String.valueOf(number) : result;
        }

        private boolean isDividedByFive(int number) {
            return number%5==0;
        }

        private boolean isDividedByThree(int number) {
            return number%3==0;
        }
    }

}

Moja proponowana implementacja w **Spocku**:

class FizzBuzzSpec extends Specification {

    @Shared
    def fizzBuzz = new FizzBuzz()

    def "Should return 'Fizz' when number is divisible by three" (){
        when:
            def result = fizzBuzz.check(3)
        then:
            result == "Fizz"
    }

    def "Should return 'Buzz' when number is divisible by five" (){
        when:
            def result = fizzBuzz.check(5)
        then:
            result == "Buzz"
    }

    def "Should return 'FizzBuzz' when number is divisible by five and three" (){
        when:
            def result = fizzBuzz.check(15)
        then:
            result == "FizzBuzz"
    }

    @Unroll
    def "Should return #excpectedValue when number is divisible by #number" (){
        when:
            def result = fizzBuzz.check(number)
        then:
            result == excpectedValue
        where:
            number  excpectedValue
            1       "1"
            3       "Fizz"
            5       "Buzz"
            15      "FizzBuzz"
    }

    class FizzBuzz{

        String check(int number) {
            def result = ""
            if(isDividedByThree(number)){
                result+= "Fizz"
            }
            if(isDividedByFive(number)){
                result+="Buzz"
            }
            return result.isEmpty() ? String.valueOf(number) : result
        }

        private boolean isDividedByFive(int number) {
            number % 5 == 0
        }

        private boolean isDividedByThree(int number) {
            number % 3 == 0
        }
    }

}

Całość jak zawsze na [GitHubie](https://github.com/kchrusciel/Katas).