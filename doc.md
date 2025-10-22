# Outils
Ce projet utilise 4 outils :
- Snort
- Syslog-ng
- Elasticsearch
- Kibana

# Architecture
Le projet utilise un docker compose pour lancer tous les outils : le fichier [docker-compose.yml](docker-compose.yml) contient les informations de configuration de chaque outil :
- Lien de l'image docker que l'on récupère et utilise
- Variables d'environnement pour configurer le comportement du conteneur
- Ports exposés de la machine physique et du conteneur docker
- Répertoires auxquels le conteneur peut accéder
- Mémoire autorisée
- etc...

Ainsi, la commande "sudo docker compose up -d" lance tous les conteneurs avec la bonne configuration pour communiquer entre eux dans le cadre de notre projet.

