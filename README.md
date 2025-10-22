# UQAC_SIEM
Système de détection d'anomalies et de gestion de logs pour la sécurité des réseaux.

## Description du projet :
Ce projet fait partie du cours de sécurité informatique de l'UQAC pour le trimestre d'automne 2025. Il consiste à assembler différents outils existants afin de créer un système de détection d'anomalies et de gestion de logs pour identifier les menaces potentielles et améliorer la sécurité des réseaux.

Nous avons implémenté 5 cas d'intrusion différents pour démontrer le bon fonctionnement de notre outil.

## Instructions d'installation :
1. Installation de toutes les dépendances docker : Exécuter le fichier install_docker.sh
2. Lancement des conteneurs docker des différents outils : Exécuter le fichier docker-compose.yml avec la commande "sudo docker run docker-compose.yml"

## Instructions d'utilisation :

## Outils utilisés :
- Snort (GPLv2)
- syslog-ng (GPLv2)
- Elasticsearch (Elastic License 2.0)
- Kibana (Elastic License 2.0)

## Architecture du projet :
<table>
  <tr>
    <td align="center">
      <img src="https://github.com/moz-exe/UQAC_SIEM/blob/main/schema_archi.png" alt="schéma de l'architecture du projet" />
    </td>
  </tr>
</table>

1. Détection d'anomalies : Snort analyse le traffic réseau pour détecter des anomalies, c'est-à-dire des traces qui correspondent à des règles configurées manuellement.
2. Collecte et Transfert des logs : Syslog-ng collecte les logs de Snort et les trasfère à ElasticSearch
3. Stockage des logs : ElasticSearch stocke les logs et les indexe 
4. Visualisation et analyse : Kibana récupère les logs d'elastic search et les affiche de manière graphique et compréhensible sur le [portail Kibana](http://localhost:5601/app/home).

Pour plus d'information sur la manière dont les les outils sont utilisés, voir la [documentation](doc.md).

## Avantages du projet :
- Amélioration de la sécurité des réseaux
- Détection en temps réel des anomalies et des menaces potentielles
- Meilleure visibilité et réponse aux menaces
- Réduction des coûts et de la complexité de la gestion des logs de sécurité

## Analyse et conclusion
### Limites du projet :
Le système repose sur des outils existants (Snort, syslog-ng, Elasticsearch, Kibana), ce qui limite la personnalisation des détections. Les corrélations d’événements restent simples et dépendent des règles définies manuellement. La gestion d’un grand volume de logs peut aussi impacter les performances sur une machine virtuelle. Enfin, aucune détection basée sur l’IA n’a encore été intégrée.

### Améliorations possibles :
L’ajout d’un moteur de corrélation comme Wazuh ou TheHive permettrait une analyse plus complète des incidents. Des scripts d’automatisation (alertes Slack, e-mails, etc.) renforceraient la réactivité du système. Une optimisation d’Elasticsearch pourrait améliorer la gestion des données. Une meilleure segmentation réseau rendrait également la collecte plus réaliste.

### Perspectives et veille technologique :
Une évolution vers un véritable SIEM complet (par exemple avec Graylog ou Splunk) serait une suite logique du projet. L’intégration de modèles de Machine Learning pourrait permettre une détection d’anomalies sans règles prédéfinies. Enfin, les solutions open source orientées IA et automatisation (SOAR) offrent des perspectives prometteuses pour renforcer la détection et la réponse aux incidents.


**Licence de ce projet** : [MIT](LICENSE)
