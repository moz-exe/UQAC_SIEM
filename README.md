# UQAC_SI_SIEM
Système de détection d'anomalies et de gestion de logs pour la sécurité des réseaux

## Déscription du projet :
Ce projet fait partie du cours de sécurité informatique de l'UQAC. Il consiste à assembler différents outils existants afin de créer un système de détection d'anomalies et de gestion de logs pour identifier les menaces potentielles et améliorer la sécurité des réseaux.

Nous avons implémenté 5 cas d'intrusion différents pour démontrer le bon fonctionnement de notre outil.

## Instructions d'installation :
1. Installation de toutes les dépendances docker : Exécuter le fichier install_docker.sh
2. Lancement des conteneurs docker des différents outils : Exécuter le fichier docker-compose.yml avec la commande "docker run docker-compose.yml"

## Instructions d'utilisation :

## Outils utilisés :
- Snort (GPLv2)
- syslog-ng (GPLv2)
- Elasticsearch (Elastic License 2.0)
- Kibana (Elastic License 2.0)

## Architecture du projet :
1. Collecte des logs : syslog-ng collecte les logs de sécurité provenant des équipements réseau et les envoie vers Elasticsearch.
2. Détection d'anomalies : Snort analyse les logs collectés pour détecter les anomalies et les menaces potentielles.
3. Gestion des logs : Elasticsearch stocke les logs collectés et les rend accessibles pour la recherche et l'analyse.
4. Visualisation des logs : Kibana fournit une interface utilisateur pour visualiser les logs et les anomalies détectées.

## Avantages du projet :
- Amélioration de la sécurité des réseaux
- Détection en temps réel des anomalies et des menaces potentielles
- Meilleure visibilité et réponse aux menaces
- Réduction des coûts et de la complexité de la gestion des logs de sécurité

**Licence de ce projet** : [MIT](LICENSE)