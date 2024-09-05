---
title: '#4 Spring Boot 2 - Actuator - własny endpoint'
tags:
  - Actuator
  - spring boot
  - spring boot 2
id: '3857'
categories:
  - - Java
  - - Spring Boot
date: 2019-05-10 12:01:22
author: 'Krzysztof Chruściel'
---

![](https://codecouple.pl/wp-content/uploads/2017/12/springBoot2Art.png)

W poprzednim wpisie [#3 Spring Boot 2 – Actuator](https://codecouple.pl/2019/05/03/3-spring-boot-2-actuator/) poznaliśmy narzędzie **actuator**. Jest to **narzędzie**, które dostarcza **metryki** oraz dodatkowe **informacje** na temat aplikacji. _Out-of-the-box_ **actuator** daje nam między innymi możliwość sprawdzenia **metryk** wirtualnej maszyny **Javy** czy **statusu** naszej aplikacji. Jednakże, czasem potrzebujemy dodać **własny** adres dostarczający dodatkowe **informacje** o naszej aplikacji. W tym wpisie opowiemy sobie jak dodać **własny** endpoint.
<!-- more -->
### Spring Boot 2

**Spring Boot 2** zmodyfikował nieznacznie sposób dodawania nowych **endpointów**. W poprzedniej wersji należało zaimplementować odpowiedni **interfejs**. W najnowszej wersji do dodania **nowego** adresu wykorzystywana jest adnotacja `@Endpoint`:

@Component
@Endpoint(id = "integrations")
public class IntegrationsEndpoint {

   //logic

}

W parametrze `id` określamy pod jakim adresem dostępny będzie nowy **endpoint**. W naszym przypadku jest to adres `/actuator/integrations`. Dodatkowo każdy dodany przez nas **endpoint** jest domyślnie włączony, możemy to zmienić poprzez użycie klucza `enableByDefault` `@Endpoint(id = "integrations", enableByDefault = false)`.

### CRUD

Po **dodaniu** nowego adresu, pora na dodanie **funkcjonalności**. W **Spring Boot 2** oprócz **rejestracji** nowych adresów zmienił się też sposób obsługi operacji **CRUD**. **Spring Boot 2** dostarcza nam trzy nowe adnotacje:

*   `@ReadOperation` - **odczyt** wartości przy wykorzystaniu metody **GET**
*   `@WriteOperation` - **zapis** wartości przy wykorzystaniu metody **POST**
*   `@DeleteOperation` - **usunięcie** wartości przy wykorzystaniu metody **DELETE**

Spróbujmy zaimplementować **klasę**, która pozwala **dodawać**, **usuwać** oraz **odczytywać** wykorzystane **integracje** w naszej aplikacji:

@Component
@WebEndpoint(id = "integrations", enableByDefault = false)
public class IntegrationsEndpoint {

    private Map<String, Integration> integrations = new HashMap<>();

    @ReadOperation
    public Map<String, Integration> getIntegrations() {
        return integrations;
    }

    @ReadOperation
    public Integration getIntegration(@Selector String name) {
        return integrations.get(name);
    }

    @WriteOperation
    public void addIntegration(@Selector String name, Integration integration) {
        integrations.put(name, integration);
    }

    @DeleteOperation
    public void deleteIntegrationBy(@Selector String name) {
        integrations.remove(name);
    }

}

class Integration {

  private String integration;

  public String getIntegration() {
    return integration;
  }

  public void setIntegration(final String integration) {
    this.integration = integration;
  }
}

W powyższej klasie pojawiła się także adnotacja `@Selector`, która mapuje **klucz** przekazanej wartości.

### Extension

Czasami oprócz podstawowej funkcjonalności **endpointów**, chcielibyśmy mieć przykładowo wpływ na zwracane **nagłówki** lub kody **statusów**. Jest to możliwe dzięki adnotacji `@EndpointWebExtension(endpoint = IntegrationsEndpoint.class)`. Adnotacja pod kluczem `endpoint` przyjmuje nazwę klasy **adresu**, któremu chcemy dodać dodatkową **funkcjonalność**:

@Component
@EndpointWebExtension(endpoint = IntegrationsEndpoint.class)
public class IntegrationsEndpointExtension {

   private final IntegrationsEndpoint endpoint;

   public IntegrationsEndpointExtension(final IntegrationsEndpoint endpoint) {
      this.endpoint = endpoint;
   }

   @ReadOperation
   WebEndpointResponse<Map<String, Integration>> integrations() {
      final Map<String, Integration> integrations = endpoint.getIntegrations();
      if (integrations.containsKey("someValue")) {
         return new WebEndpointResponse<>(
              integrations, 
              HttpStatus.CONFLICT.value());
      }
      return new WebEndpointResponse<>(
              integrations, 
              HttpStatus.I\_AM\_A\_TEAPOT.value());
   }
}

### Github

Całość jak zawsze na [Github'ie](https://github.com/kchrusciel/Spring-Boot-2-Examples/tree/master/spring-boot-actuator-custom-example).