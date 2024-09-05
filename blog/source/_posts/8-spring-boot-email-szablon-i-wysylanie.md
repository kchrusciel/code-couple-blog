---
title: '#8 Spring Boot – email - szablon i wysyłanie'
tags:
  - mail
  - spring
  - spring boot
  - thymeleaf
id: '922'
categories:
  - - Java
  - - Spring Boot
date: 2016-09-30 11:03:41
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)

Podczas tworzenia modułu rejestracji w mojej aplikacji postanowiłam stworzyć proces potwierdzania tej czynności mailem. Przykład przedstawię w oparciu o `spring-boot-starter-mail` oraz `spring-boot-starter-thymeleaf` do tworzenia template'ow.
<!-- more -->
Zacznijmy od dodania zależności do naszego `pom.xml`. `Spring-boot-starter-mail` będzie potrzebny do samego wysyłania maili, a `spring-boot-starter-thymeleaf` do tworzenia szablonów **HTML** w wysyłanych w mailach.

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-thymeleaf</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-mail</artifactId>
</dependency>

Teraz przejdźmy do `application.properties`. Musimy ustawić hosta oraz port jak poniżej. Nazwa i hasło do maila **Outlook'owego** potrzebne są, abyśmy mogli korzystać z serwera `SMTP`. `SMTP.AUTH` pozwala na autentykację użytkownika korzystając z polecenia `AUTH`. Ostatnie dwie właściwości dotyczą `TLS`, dzięki czemu ustanawiamy szyfrowanie `TLS` w połączeniu sieciowym. Zapewnia nam to poufność danych.

spring.mail.host=smtp-mail.outlook.com
spring.mail.port=587
spring.mail.username=<TUTAJ MAIL>
spring.mail.password=<TUTAJ HASLO>
spring.mail.properties.mail.smtp.auth=true;
spring.mail.properties.mail.smtp.starttls.enable=true
spring.mail.properties.mail.smtp.starttls.required=true

Jeśli chcemy korzystać z konta **Gmail** zmienia nam się host i oczywiście mail z hasłem.

spring.mail.host=smtp.gmail.com

Skoro mamy wszystkie potrzebne nam ustawienia przejdźmy do aplikacji. Zacznijmy od stworzenia interfejsu z metodą `sendEmail()`. Jako parametry będziemy przyjmować adres, na który chcemy wysłać maila, tytuł maila oraz jego treść.

package pl.codecouple.mail;

public interface EmailSender {
    void sendEmail(String to, String subject, String content);
}

Teraz kolej na implementację tej metody. Klasę oznaczmy jako `@Service` i wstrzyknijmy jej interfejs `JavaMailSender`. Następnie tworzymy obiekt typu `MimeMessage` poprzez metodę `javaMailSender.createMimeMessage()`. Przypisujemy do `MimeMessageHelper` wszystkie potrzebne właściwości. W przykładzie uwzględniłam tylko kilka najważniejszych tj. mail odbiorcy oraz nadawcy, tytuł oraz treść wiadomości. Jeśli chcemy wysłać czysty tekst wystarczy, że użyjemy metody `helper.setText(content)`. Jeśli jednak chcemy wysłać ładny szablon html musimy dodać drugi parametr typu Boolean - `helper.setText(content, true)`. Na koniec wysyłamy maila metodą `javaMailSender.send(mail)`.

package pl.codecouple.mail;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;


@Service
public class EmailSenderImpl implements EmailSender{

    @Autowired
    private JavaMailSender javaMailSender;

    @Override
    public void sendEmail(String to, String title, String content) {
        MimeMessage mail = javaMailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(mail, true);
            helper.setTo(to);
            helper.setReplyTo("newsletter@codecouple.pl");
            helper.setFrom("newsletter@codecouple.pl");
            helper.setSubject(title);
            helper.setText(content, true);

        } catch (MessagingException e) {
            e.printStackTrace();
        }

        javaMailSender.send(mail);
    }
}

Mamy już zaimplementowane wysyłanie maili, pozostało utworzyć szablon **HTML** i podpiąć go w kodzie. Poniżej przedstawiam prosty przykład `template.html`(oczywiście można to zrobić lepiej, przykład "na szybko" na potrzeby tego wpisu. Plik umieszczamy w folderze `resources/templates`):

<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <title th:remove="all">CodeCouple Newsletter</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

    <style type="text/css">
   h1 {font-size: 26px; color: #444444 !important; font-family: "Lucida Grande", "Lucida Sans", "Lucida Sans Unicode", sans-serif; line-height: 1.5;}
   h3 {font-size: 12px; color: #444444 !important; font-family: "Lucida Grande", "Lucida Sans", "Lucida Sans Unicode", sans-serif;}
   p {font-size: 16px; color: #ffffff; font-family: "Lucida Grande", "Lucida Sans", "Lucida Sans Unicode", sans-serif; line-height: 1.5;}
    table { border: 1px solid #e4e4e4;}
    a {color: #062b67; text-decoration: none; font-weight: bold;}
    </style>
</head>
<body>
<table width="100%" cellpadding="0" cellspacing="0" bgcolor="0095cc">
    <tr>
        <td height="50" align="center"><p th:text="${header}">header</p></td>
    </tr>
    <tr bgcolor="ffffff">
        <td height="100" align="center"><h1 th:text="${title}">title</h1></td>
    </tr>
    <tr bgcolor="ffffff">
        <td height="100" align="center"><h3 th:text="${description}">description</h3></td>
    </tr>
    <tr>
        <td height="50" align="center"><p>Przeczytaj cały artykuł na <a href="http://codecouple.pl/2016/09/13/7-spring-boot-logowanie-aplikacji-logback/">CodeCouple.pl</a></p></td>
    </tr>
 </table>
</body>
</html>

Ostatni krok to kontroler, który będzie nam uruchamiał wysyłanie maili. Wstrzykujemy w nim nasz interfejs `EmailSender` oraz klasę `TemplateEngine` z **Thymeleaf'a**. W obiekcie `Context` ustawiamy zmienne, które będą wrzucane do naszego szablonu **HTML** w miejsca `<p th:text="${header}">, <h1 th:text="${title}">` oraz `<h3 th:text="${description}">`. W metodzie `templateEngine.process("template", context)` podajemy nazwę szablonu oraz nasze zmienne.

@Controller
public class EmailController {

    private final EmailSender emailSender;
    private final TemplateEngine templateEngine;

    @Autowired
    public EmailController(EmailSender emailSender,
                           TemplateEngine templateEngine){
        this.emailSender = emailSender;
        this.templateEngine = templateEngine;
    }

    @RequestMapping("/")
    public String send() {
        Context context = new Context();
        context.setVariable("header", "Nowy artykuł na CodeCouple");
        context.setVariable("title", "#8 Spring Boot – email - szablon i wysyłanie");
        context.setVariable("description", "Tutaj jakis opis...");

        String body = templateEngine.process("template", context);
        emailSender.sendEmail("your.email.here@gmail.com", "CodeCouple Newsletter", body);
        return "index";
    }
}

Po uruchomieniu programu na wskazany przez nas adres otrzymujemy następującego maila.

![SpringBoot mail](http://codecouple.pl/wp-content/uploads/2016/09/aaa.png)