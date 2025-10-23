# **Projet de Cybersécurité – UQAC**
## **Guide de mise en œuvre d'un système de détection d'anomalies et de gestion de logs**


Auteurs :

- Mathis BANZET
- Matthis DAVIAUD
- Romaric HUBERT
- Louis ONILLON

## **Sommaire**

-   **1. Introduction**
    *   [1.1. Organisation du dépôt GitHub](#organisation-du-dépôt-github)
    *   [1.2. Objectif et contexte du projet](#objectif-et-contexte-du-projet)
-   **2. Architecture de la solution**
    *   [2.1. Architecture technologique et outils](#architecture-technologique-et-outils)
    *   [2.2. Schéma d'architecture](#schéma-darchitecture)
    *   [2.3. Avantages de la solution](#avantages-de-la-solution)
-   **3. Guide de mise en oeuvre**
    *   [3.1. Prérequis techniques](#prérequis-techniques)
    *   [3.2. Procédure d'installation détaillée](#procédure-dinstallation-détaillée)
    *   [3.3. Guide de configuration des composants](#guide-de-configuration-des-composants)
-   **4. Analyse de la détection**
    *   [4.1. Scénarios d’attaque et logique de détection](#scénarios-dattaque-et-logique-de-détection)
    *   [4.2. Classification des priorités d'alerte](#classification-des-priorités-dalerte)
-   **5. Bilan et perspectives**
    *   [5.1. Limites actuelles et pistes d'amélioration](#limites-actuelles-et-pistes-damélioration)
    *   [5.2. Conclusion](#conclusion)

## 1. Introduction

### **1.1 Organisation du dépôt GitHub**

Pour garantir une navigation intuitive et faciliter la prise en main du projet, le dépôt GitHub a été organisé selon la structure suivante :

```txt
UQAC_SIEM/
├── .env.exemple
├── docker-compose.yml
├── docs/
│   ├── schema_archi.png
│   └── Simulation attaque.pdf
├── esdata/
│   └── .gitkeep
├── README.md
├── snort/
│   └── local.rules
└── syslog-ng/
    ├── state/
    │   └── .gitkeep
    └── syslog-ng.conf
```

*   **`.env.example`** : Un modèle pour le fichier des variables d'environnement, essentiel à la configuration de Docker Compose.
*   **`docker-compose.yml`** : Fichier d'orchestration qui définit et connecte les services de la pile ELK (Elasticsearch, Kibana) et syslog-ng.
*   **`docs/`** : ce répertoire est destiné à la documentation complémentaire, incluant les schémas d'architecture, et le rapport sur la simulation des attaques.
* **`esdata/`** : dossier pour permettre le montage du volume de donnée pour le service Elasticsearch.
*   **`README.md`** : le présent document, qui sert de guide central et de documentation principale.
*   **`syslog-ng/`** : contient `syslog-ng.conf`, le fichier qui configure la collecte et la redirection des logs et l'arborescence pour le montage des volumes.
*   **`snort/`** : regroupe la configuration du daemon Snort (`snort`) et les règles de détection personnalisées (`local.rules`).
*   **`kibana/export/`** : Inclut `dashboard.ndjson`, permettant d'importer le tableau de bord préconfiguré.

### **1.2 Objectif et contexte du projet**

Inscrit dans le cadre du cours de sécurité informatique de l'UQAC, ce projet vise à concevoir et mettre en œuvre un système intégré de détection d'anomalies et de gestion centralisée des logs (SIEM). La mission est de mettre en place un système intégré de détection d'anomalies et de gestion de logs pour identifier les menaces potentielles et, par conséquent, améliorer la sécurité des réseaux.

L'approche consiste à assembler des outils open source éprouvés pour créer une chaîne de traitement complète : de la surveillance du trafic réseau à la visualisation des alertes de sécurité. Pour valider l'efficacité du système, cinq scénarios d'intrusion distincts ont été simulés, démontrant ainsi la capacité de la solution à les détecter et à les présente.

## **2. Architecture de la solution**

### **2.1 Architecture technologique et outils**

Pour construire ce système de surveillance, une sélection d'outils open source reconnus a été privilégiée, chacun jouant un rôle spécifique et complémentaire :

*   **Système de Détection d'Intrusion (IDS) : Snort**
    Snort (version 2.x) a été choisi pour son rôle d'IDS/IPS (Intrusion Detection/Prevention System). Il analyse le trafic réseau en temps réel et compare les paquets à un ensemble de règles prédéfinies pour identifier les activités suspectes ou malveillantes, générant des alertes en conséquence.

*   **Collecteur de Logs : syslog-ng**
    Agissant comme un "routeur de logs", syslog-ng est chargé de collecter les journaux de sécurité générés par Snort et, potentiellement, par d'autres sources (systèmes, applications). Il les formate et les achemine de manière fiable vers la base de données centrale.

*   **Base de Données et Moteur de Recherche : Elasticsearch**
    Au cœur de la solution, Elasticsearch sert d'entrepôt central. Ce moteur de recherche et d'analyse est optimisé pour indexer de grands volumes de données textuelles, permettant des recherches et des agrégations quasi-instantanées, ce qui est crucial pour l'analyse de logs.

*   **Interface de Visualisation : Kibana**
    Kibana est l'interface utilisateur graphique de la pile Elastic. Elle se connecte à Elasticsearch pour permettre l'exploration des données, la création de visualisations dynamiques et la conception de tableaux de bord interactifs, transformant les logs bruts en informations exploitables.

### **2.2 Schéma d'architecture**

L'architecture de ce projet est volontairement minimaliste pour s'adapter à un environnement de laboratoire. L'ensemble des composants (Snort, syslog-ng, Elasticsearch, Kibana) est déployé sur une unique machine virtuelle (VM) Linux.

**Flux Logique des Données :** notre système est conçu autour d'un flux de travail logique en suivant les étapes suivantes :
1.  **Capture** : Snort surveille l'interface réseau de la VM et génère des alertes dans un fichier local.
2.  **Collecte** : Le service syslog-ng lit ce fichier d'alertes en continu.
3.  **Acheminement** : syslog-ng envoie les alertes formatées à l'instance Elasticsearch.
4.  **Stockage & Indexation** : Elasticsearch stocke et indexe les alertes pour les rendre consultables.
5.  **Visualisation** : Kibana interroge Elasticsearch pour afficher les données sur un tableau de bord.

Voici une représentation visuelle de la façon dont ces outils s'assemblent pour former notre système : `docs/shema_archi.png`

En revanche, en contexte d'entreprise, on retrouve souvent une approche différente. Chaque étape du processus est généralement associée à des équipements, des serveurs ou des services dédiés, répartis sur plusieurs machines ou infrastructures distinctes, pour des raisons de performance, de redondance et de sécurité. C'est une architecture bien plus complexe, conçue pour des volumes de données massifs et des environnements critiques.

### **2.3 Avantages de la solution**

Ce système, bien que conçu dans un cadre académique, offre plusieurs avantages fondamentaux pour la sécurité d'un réseau. Il permet notamment :
* **Amélioration significative de la sécurité des réseaux** en identifiant proactivement les menaces.
* **Détection en temps réel des anomalies et des menaces potentielles** grâce à l'analyse continue du trafic par Snort et la remontée rapide des alertes.
* **Meilleure visibilité et réponse aux menaces** avec Kibana qui centralise les informations, permettant aux administrateurs de comprendre rapidement une situation et d'y réagir.
* **Réduction des coûts et de la complexité** en utilisant des outils open source et une architecture intégrée pour la gestion des logs de sécurité.

## **3. Guide de mise en oeuvre**

### **3.1 Prérequis techniques**

Une base saine est essentielle au bon fonctionnement de la solution. Assurez-vous de disposer des éléments suivants :
*   Une machine virtuelle exécutant **Ubuntu LTS 64 bits** (par exemple, 22.04 LTS) avec le réseau configuré en mode `bridge`.
*   Un accès avec des privilèges `sudo` ou `root`.
*   Ressources minimales allouées : **2 vCPU**, **4 Go de RAM** (8 Go sont recommandés pour de meilleures performances d'Elasticsearch et Kibana) et **20 Go d'espace disque**.

### **3.2 Procédure d'installation détaillée**

1.  **Mise à jour du système** : commencez par mettre à jour les paquets du système d'exploitation.
    ```bash
    sudo apt update && sudo apt upgrade -y
    ```

2.  **Installation de Docker et Docker Compose** : la pile ELK et syslog-ng sont conteneurisées. Ces commandes ajoutent le dépôt officiel de Docker et installent les composants nécessaires.
    ```bash
    ## Add Docker's official GPG key
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    
    ## Add the repository to Apt sources:
    echo \ "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \ $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \ 
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    
    ## Install the Docker packages
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    ```

3.  **Récupération du Projet** : clonez le dépôt GitHub pour obtenir tous les fichiers de configuration.
    ```bash
    git clone https://github.com/votre_repo/UQAC_SIEM.git
    cd UQAC_SIEM
    ```

4.  **Configuration de l'Environnement** : créez votre fichier de variables d'environnement à partir du modèle fourni.
    ```bash
    cp .env.example .env
    ```
    *Il est conseillé d'éditer le fichier `.env` pour y insérer des clés de chiffrement uniques pour Kibana (voir [Guide de configuration détaillée des composants](#guide-de-configuration-détaillée-des-composants)).*

5.  **Installation de Snort** : Snort sera installé directement sur la machine hôte pour surveiller son trafic.
    ```bash
    sudo apt install -y snort
    ```

6.  **Lancement de la Plateforme** : démarrez les conteneurs Elasticsearch, Kibana et syslog-ng en arrière-plan.
    ```bash
    sudo docker compose up -d
    ```

7.  **Vérification du Déploiement** : assurez-vous que tous les services sont opérationnels.
    ```bash
    sudo docker compose ps
    sudo systemctl status snort.service
    ```
    Les conteneurs Docker devraient afficher un statut `Up (healthy)`. Le service Snort devrait être `active (running)`.

### **3.3 Guide de configuration des composants**
Cette section détaille les ajustements nécessaires pour chaque composant afin d'assurer une communication fluide et une surveillance fonctionnelle

#### **1. Machine Virtuelle Hôte**
Avant de lancer les services, un paramètre du noyau Linux peut être ajusté pour répondre aux exigences d'Elasticsearch en matière de gestion de la mémoire.

-   **Ajustement de `vm.max_map_count`** Elasticsearch utilise de nombreux "memory-mapped areas". La valeur par défaut sur la plupart des systèmes Linux est trop basse et peut empêcher son démarrage.
    1.  **Appliquer la configuration temporairement :**
		```bash
	    sudo sysctl -w vm.max_map_count=262144
		```
    2. **Rendre la configuration permanente** (pour qu'elle survive à un redémarrage) en l'ajoutant au fichier `/etc/sysctl.conf` :
		```bash
		echo 'vm.max_map_count=262144' | sudo tee -a /etc/sysctl.conf        
		```

#### **2. Elasticsearch**

La configuration d'Elasticsearch est principalement gérée via le fichier `docker-compose.yml`. Cela permet de définir l'environnement d'exécution du conteneur sans modifier ses fichiers internes.

**Fichier de référence : `docker-compose.yml`**
*   **Variables d'environnements**
    * `discovery.type=single-node` : définit Elasticsearch en **mode nœud unique** (pas de cluster).
    * `xpack.security.enabled=false` : désactive la sécurité (pas d'authentification, pas de chiffrement TLS) dans le cadre de cet environnement de maquette.
    * `ES_JAVA_OPTS=-Xms512m -Xmx512m` : définit la **mémoire allouée à la JVM** (Java Virtual Machine) d'Elasticsearch avec 512 Mo de mémoire **minimale** au démarrage et 512 Mo de mémoire **maximale** autorisée.
    * `bootstrap.memory_lock=true` : **vérrouille la mémoire** allouée à Elasticsearch pour éviter les **swaps** (échanges avec le disque).
* **Accès réseau (ports)**
	* `"127.0.0.1:9200:9200"` : mappe le **port 9200 du conteneur** vers le **port 9200 de la machine locale**, **uniquement accessible depuis `127.0.0.1`**.
* **Volumes de données**
	* `esdata:/usr/share/elasticsearch/data` : création d'un volume pour la persistence des données.

Aucune intervention manuelle n'est requise pour la configuration de base.

#### **3. Kibana**

Tout comme Elasticsearch, Kibana est configuré via le fichier `docker-compose.yml` et via le fichier  `.env`.

**Fichier de référence : `docker-compose.yml`**
* **Accès réseau (ports)**
	* `"5601:5601"` : mappe le **port 5601 du conteneur** vers le **port 5601 de la machine locale**. Une fois lancé, Kibana sera accessible via votre navigateur à l'adresse `http://IP_VM:5601`.
*   **Variables d'environnements**
	* `SERVER_PUBLICBASEURL=http://${PUBLIC_IP}:5601` : définit l'**URL publique** utilisée par Kibana pour générer des liens (ex: partages de dashboards).
	* `ELASTICSEARCH_HOSTS=http://elasticsearch:9200` : indique à Kibana **où trouver Elasticsearch**.
	* `XPACK_ENCRYPTEDSAVEDOBJECTS_ENCRYPTIONKEY= ${KIBANA_ENCRYPTION_KEY}` : clé de chiffrement pour les **objets sauvegardés** dans Kibana (ex: dashboards, requêtes sauvegardées).
	* `XPACK_REPORTING_ENCRYPTIONKEY= ${KIBANA_REPORTING_ENCRYPTION_KEY}` : clé de chiffrement pour le **module Reporting** (génération de PDF/CSVs depuis Kibana).
	* `XPACK_SECURITY_ENCRYPTIONKEY= $ {KIBANA_SECURITY_ENCRYPTION_KEY}` : clé de chiffrement pour les **données de sécurité** (ex: sessions utilisateurs, cookies).
	* `TELEMETRY_OPTIN=false` : désactive la **collecte de données de télémétrie** (statistiques d'utilisation envoyées à Elastic).

Certaines variables d'environnements sont à configurer dans un fichier `.env`. Le fichier `.env.exemple` contient une base à adapter à votre environnement.

**Fichier de référence : `.env`**
```text
PUBLIC_IP=<IP publique de la VM>
KIBANA_ENCRYPTION_KEY=<clé hexadécimale aléatoire de 32 octets>
KIBANA_REPORTING_ENCRYPTION_KEY=<clé hexadécimale aléatoire de 32 octets>
KIBANA_SECURITY_ENCRYPTION_KEY=<clé hexadécimale aléatoire de 32 octets>
```
Les clés de chiffrement servent à sécuriser les données internes, les rapports et les sessions de Kibana. Sans ces dernières, **Kibana ne fonctionnera pas correctement sans ces clés** dans les versions **8.x et ultérieures**, et certaines fonctionnalités seront **désactivées ou en erreur**.

Vous pouvez générer les clés hexadécimales aléatoirement directement depuis le terminal. Par exemple avec `openssl` :
```bash
openssl rand -hex 32
```
\
Enfin, appliquez la modification de la configuration en redémarrant le service Kibana :
```bash
sudo docker compose restart kibana
```

#### **4. syslog-ng**
Comme précédemment, syslog-ng est configuré via le fichier `docker-compose.yml` ainsi que le fichier de configuration `syslog-ng/syslog-ng.conf`.

**Fichier de référence : `docker-compose.yml`**
* **Volumes de données**
	* `syslog-ng/syslog-ng.conf:/etc/syslog-ng/syslog-ng.conf:ro` :  monte le **fichier de configuration personnalisé** en lecture  seule.
	* `syslog-ng/state:/var/lib/syslog-ng` : sauvegarde l’**état persistant** de syslog-ng pour éviter de relire tous les logs depuis le début après un redémarrage.
	* `/var/log/snort/snort.alert.fast:/var/log/snort/snort.alert.fast:ro` : monte le **fichier de logs Snort** (alertes de sécurité) en lecture seule.
* **Options d'exécution**
	* `--no-caps` : désactive les **capacités Linux** non nécessaires (sécurité).
	* `--control /run/syslog-ng/syslog-ng.ctl` : active le **socket de contrôle** pour gérer syslog-ng dynamiquement (ex: recharger la config sans redémarrer).
* **Options pour le montage des volumes**
	* `read_only: true` : monte le **système de fichiers du conteneur en lecture seule**, sauf pour les volumes explicitement montés.
* **Systèmes de fichiers en mémoire**
	* `/run/syslog-ng` : stocke les **sockets de contrôle** et fichiers temporaires de syslog-ng **en mémoire (RAM)**.
	* `/tmp` : dossier temporaire standard pour syslog-ng.

**Fichier de référence : `syslog-ng/syslog-ng.conf`**
Ce fichier est structuré en trois blocs logiques : `source`, `destination` et `log`.
*  **La Source (`source`) : d'où viennent les logs ?** Le bloc `source s_snort` indique à syslog-ng de surveiller le fichier d'alertes Snort toutes les secondes et et de conserver (`no-parse`) la ligne brute dans `${MESSAGE}`.
	```conf
	source s_snort { file("/var/log/snort/alert" follow-freq(1) flags(no-parse)); };`
	```   
*   **La Destination (`destination`) : où vont les logs ?** Le bloc `destination d_elastic` configure l'envoi vers Elasticsearch via l’API `_bulk`.
	```conf
	destination d_elasticsearch_http {
	  elasticsearch-http(
	    url("http://elasticsearch:9200/_bulk")
	    index("logs-snort-${YEAR}.${MONTH}.${DAY}")
	    type("")
	    template("$(format-json --scope nv-pairs --exclude DATE --exclude LEGACY_MSGHDR @timestamp=${ISODATE})\n")
	  );
	};
	```
    -   `index(...)` : Nom de l'index dans lequel les logs seront stockés.
    -   `url(...)` : L'URL du service Elasticsearch, utilisant à nouveau le nom de service Docker `elastic`.

-   **La Règle (`log`) : connecter la source à la destination.** Le bloc `log` active le flux de données et le contrôle de flux pour ne pas perdre d’événements quand ElasticSearch ralentit.
	```conf
	log { source(s_snort); destination(d_elasticsearch_http); flags(flow-control); };
	```

*PS : étant donné que `syslog-ng` tourne dans un conteneur, assurez-vous que le fichier d'alerte de Snort (`/var/log/snort/alert`) est monté à l'intérieur de ce conteneur pour qu'il puisse le lire.*

Enfin, appliquez la modification de la configuration en redémarrant le service syslog-ng :
```bash
sudo docker compose restart syslogng
```

#### **5. Snort (IDS/IPS)**

La configuration de Snort, installé sur la machine hôte, détermine ce qui est surveillé et comment les alertes sont générées.

**Fichier de référence : `/etc/snort/snort.conf`**
* **Définir le réseau à protéger (`HOME_NET`)** : c'est la directive la plus importante pour éviter les faux positifs.
	```conf
	var HOME_NET 10.0.0.0/24   # À adapter selon votre sous-réseau (ex: 192.168.1.0/24)
	```    
-   **Inclure les règles personnalisées** : pour que Snort prenne en compte les **règles personnalisées**, vérifiez que le fichier `local.rules` est bien **inclus** dans la configuration principale vers la fin du fichier dans la section dédiée à l'inclusion des fichiers de règles.
	```conf
	include $RULE_PATH/local.rules
	```
        
**Fichier de référence : `/etc/default/snort`**
* **Inclure l'interface d'écoute** : ce fichier permet de définir l'interface réseau sur laquelle Snort doit écouter. Ajoutez ou modifiez la variable `INTERFACE` :
	```conf
	INTERFACE="enp0s3"   # À adapter selon votre environnement
	```

**PS : Vérifications recommandées** avant de démarrer Snort, assurez-vous que :
1. **`HOME_NET` correspond à votre réseau réel** (utilisez `ip a` ou `ifconfig` pour le vérifier).
2. **Le chemin vers `local.rules` est correct** (vérifiez la variable `$RULE_PATH` dans `snort.conf`).
3. **Les règles personnalisées sont syntaxiquement valides** (utilisez `snort -T` pour tester la configuration).

**Exemple de test** :
```bash
sudo snort -T -c /etc/snort/snort.conf
```
Si aucune erreur n’est affichée, la configuration est alors valide.

Enfin, appliquez la modification de la configuration en redémarrant le daemon `snort.service` :
```bash
sudo systemctl restart snort.service
```

## **4. Analyse de la détection**

### **4.1 Scénarios d’attaque et logique de détection**

Pour valider l'efficacité du système de surveillance, une série de règles de détection a été implémentée. Celles-ci ciblent cinq scénarios d'attaque distincts, représentatifs des différentes phases d'une cyberattaque : la reconnaissance, la tentative d'exploitation, le téléchargement de charge utile et le déni de service.

### **4.2 Classification des priorités d'alerte**

Afin de standardiser l'analyse et la réponse aux incidents, chaque alerte est classée selon une échelle de priorité. Ce système permet aux analystes de se concentrer sur les menaces les plus critiques en premier lieu.

| **Priorité** | **Niveau** | **Signification et impact typique** | **Directive de réponse (SLA Suggéré)** |
| :--- | :--- | :--- | :--- |
| **1** | **Critique** | Indique une compromission très probable ou un impact direct et immédiat sur la production (prise de contrôle, exfiltration de données, déni de service effectif). | **Immédiate** (quelques minutes) pour contenir la menace et démarrer l'investigation. |
| **2** | **Élevée** | Concerne une tentative d'exploitation active ou une activité hautement suspecte indiquant une forte intention malveillante. Le risque de compromission est élevé. | **Rapide** (moins d'une heure) pour qualifier la menace et appliquer des mesures préventives. |
| **3** | **Modérée** | Signale une activité de reconnaissance, une violation de politique de sécurité mineure ou un signal faible. L'impact n'est pas immédiat. | **Surveillance** (dans la journée) pour corréler avec d'autres événements. Un bannissement automatique peut être envisagé en cas de récidive. |

### **Analyse détaillée des scénarios de détection**

Chaque règle Snort a été conçue pour identifier un comportement spécifique. La section suivante détaille la logique derrière chaque règle, le risque associé et les critères utilisés pour évaluer son niveau de priorité.

#### **Scénario 1 : Balayage de ports de type SYN scan**

Cette règle vise à détecter la phase initiale de reconnaissance, où un attaquant tente d'identifier les ports et services ouverts sur une cible.

* **Règle Snort :** `alert tcp any any -> any any (msg:"SYN portscan detected"; flags:S; detection_filter: track by_src, count 20, seconds 10; priority:3; sid:1000001; rev:1;)`

-   **Analyse du risque et de l'impact (CIA) :**  
    -   **Confidentialité :** Nul. Aucune donnée n'est compromise à ce stade.
    -   **Intégrité :** Nulle. Aucune modification du système n'est effectuée.
    -   **Disponibilité :** Nulle. L'impact sur les services est négligeable.
    -   **Conclusion :** Il s'agit d'une activité de **pré-attaque**. Elle ne constitue pas une compromission en soi, mais est souvent le prélude à une tentative d'exploitation.

*   **Logique de priorisation (Priorité 3 - Modérée) :** Un scan de ports, pris isolément, est considéré comme un signal faible. De nombreux services sur Internet (moteurs de recherche, scanners de sécurité) effectuent ce type d'activité en continu. Une priorité modérée permet de consigner l'événement sans générer de fatigue d'alerte.
    
-   **Conditions d'escalade vers une priorité 2 (Élevée) :** L'alerte doit être réévaluée si elle est corrélée avec d'autres indicateurs, tels que :
    -   Un scan particulièrement agressif (ex: centaines de ports scannés depuis une même source).
    -   Le scan est immédiatement suivi (dans un intervalle de quelques minutes) par une tentative d'exploitation (voir scénarios 2 et 3) provenant de la même source.

#### **Scénario 2 : Tentative de forçage brut sur SSH**

Cette règle identifie une tentative d'accès non autorisé à un serveur via le protocole SSH par essais multiples de mots de passe.

* **Règle Snort :** `snort alert tcp any any -> any 22 (msg:"SSH brute force"; flow:to_server,established; detection_filter: track by_src, count 5, seconds 60; priority:1; sid:1000002; rev:1;)`

-   **Analyse du risque et de l'impact (CIA) :**
	-   **Confidentialité :** Critique. Une réussite donne un accès complet aux données du serveur.
    -   **Intégrité :** Critique. L'attaquant peut modifier des fichiers, installer des portes dérobées ou utiliser le serveur comme pivot pour d'autres attaques.
    -   **Disponibilité :** Moyenne. De multiples tentatives peuvent entraîner le verrouillage du compte ciblé.
*   **Logique de priorisation (Priorité 1 - Critique) :** La nature même de l'attaque justifie une priorité critique. Une cadence de 5 tentatives en moins d'une minute signale une intention malveillante claire et automatisée. L'impact potentiel d'une réussite est maximal, nécessitant une réponse immédiate pour bloquer l'adresse IP source.
-   **Cas de réévaluation en priorité 2 (Élevée) :** Une rétrogradation est envisageable uniquement si l'investigation prouve que la source est légitime, par exemple :
    -   Un scanner de vulnérabilités interne connu et autorisé.
    -   Un utilisateur légitime ayant des difficultés de connexion (à confirmer par d'autres moyens).

#### **Scénario 3 : Tentative d'exploitation via HTTP**

Cette règle générique est conçue pour détecter des chaînes de caractères dans les requêtes HTTP qui sont typiques des tentatives d'exploitation de vulnérabilités applicatives (ex: injection SQL, RCE).

* **Règle Snort :** `snort alert tcp any any -> any 80 (msg:"HTTP exploit attempt"; content:"exploit"; http_uri; nocase; priority:2; sid:1000003; rev:1;)`

-   **Analyse du risque et de l'impact (CIA) :**
    -   **Intégrité / Confidentialité :** Critique. Le succès peut mener à une exécution de code à distance, une modification de la base de données ou une exfiltration massive de données.
    -   **Disponibilité :** Variable. Un exploit mal formé peut provoquer un crash de l'application.

*   **Logique de priorisation (Priorité 2 - Élevée) :** L'alerte signale une **tentative** et non une réussite confirmée. La priorité est donc élevée car la menace est sérieuse, mais elle nécessite une investigation pour confirmer l'impact.
    
-   **Conditions d'escalade vers une priorité 1 (Critique) :** L'escalade est immédiate si l'investigation révèle des preuves de compromission :
    -   **Corrélation avec les logs du serveur web :** Un code de réponse HTTP `200 OK` ou `500 Internal Server Error` pour la requête suspecte.
    -   **Analyse des logs applicatifs :** Des erreurs inattendues (ex: erreurs SQL, exceptions Java/PHP) au même moment.
    -   **Apparition d'indicateurs de compromission (IOC) :** Création de fichiers suspects sur le serveur, processus anormaux, connexions sortantes vers des adresses IP suspectes.

#### **Scénario 4 : Requête HTTP pour un fichier exécutable (.exe)**

Cette règle surveille une activité anormale et hautement suspecte : une tentative de télécharger un fichier exécutable Windows depuis un serveur web.

* **Règle Snort :** `snort alert tcp any any -> $HOME_NET $HTTP_PORTS (msg:"HTTP Suspicious EXE request (URI)"; flow:to_server; uricontent:".exe"; nocase; priority:2; sid:1001106; rev:2;)`

-   **Analyse du risque et de l'impact (CIA) :**
    -   **Intégrité :** Élevé. Il s'agit souvent de la deuxième étape d'une attaque, où l'attaquant force le serveur compromis à télécharger une charge utile malveillante (malware, ransomware, outil de post-exploitation).
    -   **Confidentialité / Disponibilité :** L'impact dépend de la nature de l'exécutable téléchargé.

-   **Logique de priorisation (Priorité 2 - Élevée) :** Ce comportement est suffisamment anormal pour justifier une priorité élevée. Bien qu'il ne s'agisse pas d'une compromission en soi, c'est un fort indicateur qu'une machine (soit le serveur, soit un client du réseau) est impliquée dans une activité malveillante.
    
*   **Conditions d'escalade vers une priorité 1 (Critique) :**
    -   **Confirmation du téléchargement :** Les logs du serveur web montrent que la requête a abouti avec un code `200 OK`.
    -   **Analyse du fichier :** Si le fichier est récupérable, son analyse (par exemple, en soumettant son hash à VirusTotal) révèle qu'il est malveillant.
    -   **Source suspecte :** La requête provient d'un User-Agent automatisé (ex: `Wget`, `curl`) plutôt que d'un navigateur standard.

#### **Scénario 5 : Inondation de Requêtes ICMP (ICMP Flood)**

Cette règle détecte une forme simple mais efficace de déni de service (DoS), où une cible est submergée de paquets ICMP (ping).

* **Règle Snort :** `snort alert icmp any any -> any any (msg:"ICMP flood detected"; detection_filter: track by_src, count 20, seconds 10; priority:1; sid:1000005; rev:1;)`

-   **Analyse du risque et de l'impact (CIA) :**
    -   **Disponibilité :** Critique. L'objectif est de saturer la bande passante réseau ou les ressources CPU de la cible (serveur, pare-feu, routeur) pour la rendre inaccessible.
    -   **Confidentialité / Intégrité :** Nul. L'attaque ne vise pas à voler ou modifier des données.

*   **Logique de priorisation (Priorité 1 - Critique) :** L'impact sur la disponibilité des services est direct et immédiat. Une telle attaque peut paralyser une infrastructure. La priorité est donc critique pour permettre une réaction rapide, comme le blocage de l'IP source au niveau du pare-feu ou du fournisseur d'accès. Le seuil (20 paquets en 10 secondes) est suffisamment bas pour détecter rapidement une attaque naissante.
    
*   **Cas de réévaluation en priorité 2 (Élevée) :** Cette situation est rare mais possible si l'alerte est déclenchée par un outil de supervision réseau mal configuré. Une telle exception doit être documentée et approuvée.

*PS : pour une description détaillée de la simulation de ces attaques et de la visualisation des résultats, il convient de se référer au document complémentaire : `Simulation attaque.pdf`.*

## **5. Bilan et perspectives**

### **5.1 Limites actuelles et pistes d'amélioration**

Tout projet a ses limites, et les identifier est une étape clé pour envisager des évolutions futures.

-   **Limites actuelles**
    *   **Couverture des règles** : le jeu de règles actuel est limité aux cinq scénarios. Un environnement de production nécessiterait une base de règles beaucoup plus vaste et continuellement mise à jour (ex: règles de la communauté Snort ou Emerging Threats).
    *   **Corrélation limitée** : l'analyse se concentre sur les alertes Snort. Une véritable vision SIEM nécessiterait d'ingérer et de corréler des logs de sources multiples (pare-feu, serveurs Windows/Linux, DNS, applications).
    *   **Sécurité de la plateforme** : l'accès à Elasticsearch et Kibana n'est pas authentifié. En production, l'activation du module de sécurité X-Pack est indispensable.

*   **Pistes d'amélioration**
    *   **Enrichissement des données** : utiliser les "ingest pipelines" d'Elasticsearch pour enrichir les logs à la volée avec des informations de géolocalisation (GeoIP) ou des résolutions DNS inversées.
    *   **Automatisation de la réponse (SOAR)** : intégrer des mécanismes de réponse automatisée. Par exemple, un script pourrait automatiquement bloquer une adresse IP source sur le pare-feu suite à une alerte critique confirmée.
    *   **Évolution technologique** : migrer vers des outils plus modernes comme Snort 3 ou Suricata pour bénéficier du multi-threading et de performances accrues, ou intégrer des agents d'hôte comme Wazuh pour une visibilité au niveau du système d'exploitation.

### **5.2 Conclusion**

Ce projet démontre avec succès la faisabilité de construire un système de détection d'intrusions et de gestion de logs efficace en utilisant une chaîne d'outils open source. La solution mise en place est capable de collecter, d'analyser et de visualiser des alertes de sécurité pour des scénarios d'attaque définis. Bien qu'il s'agisse d'un prototype conçu pour un environnement de laboratoire, il constitue une base solide et fonctionnelle. Les pistes d'amélioration proposées ouvrent la voie à une évolution vers une solution de sécurité plus robuste, scalable et prête à être déployée dans des environnements plus exigeants.
