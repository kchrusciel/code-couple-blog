---
title: Helm - menedżer paczek
tags:
  - chart
  - helm
  - k8s
  - kubernetes
id: '3788'
categories:
  - - Cloud
date: 2019-04-12 12:01:59
---

![](https://codecouple.pl/wp-content/uploads/2019/03/helm.png)

Kolejnym narzędziem (po [minikube](https://codecouple.pl/2019/04/05/minikube-lokalny-klaster-kubernetes/)) ułatwiającym pracę z klastrem **Kubernetes** jest **Helm**. Jest to menedżer paczek, który ułatwia wgrywanie aplikacji na nasz klaster. Dostarcza on także możliwość parametryzowania zasobów wgrywanych na **klaster**. Dzięki temu możemy przygotowywać różne wersje naszych paczek.
<!-- more -->
### Helm

Jak pisałem we wstępnie **Helm** służy do zarządzania paczkami. Paczki te wgrywane są na klaster **Kubernetes**. Możliwe jest to dzięki części serwerowej nazywanej **Tiller'em**. Wykorzystanie plików `yaml` pozwala parametryzować zasoby wgrywane na klaster:

![](https://codecouple.pl/wp-content/uploads/2019/03/helm-1-1024x439.png)

### Instalacja

Aby zacząć z narzędziem **Helm** należy je zainstalować. Pod adresem [https://github.com/helm/helm/releases/latest](https://github.com/helm/helm/releases/latest) znajdziemy binarnia dostosowane do różnych systemów operacyjnych. Wspierane systemy operacyjne to **Linux**, **macOS** oraz **Windows**. Ponadto **Helm** dostępny jest w wielu **package manager'ach** takich jak [Homebrew](https://brew.sh/) (`brew install kubernetes-helm)` czy [Chocolatey](https://chocolatey.org/) (`choco install kubernetes-helm)`. Po instalacji i wydaniu polecenia `helm version` powinniśmy otrzymać informację o aktualnej wersji **Helm'a**:

$ helm version
Client: &version.Version{SemVer:"v2.12.3", GitCommit:"eecf22f77df5f65c823aacd2dbd30ae6c65f186e", GitTreeState:"clean"}
Error: could not find tiller

Zaraz naprawimy błąd **Tiller'a**.

### Tiller

**Tiller** jest częścią serwerową rozwiązania **Helm**. Wykorzystywany jest on do komunikacji klient - serwer. **Tiller** instalowany jest w systemowy namespace `kube-system`, dzięki temu potrafi wykonywać operacje na klastrze **Kubernetes**. Aby zainstalować część serwerową na klastrze i dodać ustawienia lokalne należy uruchomić polecenie:

helm init

Teraz po wydaniu polecenia `kubectl get po -n kube-system` pojawił się nowy **pod** z **Tiller'em**:

$ kubectl get po -n kube-system
tiller-deploy-fc56b78dd-kdlnc           1/1     Running   0          108s

Sprawdźmy teraz wersje **Helm'a**, aby mieć pewność, że **klient** i **serwer** działają poprawnie:

$ helm version
Client: &version.Version{SemVer:"v2.12.3", GitCommit:"eecf22f77df5f65c823aacd2dbd30ae6c65f186e", GitTreeState:"clean"}
Server: &version.Version{SemVer:"v2.12.3", GitCommit:"eecf22f77df5f65c823aacd2dbd30ae6c65f186e", GitTreeState:"clean"}

Jeśli dostaliśmy informacje o kliencie i serwerze to możemy przejść do zbudowania pierwszej paczki.

### Chart

Paczki budowane i obsługiwane poprzez narzędzie **Helm** nazywane są **Chart'ami**. Można je tworzyć ręcznie, natomiast **Helm** dostarcza nam polecenie, które buduje szablon **Chart'a**:

 helm create chart-name

Po utworzeniu **Chart'a** pojawił się nowy folder o takiej samej nazwie jak **Chart**. Folder ten zawiera w sobie:

*   `values.yaml` - zbiór wartości wstrzykiwanych do **Chart'a**

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

*   `Chart.yaml` - zawiera opis **Chart'a**

apiVersion: v1
appVersion: "1.0"
description: My first chart
name: my-chart
version: 0.1.0

*   `.helmignore` - lista plików/folderów ignorowanych podczas budowania paczki

my-file.txt
my-folder

*   `templates` - folder z plikami `yaml` z opisami zasobów wgrywanych na **Kubernetes**
*   `templates/NOTES.txt` - plik, który zawiera tekst wyświetlany po poprawnej instalacji **Chart'a**

### NOTES.txt

W pliku tym przechowywany jest tekst, który zostanie wyświetlony po poprawnej instalacji **Chart'a**. Najczęściej umieszcza się tam informacje jak dostać się do naszej aplikacji oraz jakie ustawienia należy skonfigurować:

1. Check if value is enabled:
```
{{ if eq .Values.value "Test" }}
 Value enabled
{{ else }}
 Value disabled
{{ end }}
```


### Repozytorium

Oprócz budowania własnych **Chart'ów** Helm dostarcza repozytorium, na którym są już gotowe paczki. Aktualnie oficjalnym repozytorium **Helm'a** jest GitHub [https://github.com/helm/charts](https://github.com/helm/charts). Repozytorium to zawiera dwa ważne katalogi, `stable` oraz `incubator`. W folderze `stable` znajdziemy wszystkie stabilne wersje **Chart'ów** natomiast w folderze `incubator` znajdują się **Chart'y** w fazie **inkubacji** (nie są jeszcze oficjalnie gotowe). Listę dostępnych **repozytoriów** otrzymamy wydając polecenie:

helm repo list

### Helm Hub

Ludzie z firmy **Bitnami** przygotowali **Hub**, na którym możemy przeglądać dostępne **Helm'owe Chart'y** [https://hub.kubeapps.com/](https://hub.kubeapps.com/):

![](https://codecouple.pl/wp-content/uploads/2019/03/helm-hub-1024x494.png)

### Wrzucamy Chart

Jeśli wybraliśmy lub przygotowaliśmy interesujący nasz **Chart** pora na jego instalację:

helm install stable/nginx #instalacja z repozytorium stable
helm install my-chart     #instalacja lokalnej paczki

### Lista Chart'ów

Po zainstalowaniu interesującego nas **Chart'a** powinien być on dostępny na liście:

$ helm list
NAME        REVISIONUPDATED                 STATUS  CHART     APP VERSIONNAMESPACE
tan-kangaroo1       Sun Mar 31 01:39:30 2019DEPLOYEDtest-0.1.01.0        default

### Usuwamy Chart

Aby usunąć cały **Chart** (który może zawierać wiele elementów) należy wydać polecenie:

$ helm delete tan-kangaroo
release "tan-kangaroo" deleted

### Więcej

W kolejnych wpisach postaramy się stworzyć gotowy **Chart**.