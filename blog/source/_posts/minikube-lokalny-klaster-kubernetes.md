---
title: Minikube - lokalny klaster Kubernetes
tags: []
id: '3764'
categories:
  - - Java
date: 2019-04-05 12:01:58
author: 'Krzysztof Chruściel'
---

 ![](https://raw.githubusercontent.com/kchrusciel/code-couple-blog-assets/main/2019/03/minikube-logo-1024x290.jpg)

Dosłownie kilka dni temu wydana została wersja **1.0.0** narzędzia **minikube**! Jest to **narzędzie**, które pozwala uruchomić klaster **Kubernetes** na naszej **lokalnej** maszynie. Sprawia to, iż nie **musimy** płacić dostawcy za **klaster** w przypadku testów wszystkich możliwości **Kubernetes'a**. Aby poznać to potężne narzędzie zapraszam do wpisu.
<!-- more -->
### Minikube

Jak pisałem we wstępie **minikube** jest narzędziem, które pozwala na uruchomienie klastra **Kubernetes** na naszej lokalnej maszynie. Wykorzystuje ono do tego **wirtualną maszynę** zarządzaną przez **hypervisor'a**:

![](https://raw.githubusercontent.com/kchrusciel/code-couple-blog-assets/main/2019/03/minikube-1024x433.png)

Ponadto **minikube** dostarcza takie funkcjonalności jak **dashboard**, **DNS** czy zarządzanie **Secret'ami**.

### Instalacja

Pod adresem [https://github.com/kubernetes/minikube/release](https://github.com/kubernetes/minikube/release) znajdziecie zbudowane binaria, które zawierają narzędzie **minikube**. Z listy należy wybrać jedynie interesujący nas system operacyjny. **Minikube** wspiera systemy **Linux**, **macOS** oraz **Windows**. W przypadku **macOS** polecam korzystanie z narzędzia `brew`.

### Hypervisor

Do poprawnego działania **minikube** potrzebujemy mieć zainstalowanego **hipernadzorcę**. **Minikube** wspiera wiele rozwiązań dostosowanych do systemów operacyjnych.

*   **hyperkit** polecany dla **macOS**
*   **KVM2** polecany dla **Linux**
*   **VirtualBox** polecany dla **Windows**

### Uruchamiamy

Po poprawnej instalacji narzędzia **minikube** pora na jego uruchomienie (polecenie to uruchamia wirtualną maszynę z jednowęzłowym klastrem **Kubernetes**):

minikube start

Jeśli po **uruchomieniu** powyższego polecenia pojawi nam się napis:

💗  kubectl is now configured to use "minikube"
🏄  Done! Thank you for using minikube!

to oznacza, iż możemy zacząć korzystać z naszego lokalnego klastra **Kubernetes** (narzędzie `kubectl` także zostało skonfigurowane pod **minikube**).

### Dashboard

**Minikube** oferuje wbudowany **dashboard**, na którym możemy podejrzeć nasz **klaster**. Służy do tego polecenie:

minikube dashboard

Po wpisaniu powyższego polecenia w naszej przeglądarce powinien pokazać się **dashboard**:

![](https://raw.githubusercontent.com/kchrusciel/code-couple-blog-assets/main/2019/03/Screen-Shot-2019-03-30-at-18.58.35-1024x611.png)

### SSH

Oprócz **dashboard'u** możemy także dostać się do naszej **wirtualnej maszyny** poprzez **SSH**:

minikube ssh

### Docker

Jeśli na klastrze **Kubernetes** chcemy uruchamiać **pody** z naszymi obrazami to możemy skorzystać z demona **Docker'a** wbudowanego w **minikube**. Aby to zrobić, w ramach sesji naszego **terminala** należy wydać polecenie:

eval $(minikube docker-env)

Od teraz korzystamy z **Docker'a**, który znajduje się na **minikube**. Warto oznaczać nasze obrazy innym **tagiem** niż `:latest`. Jeśli nie użyjemy **tagu**, domyślnie szukanym obrazem będzie obraz z tagiem `:latest`, a tym samym polityka pobierania obrazów najpierw będzie sprawdzała **Docker Registry** co może prowadzić do błędów.

### Konfiguracja

**Minikube** w momencie uruchamiania wirtualnej maszyny z **Kubernetes** wykorzystuje poniższe ustawienia **domyślne**:

*   `DefaultMemory` - domyślna ilość pamięci - **2GB**
*   `DefaultCPUS` - domyślna ilość procesorów - **2**
*   `DefaultDiskSize` - domyślny rozmiar dysku - **20GB**
*   `MinimumDiskSizeMB` - minimalny rozmiar dysku - **2GB**
*   `DefaultVMDriver` - domyślny hipernadzorca - **VirtualBox**

Wszystkie **ustawienia** mogą być zmienione podczas uruchamiania **minikube**:

minikube start --memory 8192

Wszystkie możliwe **ustawiania** dostępne są po wydaniu **komendy**:

minikube config -h

Ich lista to:

*   vm-driver
*   feature-gates
*   v
*   cpus
*   disk-size
*   host-only-cidr
*   memory
*   log\_dir
*   kubernetes-version
*   iso-url
*   WantUpdateNotification
*   ReminderWaitPeriodInHours
*   WantReportError
*   WantReportErrorPrompt
*   WantKubectlDownloadMsg
*   WantNoneDriverWarning
*   profile
*   bootstrapper
*   ShowBootstrapperDeprecationNotification
*   dashboard
*   addon-manager
*   default-storageclass
*   heapster
*   efk
*   ingress
*   registry
*   registry-creds
*   freshpod
*   default-storageclass
*   storage-provisioner
*   storage-provisioner-gluster
*   metrics-server
*   nvidia-driver-installer
*   nvidia-gpu-device-plugin
*   logviewer
*   gvisor
*   hyperv-virtual-switch
*   disable-driver-mounts
*   cache
*   embed-certs

Jeśli nie chcemy za każdym razem przekazywać tych **ustawień** do polecenia uruchamiającego **minikube** to możemy użyć polecenia `minikube config set`. Polecenie to ustawia wartość na stałe:

minikube config set memory 8196

Które na stałe zapisuje parametry **minikube** w pliku **konfiguracyjnym** (dla systemu **macOS** jest to ścieżka `~/.minikube/config/config.json`).

### Dodatki

**Minikube** przychodzi do nas z listą **dodatków**. Lista ta dostępna jest pod poleceniem:

minikube addons list

W wyniku tego polecenia otrzymujemy następujące **dodatki**:

*   addon-manager: enabled
*   dashboard: enabled
*   default-storageclass: enabled
*   efk: disabled
*   freshpod: disabled
*   gvisor: disabled
*   heapster: disabled
*   ingress: disabled
*   logviewer: disabled
*   metrics-server: disabled
*   nvidia-driver-installer: disabled
*   nvidia-gpu-device-plugin: disabled
*   registry: disabled
*   registry-creds: disabled
*   storage-provisioner: enabled
*   storage-provisioner-gluster: disabled

### Stopowanie

Polecenie `minikube stop` zatrzymuje klaster **Kubernetes.** Przy ponownym uruchomieniu **minikube** cały poprzedni stan jest **przywracany** (nie tracimy naszej pracy).

### Usuwanie

Polecenie `minikube delete` służy do **usuwania** klastra. Usuwa ono całą wirtualną maszynę z **minikube** oraz cały przechowywany na niej stan.