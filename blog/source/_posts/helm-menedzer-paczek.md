---
title: Helm - menedżer paczek dla Kubernetesa
tags:
  - chart
  - helm
  - k8s
  - kubernetes
id: '3788'
categories:
  - - Cloud
date: 2019-04-12 12:01:59
author: 'Krzysztof Chruściel'
---

![](https://raw.githubusercontent.com/kchrusciel/code-couple-blog-assets/main/2019/03/helm.png)

Kolejnym narzędziem (po [minikube](https://codecouple.pl/2019/04/05/minikube-lokalny-klaster-kubernetes/)) ułatwiającym pracę z klastrem **Kubernetes** jest **Helm**. Jest to menedżer paczek, który ułatwia wgrywanie aplikacji na nasz klaster. Dostarcza on także możliwość parametryzowania zasobów wgrywanych na klaster, co pozwala na przygotowywanie różnych wersji naszych paczek.
<!-- more -->
### Helm

Jak pisałem we wstępie, **Helm** służy do zarządzania paczkami. Paczki te wgrywane są na klaster **Kubernetes**. Jest to możliwe dzięki części serwerowej nazywanej **Tillerem**. Wykorzystanie plików `yaml` pozwala na parametryzowanie zasobów wgrywanych na klaster:

![](https://raw.githubusercontent.com/kchrusciel/code-couple-blog-assets/main/2019/03/helm-1-1024x439.png)

### Instalacja

Aby zacząć pracę z narzędziem **Helm**, należy je zainstalować. Pod adresem [https://github.com/helm/helm/releases/latest](https://github.com/helm/helm/releases/latest) znajdziemy pliki binarne dostosowane do różnych systemów operacyjnych, w tym **Linux**, **macOS** oraz **Windows**. Ponadto **Helm** dostępny jest w wielu **package managerach**, takich jak [Homebrew](https://brew.sh/) (`brew install kubernetes-helm) czy [Chocolatey](https://chocolatey.org/) (`choco install kubernetes-helm)`. Po instalacji i wydaniu polecenia `helm version` powinniśmy otrzymać informację o aktualnej wersji **Helma**:

```shell
$ helm version
Client: &version.Version{SemVer:"v2.12.3", GitCommit:"eecf22f77df5f65c823aacd2dbd30ae6c65f186e", GitTreeState:"clean"}
Error: could not find tiller
```

Zaraz naprawimy błąd **Tillera**.

### Tiller

**Tiller** jest częścią serwerową rozwiązania **Helm**. Wykorzystywany jest do komunikacji klient-serwer. **Tiller** jest instalowany w systemowym namespace `kube-system`, dzięki czemu może wykonywać operacje na klastrze **Kubernetes**. Aby zainstalować część serwerową na klastrze i dodać ustawienia lokalne, należy uruchomić polecenie:

```shell
helm init
```

Teraz, po wydaniu polecenia `kubectl get po -n kube-system`, pojawił się nowy **pod** z **Tillerem**:

```shell
$ kubectl get po -n kube-system
tiller-deploy-fc56b78dd-kdlnc           1/1     Running   0          108s
```

Sprawdźmy teraz wersję **Helma**, aby mieć pewność, że **klient** i **serwer** działają poprawnie:

```shell
$ helm version
Client: &version.Version{SemVer:"v2.12.3", GitCommit:"eecf22f77df5f65c823aacd2dbd30ae6c65f186e", GitTreeState:"clean"}
Server: &version.Version{SemVer:"v2.12.3", GitCommit:"eecf22f77df5f65c823aacd2dbd30ae6c65f186e", GitTreeState:"clean"}
```

Jeśli dostaliśmy informacje o kliencie i serwerze, możemy przejść do zbudowania pierwszej paczki.

### Chart

Paczki budowane i obsługiwane przez narzędzie **Helm** nazywane są **Chartami**. Można je tworzyć ręcznie, ale **Helm** dostarcza nam polecenie, które buduje szablon **Charta**:

```shell
helm create chart-name
```

Po utworzeniu **Charta** pojawił się nowy folder o takiej samej nazwie jak **Chart**. Folder ten zawiera:

* `values.yaml` - zbiór wartości wstrzykiwanych do **Charta**

```yaml
replicaCount: 1

value: "Test"

image:
  repository: nginx
  tag: stable
  pullPolicy: IfNotPresent

nameOverride: ""
fullnameOverride: ""

service:
  type: ClusterIP
  port: 80
```

* `Chart.yaml` - plik zawierający opis **Charta**

<!-- end list -->

```yaml
apiVersion: v1
appVersion: "1.0"
description: My first chart
name: my-chart
version: 0.1.0
```

* `.helmignore` - lista plików/folderów ignorowanych podczas budowania paczki

```shell
my-file.txt
my-folder
```

* `templates` - folder z plikami `yaml` z opisami zasobów wgrywanych na **Kubernetes**
* `templates/NOTES.txt` - plik, który zawiera tekst wyświetlany po poprawnej instalacji **Charta**

### NOTES.txt

W pliku tym przechowywany jest tekst, który zostanie wyświetlony po poprawnej instalacji **Charta**. Najczęściej umieszcza się tam informacje, jak dostać się do naszej aplikacji oraz jakie ustawienia należy skonfigurować:

```yaml
{{ if eq .Values.value "Test" }}
 Value enabled
{{ else }}
 Value disabled
{{ end }}
```

### Repozytorium

Oprócz budowania własnych **Chartów**, Helm dostarcza repozytorium, na którym są już gotowe paczki. Aktualnie oficjalnym repozytorium **Helma** jest GitHub [https://github.com/helm/charts](https://github.com/helm/charts). Repozytorium to zawiera dwa ważne katalogi: `stable` oraz `incubator`. W folderze `stable` znajdziemy wszystkie stabilne wersje **Chartów**, natomiast w folderze `incubator` znajdują się **Charty** w fazie **inkubacji** (nie są jeszcze oficjalnie gotowe). Listę dostępnych **repozytoriów** otrzymamy, wydając polecenie:

```shell
helm repo list
```

### Helm Hub

Ludzie z firmy **Bitnami** przygotowali **Hub**, na którym możemy przeglądać dostępne **Helmowe Charty** [https://hub.kubeapps.com/]:

![](https://raw.githubusercontent.com/kchrusciel/code-couple-blog-assets/main/2019/03/helm-hub-1024x494.png)

Jeśli wybraliśmy lub przygotowaliśmy interesujący nas **Chart**, pora na jego instalację:

```shell
helm install stable/nginx # instalacja z repozytorium stable
helm install my-chart     # instalacja lokalnej paczki
```

### Lista Chartów

Po zainstalowaniu interesującego nas **Charta** powinien być on dostępny na liście:

```shell
$ helm list
NAME        REVISIONUPDATED                 STATUS  CHART     APP VERSIONNAMESPACE
tan-kangaroo1       Sun Mar 31 01:39:30 2019DEPLOYEDtest-0.1.01.0        default
```

### Usuwamy Chart

Aby usunąć cały **Chart** (który może zawierać wiele elementów), należy wydać polecenie:

```shell
$ helm delete tan-kangaroo
release "tan-kangaroo" deleted
```

### Więcej

W kolejnych wpisach postaramy się stworzyć gotowy **Chart**.