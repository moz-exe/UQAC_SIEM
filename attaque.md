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
