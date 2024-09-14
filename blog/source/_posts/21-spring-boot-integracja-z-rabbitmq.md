---
title: '#21 Spring Boot – integracja z RabbitMQ'
tags:
  - message broker
  - queue
  - rabbitmq
  - spring
  - spring boot
id: '2221'
categories:
  - - Docker
  - - Message Broker
  - - Spring Boot
date: 2017-11-03 12:05:54
author: 'Krzysztof Chruściel'
---

[![](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)

W tym wpisie przedstawię wam jak zintegrować bezpośrednio naszą aplikację z **RabbitMQ**. Stosowanie kolejek w naszym ekosystemie ma wiele zalet. Dzięki zrównolegleniu pracy możemy w łatwy sposób skalować naszą aplikację. Jednocześnie wysyłając zadania na kolejkę powodujemy, iż nasz system staje się bardziej odporny, ponieważ zadania w pierwszej kolejności trafiają na kolejkę i zostaną z niej pobrane dopiero wtedy, gdy dostępni będą konsumenci tych wiadomości.
<!-- more -->
### RabbitMQ

Nie bez przyczyny wcześniejsze wpisy nawiązywały do **[Dockera](http://codecouple.pl/2017/10/13/20-spring-boot-szybki-start-z-dockerem/)** oraz [**RabbitMQ**](http://codecouple.pl/2017/10/27/message-broker-rabbitmq/). Naszą integrację z **message brokerem** zaczniemy od pobrania oraz uruchomienia obrazu **Dockerowego** (wszystkie wyjaśnienia w tym [artykule](http://codecouple.pl/2017/10/27/message-broker-rabbitmq/)):

docker run -d --hostname code-couple --name queue -p 15672:15672 -p 5672:5672 rabbitmq:3.6-management-alpine

### Maven

Kolejnym krokiem jest dodanie zależności **Mavenowej**, która zapewni nam integrację z **RabbitMQ**:

<dependency>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-starter-amqp</artifactId>
</dependency>

### Producer

Producer jak nazwa wskazuje jest "producentem" wiadomości, które trafiają na kolejkę. Wysyłanie wiadomości do **RabbitMQ** odbywa się poprzez wykorzystanie `RabbitTemplate`

@RestController("/queue")
class QueueProducer {

    @Value("${queue.name}")
    private String queueName;

    @Autowired
    RabbitTemplate queueSender;

    @GetMapping
    String sendToQueue(@RequestParam(value = "message", defaultValue = "CodeCouple.pl") String message){
        queueSender.convertAndSend(queueName, message);
        return String.format("Message %s sent! See logs...", message);
    }

}

### Consumer

Aby odczytywać wiadomości z kolejki należy użyć adnotacji `@RabbitListener`, która jako parametr `queues` przyjmuje nazwę kolejek, z których chcemy odbierać wiadomości:

@Component
class QueueConsumer {

    @RabbitListener(queues = "${queue.name}")
    private void reader(String text){
        System.out.println("Consumer: " + text);
    }

}

### Testujemy!

Po uruchomieniu aplikacji w logach powinna pokazać się informacja o nawiązaniu połączenia z **RabbitMQ**:

2017-10-11 18:38:48.379 INFO 6392 --- \[cTaskExecutor-1\] o.s.a.r.c.CachingConnectionFactory : Created new connection: 
rabbitConnectionFactory#7d04a8ec:0/SimpleConnection@18f7f721 \[delegate=amqp://guest@192.168.99.100:5672/, localPort= 53396\]

Aby przetestować naszą aplikację wystarczy wejść pod adres aplikacji `/queue?message=CodeCouple`, a wiadomość wyląduje na kolejce o nazwie określonej w `queueName`. Odebrane wiadomości powinny być widoczne w logach.

### GitHub

Całość jak zawsze na [GitHubie](https://github.com/kchrusciel/Spring-Boot-Examples).