---
title: Message Broker - RabbitMQ
tags:
  - message broker
  - queue
  - rabbitmq
id: '2240'
categories:
  - - Message Broker
date: 2017-10-27 12:01:26
author: 'Krzysztof Chruściel'
---

![](http://codecouple.pl/wp-content/uploads/2017/10/rabbitmq.png)

**RabbitMQ** jest otwartoźródłowym **message brokerem**. Może być on wykorzystany do tworzenia **microserwisów**, które realizowane są w architekturze **message-driven**. Serwer brokera napisany jest w **Erlangu**, natomiast API dla klientów dostępne jest w wielu językach programowania w tym **Javie**. W tym wpisie przedstawię wam podstawy **RabbitMQ**.
<!-- more -->
Naszą przygodę z message brokerem zaczniemy od pobrania oraz uruchomienia obrazu **Dockerowego** ([więcej o Dockerze](http://codecouple.pl/2016/03/14/docker-pierwsze-kroki/)):

docker run -d --hostname code-couple --name queue -p 15672:15672 -p 5672:5672 rabbitmq:3.6-management-alpine

gdzie:

*   `-d` uruchamiamy w trybie **detached,** czyli usługa działająca w tle
*   `--hostname` wymagana nazwa jeśli chcemy, aby nasze dane składowane były w jednym miejscu
*   `--name` nazwa naszej instancji
*   `-p` przekierowanie portu administracyjnego **15672** na **15672** na naszej maszynie oraz portu RabbitMQ **5672** na **5672**
*   `rabbitmq:3.6-management-alpine` - wersja 3.6 wraz z panelem zarządzania na zoptymalizowanym **Linuxie Alpine**

Teraz po uruchomieniu przeglądarki na porcie **15672** powinien ukazać się nam panel logowania, dane domyślne to `guest`/`guest` (można je zmienić przekazując zmienne środowiskowe `RABBITMQ_DEFAULT_USER` oraz `RABBITMQ_DEFAULT_PASS`).

![](http://codecouple.pl/wp-content/uploads/2017/10/rabbitMQLoginPanel.png)

Zanim pójdziemy dalej ważne jest kilka pojęć związanych z **RabbitMQ**:

*   **Message** - wysłana wiadomość
*   **Exchange** - określane jako centrala wiadomości, tutaj trafiają wszystkie wiadomości, działa jak "load balancer" na podstawie określonych reguł
*   **Binding** - reguły powiązań pomiędzy kolejką a centralą wiadomości
*   **Queue** - zwykła kolejka **FIFO**
*   **Routing key** - klucz określający, do której kolejki ma zostać wysłana wiadomość
*   **Producer** \- twórca danych wysyłanych na kolejkę
*   **Consumer** - odbiorca danych z kolejki

Flow przepływu informacji wygląda tak: producer -> message -> exchange -> binding -> queue -> consumer

### Typy Exchange

**Exchange** może działać w kilku trybach, które decydują o tym jak przekazywane mają być wiadomości:

*   **Direct** - wiadomości przekazywane są bezpośrednio do kolejki na podstawie routing key
*   **Fanout** - wiadomości wysyłane są do wszystkich kolejek
*   **Topic** - typ podobny do typu direct z tą różnica, że wiadomości przekazywane są do kolejki na podstawie routing key o **określonym z góry formacie** (słowa oddzielone kropkami)
*   **Headers** - typ podobny do typu direct z tą różnicą, że wiadomości przekazywane są do kolejki na podstawie nagłówków

### Tworzenie kolejek

Aby utworzyć **kolejkę** poprzez panel administracyjny należy wybrać zakładkę **Queues**. Następnie musimy wybrać nazwę naszej kolejki oraz kilka opcji dla niej. Po utworzeniu będzie ona widoczna pod zakładką **All queues**. Aby uniknąć utraty wiadomości lub kolejek w przypadku awarii serwera **RabbitMQ**, należy ustawić parametr **Durability** na **Durable**.

![](http://codecouple.pl/wp-content/uploads/2017/10/panelCreateQueue.png)

### Tworzenie exchange

Aby utworzyć **exchange** poprzez panel administracyjny należy wybrać zakładkę **Exchanges**. Następnie musimy wybrać nazwę naszego **exchange** oraz kilka opcji dla niego. Po utworzeniu będzie on widoczny pod zakładką **All exchanges**. Typ **exchange** należy wybrać zgodnie z przeznaczenie (opis wyżej).

![](http://codecouple.pl/wp-content/uploads/2017/10/panelCreateExchange.png)

### Tworzenie binding

Jeśli chcemy korzystać z kolejki nie w sposób bezpośredni tylko przy użyciu **exchange** musimy dodać **binding**. Aby dodać **binding** poprzez panel administracyjny należy wybrać zakładkę **Exchanges,** a następnie wybrać interesujący nas **exchange**. W zakładce **Bindings** wybieramy, która kolejka ma być połączona z wybranym **exchange**. Możemy także ustawić **routing key**.

![](http://codecouple.pl/wp-content/uploads/2017/10/panelCreateBinding.png)

### Test działania

Aby przetestować działanie naszej kolejki, należy wybrać zakładkę **Exchanges,** a następnie wybrać interesujący nas **exchange**. W zakładce **Publish message** ustawiamy payload, czyli treść naszej wiadomości i klikamy **Publish message**. Po wybraniu naszej kolejki powinna pokazać się nowa wiadomość. ![](http://codecouple.pl/wp-content/uploads/2017/10/panelQueueOverview.png)

### Więcej

W kolejnych wpisach pokażę jak zintegrować **RabbitMQ** z aplikacją **Spring Boot'ową**.