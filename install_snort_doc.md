sudo apt install snort 

Rentrez l'interface d'écoute du réseau, dans notre enp0s3,l'interface dépend de la machine

Interface(s) which Snort should listen on: enp0s3

Rentrez l'adresse du réseau local. 
Address range for the local network: IP_RESEAU (exemple 192.168.1.0/24)

Édite le fichier /etc/default/snort :

sudo nano /etc/default/snort


Et ajoute ou modifie la ligne :

INTERFACE="enp0s3"

Télécharge les règles officielles gratuites de Snort :

cd /etc/snort/rules
sudo wget https://www.snort.org/downloads/community/community-rules.tar.gz
sudo tar -xvzf community-rules.tar.gz


Cela crée plusieurs fichiers, par exemple :

community-web-php.rules
community-sql.rules
community-virus.rules
community-icmp.rules
