---
title: Kubernetes - Pod
tags: []
id: '3818'
categories:
  - - Java
---

![](https://codecouple.pl/wp-content/uploads/2019/04/k8s-1024x221.png)

asasas
<!-- more -->
### Aplikacja

W naszym przykładzie

### Pod

czy jest pod?

\[obrazek\]

### Yaml Manifest

Opis poda w pliku yaml

### Minikube

Po przygotowaniu pliku first-pod.yaml pora go uruchomić. Pody żyją w klastrze kubernetesowym więc trzeba go im dostarczyć. Jak opisywałem w jednym z poprzednich wpisów najlepszym wyborem do testowania jest Minikube. Uruchamiamy klaster Minikube:

minikube start

Skoro wiemy, że pody to tak naprawdę abstrakcja na kontenery to musimy w jakiś sposób dostarczyć obrazy dla tych kontenerów. Jeśli chcemy mieć dostęp do deamon'a Docker'owego z Minikube należy wydać polecenie:

eval $(minikube docker-env)

Zbudujmy teraz obraz naszej aplikacji

\[\]

Sprawdźmy czy znajduje się na liście

\[\]

### Efemeryczność i idempotentność

asas

### Więcej

asas

### Github

Całość jak zawsze na Github'ie.