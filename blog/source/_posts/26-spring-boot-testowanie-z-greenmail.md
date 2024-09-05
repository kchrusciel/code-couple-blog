---
title: '#28 Spring Boot - Testowanie z GreenMail'
tags:
  - greenmail
  - spring boot
  - testing
id: '2374'
categories:
  - - Spring Boot
  - - Testing
date: 2018-02-09 12:11:43
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)

Podczas przygotowania mojej prezentacji na **SpreadIT**, obracałem się wokół domeny związanej z mejlami.  Ponieważ była to prezentacja o **TDD**, musiałem w jakiś sposób przetestować moją usługę do wysyłania mejli. Po wyszukaniu dostępnych rozwiązań postanowiłem wybrać bibliotekę [GreenMail](http://www.icegreen.com/greenmail/). Jest to prawdopodobnie jedyna biblioteka, która może być wykorzystywana jednocześnie do wysyłania jak i odbierania **emaili**.
<!-- more -->
### Maven

Tradycyjnie zaczynamy od dodatnia zależności:

<dependency>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-starter-mail</artifactId>
</dependency>
<dependency>
   <groupId>com.icegreen</groupId>
   <artifactId>greenmail-spring</artifactId>
   <version>1.5.6</version>
   <scope>test</scope>
</dependency>

Pierwsza z nich czyli `spring-boot-starter-mail` potrzebna jest nam do wysyłania mejli (więcej [można przeczytać w artykule Agnieszki](http://codecouple.pl/2016/09/30/8-spring-boot-email-szablon-i-wysylanie/)). `greenmail-spring` jest zależnością, która dostarcza nam bibliotekę **GreenMail** wymaganą do testowania.

### Serwis do wysyłania

Dodajmy teraz prosty serwis do wysyłania mejli. Korzysta on z `JavaMailSender`:

@Service
class EmailSender {

    private final JavaMailSender javaMailSender;

    EmailSender(JavaMailSender javaMailSender) {
        this.javaMailSender = javaMailSender;
    }

    void sendEmail(String to, String from, String title, String content) {
        SimpleMailMessage mail = new SimpleMailMessage();
        mail.setTo(to);
        mail.setFrom(from);
        mail.setSubject(title);
        mail.setText(content);
        javaMailSender.send(mail);
    }
}

Jeśli teraz spróbujemy uruchomić naszą aplikację dostaniemy błąd związany z brakiem możliwości utworzenia beana `JavaMailSender`. Aby utworzyć bean `JavaMailSender` musimy dodać kilka zależności. Na czas testów wystarczy stworzyć profil do testowania mejli. Nowy profil tworzymy poprzez dodanie pliku `application-email.properties`, w który ustawiamy:

spring.mail.host=localhost
spring.mail.port=25

### Testy

Możemy teraz dodać testy, które wykorzystują bibliotekę **GreenMail**. Server możemy ustawić na kilka sposobów, w tym przykładzie wykorzystałem `GreenMailRule`, natomiast jako ustawienia serwera: port `25`, host jako `localhost` oraz protokół `smtp`. Aby odczytać wiadomości wystarczy wywołać metodę `getReceivedMessages`:

@SpringBootTest
@ActiveProfiles("email")
@RunWith(SpringRunner.class)
public class EmailSenderTest {

    @Rule
    public GreenMailRule server = new GreenMailRule(new ServerSetup(25, "localhost", "smtp"));

    @Autowired
    EmailSender emailSender;

    @Test
    public void shouldSendEmail() throws Exception {
        // Given
        String to = "test@codecouple.pl";
        String from = "blog@codecouple.pl";
        String title = "Title";
        String content = "Content";
        // When
        emailSender.sendEmail(to, from, title, content);
        // Then
        MimeMessage\[\] receivedMessages = server.getReceivedMessages();
        assertThat(receivedMessages.length).isEqualTo(1);

        MimeMessage receivedMessage = receivedMessages\[0\];
        assertThat(receivedMessage.getAllRecipients()\[0\].toString()).isEqualTo(to); //to
        assertThat(receivedMessage.getFrom()\[0\].toString()).isEqualTo(from); //from
        assertThat(receivedMessage.getSubject()).isEqualTo(title); //title
        assertThat(receivedMessage.getContent().toString()).contains(content); //content
        //Or
        assertThat(content).isEqualTo(GreenMailUtil.getBody(server.getReceivedMessages()\[0\]));
    }

}

Oczywiście nie są to "najpiękniejsze" testy. Można by to opakować w jakiś ładny sposób, lub rozdzielić na kilka testów, jednakże chciałem pokazać wam jak w łatwy sposób można testować wysyłanie mejli.

### GitHub

Całość jak zawsze na [GitHubie](https://github.com/kchrusciel/Spring-Boot-Examples/tree/master/spring-boot-green-mail-example).