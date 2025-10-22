# Explication des scénarios d'attaque et de la méthode de détection
Les scénarios d'attaques sont automatisés dans le fichier []().
Le fichier [local.rules](snort/etc/snort/rules/local.rules) contient les règles de détection.

## Attaque BruteForce
### Scénario :
Le système détecte de nombreuses tentatives de connection en SSH avec différents mots de passe.

### Méthode d'attaque :
Hydra permet d'effectuer des attaques bruteforce en testant tous les mots de passe contenus dans le fichier rockyou.txt avec la commande suivante :
'''
hydra -l root -P rockyou.txt 127.0.0.1 ssh -t 4
'''

### Méthode de détection :
La règle Snort suivante permet de détecter l'attaque :
'''
alert tcp any any -> 192.168.1.100 22 (msg:"Tentative de force brute SSH"; flow:to_server,established; content:"root"; content:"password"; threshold:type threshold, track by_src, count 5, seconds 60; sid:1000002;)
'''

### Comment lancer le test :
Construire et exécuter l'image docker bruteforce-test avec les commandes :
'''
docker build -t bruteforce-test
docker run --rm -v rockyou.txt:/rockyou.txt bruteforce-test
'''

