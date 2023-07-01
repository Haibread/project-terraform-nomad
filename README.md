# Projet de déploiement de Hashicorp Nomad et d'une stack Grafana avec Terraform

## Introduction et cadre du projet

Ce projet rentre dans le cadre du "Projet Annuel" au sein de l'ESGI pendant le M2 Systèmes, Réseaux et Cloud Computing.

Le groupe de ce projet est composé de :

- Mathis
- Jérémie
- Théo

Dans le cadre de ce projet nous avons fait le choix de déployer Nomad avec de la supervision sur le Cloud publique de chez Scaleway

Une documentation présentant Nomad est disponible ici : <https://developer.hashicorp.com/nomad/intro>

Ce projet permet ainsi, grâce à la simple exécution de Terraform, de déployer :

- 3 instances avec Hashicorp Nomad + Grafana Agent
- Un "job" Nomad
- Une instance de monitoring avec Grafana et Prometheus

## Prérequis

### Terraform

Il est nécessaire d'avoir une installation de Terraform fonctionnelle afin de pouvoir utiliser ce projet.

La documentation d'installation est disponible ici : <https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli>

### Scaleway

Un compte scaleway est nécesaire pour déployer l'infrastructure, ce qui engendre aussi une facturation à l'heure.

Des informations de connexion à Scaleway sont requise afin que Terraform puisse fonctionner.
La documentation à ce sujet est disponible ici : <https://www.scaleway.com/en/docs/identity-and-access-management/iam/how-to/create-api-keys/>

Nous vous conseillons de récupérer ces identifiants et de les insérer dans un fichier `credentials.sh`, ou `credentials.ps1` selon si vous êtes sur Linux, ou sur Windows.
Pour linux, vous pouvez y insérer :

```bash
#!/bin/bash
export SCW_ACCESS_KEY="ABCDEFG"
export SCW_SECRET_KEY="SuperSecretKey!?"
```

Les valeurs doivent évidemment être modifiées en fonction de vos identifiants.

## Déploiement de l'architecture

Le déploiement de toute l'architecture se fait grâce à Terraform.

Avant de lancer Terraform, assurez vous que les variables d'environnement SCW_ACCESS_KEY et SCW_SECRET_KEY soient correctement indiquées.
Vous pouvez, par exemple, taper la commande `source credentials.sh` pour déclarer les variables d'environnement depuis le fichier créé précedemment.

On peut ensuite utilise terraform :

```bash
terraform init -upgrade
terraform apply
```

Lors de l'exécution `terraform apply`, il vous faudra écrire `yes` lorsque demandé afin de lancer de déploiement.

Arrivé à la fin de l'exécution de Terraform, vous aurez en sortie les adresses vers :

- Le dashboard de Hashicorp Nomad
- Grafana
- Les hôtes de Nomad

Une vidéo du déploiement est disponible ici : <>

## Exploration des applicatifs

### Prometheus et Grafana

L'adresse vers Grafana vous sera affiché à la fin du déploiement de l'infrastructure.

Pour se connecter à Grafana les indentifiants initiaux sont `admin:admin`

La connexion à Prometheus sera déjà configurée, et un dashboard pour Nomad sera déjà disponible.

Si vous souhaitez accéder à Prometheus, il suffira de se rendre vers la même adresse IP que Grafana, mais en utilisant le port 9090.
Par exemple `http://123.122.102.203:3000/` deviendra `http://123.122.102.203:9090/`

### Hashicorp Nomad

L'adresse vers l'interface Nomad vous sera affiché à la fin du déploiement de l'infrastructure.

Cette interface vous permettra de visualiser l'état actuel de Nomad.

### Application de test déployée (2048)

Une application de test est déployé par défaut avec Terraform.

Elle est accessible sur le port 80 de chacun des hôtes. Vous pouvez donc ouvrir votre navigateur, et vous diriger vers `http://<nomad-server>/` où `<nomad-server>` est l'adresse IP d'un des serveurs Nomad

## Pistes d'amélioration

### Améliorer le déploiement

Le déploiement actuel permet de déployer Nomad, mais c'est actuellement réalisé grâce à des adresse IP publiques, et le déploiement n'est actuellement pas adapté à une utilisation en production.

Il faudrait envisager de déployer Nomad sans y donner un accès en direct depuis l'extérieur.

Pour ce qui est de Prometheus et Grafana, il faudrait aussi envisager de sécuriser l'accès rajoutant des accès sécurisés, et en utilisant un certificat pour passer de `http` vers `https`.
