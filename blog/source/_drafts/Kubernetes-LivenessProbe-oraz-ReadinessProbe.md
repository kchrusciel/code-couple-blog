---
title: Kubernetes - LivenessProbe oraz ReadinessProbe
tags:
  - cloud
  - kubernetes
  - spring boot 2
id: '3827'
categories:
  - - Cloud
  - - Java
  - - Spring
  - - Spring Boot
---

![](https://codecouple.pl/wp-content/uploads/2019/04/k8s-1024x221.png)

**Proces** uruchomienia naszej aplikacji może być procesem bardzo **złożonym**. Zaczynając od tego, iż **uruchomienie** aplikacji może zająć trochę czasu a kończąc na **nazwiązywaniu** połączenia z innymi serwisami. **Pod** w momencie **uruchomienia** jest od razu **dostępny** dla całego klastra **kubernetes**. Jednakże, czy to oznacza, że jesteśmy **gotowi** aby przyjąć cały ruch? Jak sprawić aby kubernetes kierował ruch dopiero wtedy gdy będziemy **gotowi**? Po odpowiedzi na te pytania zapraszam do **wpisu**!
<!-- more -->
### Aplikacja

Ponowanie wykorzystamy prostą aplikację napisaną w **Spring Boot 2** (tutaj znajdziecie wymagane informacje link), która będzie dostarczać jeden **endpoint**. Dodatkowo dorzucimy wsparcie dla projektu **actuator**:

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>

Na początku dodamy nowy endpoint `/actuator/readiness` dla projektu **actuator** (więcej jak dodać własny endpoint):

@Component
@WebEndpoint(id = "readiness")
public class ReadinessEndpoint {

    @ReadOperation
    public Map<String, String> getReadiness() {
        return Collections.singletonMap("status", "ready");
    }

}

Następnie dodamy dodatkową logikę dla endpointu `/actuator/readiness`. Logika ta będzie symulować długo trwającą operację (na przykład oczekiwanie na inny serwis lub bazę danych):

@Component
@EndpointWebExtension(endpoint = ReadinessEndpoint.class)
public class ReadinessEndpointExtension {

    private final ReadinessEndpoint endpoint;
    private volatile boolean isReady;

    public ReadinessEndpointExtension(final ReadinessEndpoint endpoint) {
        this.endpoint = endpoint;
        longActionSimulator();
    }

    private void longActionSimulator() {
        CompletableFuture.delayedExecutor(30, TimeUnit.SECONDS, Executors.newSingleThreadExecutor())
                .execute(() -> isReady = true);
    }

    @ReadOperation
    WebEndpointResponse<Map<String, String>> integrations() {
        final Map<String, String> readiness = endpoint.getReadiness();
        if (isReady) {
            return new WebEndpointResponse<>(
                    readiness,
                    HttpStatus.OK.value());
        }
        return new WebEndpointResponse<>(
                Collections.singletonMap("status", "notReady"),
                HttpStatus.I\_AM\_A\_TEAPOT.value());
    }
}

Po trzydziestu sekundach nasz endpoint `/actuator/readiness` zwróci status `200` z wiadomością:

{
  "status":"ready"
}

Wcześniej będziemy otrzymać kod `418` czyli [I'm a teapot](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/418) z odpowiednim statusem. Tutaj ważne jest to aby zwrócić kod statusu różny od przedziału między `200` a `399` dla operacji nie powodzenia:

{
  "status":"notReady"
}

### Docker

Todo

### Minikube

todo

### LivenessProbe

W momencie uruchomienia **pod'a** jest on już **dostępny** dla całego klastra **kubernetes**. Jednakże bardzo często aplikcja znajdująca się wewnątrza **pod'a** nie uruchamiają się **automatycznie**, potrzebują trochę czasu (czas na uruchomienie się aplikacji typu **Spring Boot 2**). Aby **odroczyć** proces dostępność naszego **pod'a** możemy do tego wykorzystać **LivenessProbe.** **LivenessProbe** sprawdza czy nasz **pod** już "żyje", to znaczy czy nasza aplikacja wewnątrz **pod'a** się uruchomiła:

apiVersion: v1
kind: Pod
metadata:
  name: liveness
spec:
  containers:
  - name: liveness
    image: readiness-app:0.0.1
    livenessProbe:
      httpGet:
        path: /actuator/health
        port: 8080
      initialDelaySeconds: 3
      periodSeconds: 3

Gdzie:

*   `httpGet` - wykorzystujemy metodę **GET** aby pobrać wartość
*   `path` - ścieżka endpointu
*   `port` - port pod którym dostępny jest endpoint
*   `periodSeconds` - w jakim interewale czasowym powinno odbywać się sprawdzanie
*   `initialDelaySeconds` - po jakim czasie **kubernetes** powinien sprawdzać "żywotność" **pod'a**

**LivenessProbe** może wykonywać sprawdzania typu:

*   **command** - wywołanie komendy
*   **HTTP GET** - wywołanie żądania GET
*   **TCP Socket** - wykorzystanie gniazda typu Socket

W naszym przypadku **LivenessProbe** będzie sprawdzać informację z adresu `/actuator/health`, który zwraca status **UP**, jeśli aplikacja wstała. Wrzućmy naszego **pod'a** na kluster:

kubectl apply -f liveness-pod.yaml

Oraz sprawdźmy jego **status**:

Ready:          True
Restart Count:  0
Liveness:       http-get http://:8080/actuator/health delay=3s timeout=1s period=3s #success=1 #failure=3

Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True

Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  16s   default-scheduler  Successfully assigned 
  Normal  Pulled     16s   kubelet, minikube  Container image "readiness-app:0.0.1"
  Normal  Created    16s   kubelet, minikube  Created container liveness
  Normal  Started    16s   kubelet, minikube  Started container liveness

Jak widzimy, nasz pod jest gotowy do pracy, dopiero wtedy gdy **LivenessProbe** czyli nasz adres /actuator/health zwrócił status 200. Jednakże, to dalej nie rozwiązuje nam problemu symulacji długiego połączenia. Do tego celu wykorzystamy **ReadinessProbe**.

### ReadinessProbe

Bardzo często zdarza się tak, iż mimo uruchomienia naszej aplikacji nie jest jeszcze ona gotowana do pracy. W tle mogą nawiązywać się połączenia do bazy danych lub nasza aplikacja czeka na sygnał od innej. Aby nasz pod był dostępny dopiero gdy będzie gotowy możemy do tego celu wykorzystać **ReadinessProbe**:

apiVersion: v1
kind: Pod
metadata:
  name: readiness
spec:
  containers:
  - name: readiness
    image: readiness-app:0.0.1
    livenessProbe:
      httpGet:
        path: /actuator/health
        port: 8080
      initialDelaySeconds: 3
      periodSeconds: 3
    readinessProbe:
      httpGet:
        path: /actuator/readiness
        port: 8080
      initialDelaySeconds: 15
      periodSeconds: 20

Gdzie:

*   `httpGet` - wykorzystujemy metodę **GET** aby pobrać wartość
*   `path` - ścieżka endpointu
*   `port` - port pod którym dostępny jest endpoint
*   `periodSeconds` - w jakim interewale czasowym powinno odbywać się sprawdzanie
*   `initialDelaySeconds` - po jakim czasie **kubernetes** powinien sprawdzać gotowość **pod'a**

Podobnie jak **LivenessProbe**, **ReadinessProbe** może wykonywać próby typu:

*   **command** - wywołanie komendy
*   **HTTP GET** - wywołanie żądania GET
*   **TCP Socket** - wykorzystanie gniazda typu Socket

W naszym przypadku **ReadinessProbe** będzie sprawdzać informację z adresu `/actuator/ready`, który zwraca status **UP**, jeśli aplikacja będzie gotowa. Wrzućmy naszego **pod'a** na kluster:

kubectl apply -f readiness-pod.yaml

Oraz sprawdźmy jego **status**:

kubectl describe pod readiness

Image:          readiness-app:0.0.1
Ready:          True
Restart Count:  0
Liveness:       http-get http://:8080/actuator/health delay=3s timeout=1s period=3s #success=1 #failure=3
Readiness:      http-get http://:8080/actuator/readiness delay=15s timeout=1s period=20s #success=1 #failure=3

Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True

Events:
  Type     Reason     Age   From               Message
  ----     ------     ----  ----               -------
  Normal   Scheduled  75s   default-scheduler  Successfully assigned 
  Normal   Pulled     74s   kubelet, minikube  Container image
  Normal   Created    74s   kubelet, minikube  Created container readiness
  Normal   Started    74s   kubelet, minikube  Started container readiness
  Warning  Unhealthy  46s   kubelet, minikube  Readiness probe failed: HTTP probe failed with statuscode: 418

Jak widzimy, nasz **pod** na początku nie był gotowy do pracy _Readiness probe failed_. Natomiast przy **następnej** próbie sprawdzenia gotowości otrzymaliśmy już status `200` więc pole `Ready` otrzymało wartość `True`.

### Więcej

Więcej informacji na temat **próbkowania** można znaleźć w oficjalnej **dokumentacji** [https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.14/#probe-v1-core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.14/#probe-v1-core).

### Github

Całość jak zawsze na Github'ie