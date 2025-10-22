# Outils
Ce projet utilise 4 outils :
- Snort
- Syslog-ng
- Elasticsearch
- Kibana

# Architecture
## Docker compose
Pour utiliser Syslog-ng, Elasticsearch et Kibana, nous récupérons des images docker existantes à l'aide d'un docker compose.


## Snort
On installe Snort avec le gestionnaire de paquets apt, et on configure une sortie qui va être où syslog-ng va venir récupérer ses logs.
