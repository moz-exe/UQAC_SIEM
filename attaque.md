SCÉNARIO 1 — Scan réseau (Reconnaissance)
🎯 But :

Détecter un scan de ports ou de services sur la cible.

nmap -sS -p 1-1024 192.168.1.15

🧨 SCÉNARIO 2 — Brute-force SSH
🎯 But :

Détecter une tentative de connexion SSH répétée.

💻 Attaque :

Sur ta VM attaquante :

# sur la VM attaquante adapter le chemin avec le répertoire souhaité 
echo -e "password\n123456\nroot" > /home/user/pwlist.txt

#execute avec la liste de password généré avant (remettre le chemin mis précédemment). 
hydra -l root -P /home/user/pwlist.txt ssh://<IP_VM_Snort>


SCÉNARIO 3 — Tentative d’exploitation Web (Injection / PHP exploit)
🎯 But :

Détecter une requête HTTP malveillante.

💻 Attaque :

Sur la VM Snort, installe un petit serveur Apache :
sudo apt install -y apache2
sudo systemctl start apache2

Sur la VM attaquante, lance :
curl "http://<IP_VM_Snort>/index.php?exploit=1"


SCÉNARIO 5 — ICMP flood (déclenche la SID 1000005)

Ta règle : alert icmp any any -> any any (msg:"ICMP flood detected"; detection_filter: track by_src, count 20, seconds 10; sid:1000005;) — il faut ~20 paquets ICMP depuis la même IP en < 10s.

Sur la machine attaque : 
# envoi 25 pings rapides (nécessite sudo pour taux très rapide)
for i in $(seq 1 25); do sudo ping -c1 -W1 192.168.1.15 & done; wait

SCÉNARIO 6 — Règle supplémentaire que je te propose d’ajouter

Je te propose une règle SQLi / tentative d’injection. 

Commande vm attaque : 
curl -s -o /dev/null "http://192.168.1.15/index.php?id=1%27%20OR%20%271%27=%271"
