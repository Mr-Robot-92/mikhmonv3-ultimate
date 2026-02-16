##!/bin/bash

clear

# ====== COULEURS ======
R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;33m'
C='\033[1;36m'
W='\033[0m'

# ====== BANNIERE ======
echo -e "${R}"
cat << "EOF"
███╗   ███╗██╗██╗  ██╗██╗  ██╗███╗   ███╗ ██████╗ ███╗   ██╗
████╗ ████║██║██║ ██╔╝██║ ██╔╝████╗ ████║██╔═══██╗████╗  ██║
██╔████╔██║██║█████╔╝ █████╔╝ ██╔████╔██║██║   ██║██╔██╗ ██║
██║╚██╔╝██║██║██╔═██╗ ██╔═██╗ ██║╚██╔╝██║██║   ██║██║╚██╗██║
██║ ╚═╝ ██║██║██║  ██╗██║  ██╗██║ ╚═╝ ██║╚██████╔╝██║ ╚████║
╚═╝     ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝

        M I K H M O N   V 3   I N S T A L L E R
EOF
echo -e "${W}"

# ====== SIGNATURE ======
echo -e "${R}"
cat << "EOF"
        ┌────────────────────────────┐
             by Mr Robot
               F S O C I E T Y
        └────────────────────────────┘
EOF
echo -e "${W}"

sleep 1

echo -e "${C}[ SYSTEM ] Initialisation...${W}"
sleep 1

# ====== MENU ======
echo ""
echo -e "${Y}Choisissez une option :${W}"
echo -e "${G}1) Installer Mikhmon V3${W}"
echo -e "${R}2) Quitter${W}"
echo ""

read -p ">>> " choix

if [ "$choix" != "1" ]; then
    echo -e "${R}Annulé.${W}"
    exit
fi

# ====== INSTALL ======
echo ""
echo -e "${C}[+] Mise à jour du système...${W}"
pkg update -y > /dev/null 2>&1

echo -e "${C}[+] Installation des dépendances...${W}"
pkg install php curl unzip git -y > /dev/null 2>&1

cd $HOME

echo -e "${C}[+] Téléchargement de Mikhmon...${W}"

rm -rf mikhmonv3 > /dev/null 2>&1
git clone https://github.com/Mr-Robot-92/mikhmonv3.git > /dev/null 2>&1

echo -e "${C}[+] Configuration...${W}"

chmod +x $HOME/mikhmonv3/mikhmon.sh
ln -sf $HOME/mikhmonv3/mikhmon.sh $PREFIX/bin/mikhmon

sleep 1

# ====== FIN ======
echo ""
echo -e "${G}[✓] INSTALLATION TERMINÉE${W}"
echo -e "${G}[✓] Commande : mikhmon${W}"
echo ""

echo -e "${R}Connexion au système...${W}"
sleep 1
echo -e "${C}Accès autorisé.${W}"
sleep 1

echo -e "${Y}Lancez Mikhmon avec : ${G}mikhmon${W}"
echo ""
echo -e "${R}-- Mr Robot | Fsociety --${W}"
