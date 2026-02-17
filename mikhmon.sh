#!/usr/bin/env bash

set -e

# ===== CONFIG =====
INSTALL_DIR="$HOME/mikhmonv3"
PORT=8080
URL="http://127.0.0.1:$PORT"
PID_FILE="$INSTALL_DIR/mikhmon.pid"

# ===== COULEURS =====
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# ===== LOGO MIKHMON =====
logo() {
echo -e "${CYAN}"
cat << "EOF"
███╗   ███╗██╗██╗  ██╗██╗  ██╗███╗   ███╗ ██████╗ ███╗   ██╗
████╗ ████║██║██║ ██╔╝██║  ██║████╗ ████║██╔═══██╗████╗  ██║
██╔████╔██║██║█████╔╝ ███████║██╔████╔██║██║   ██║██╔██╗ ██║
██║╚██╔╝██║██║██╔═██╗ ██╔══██║██║╚██╔╝██║██║   ██║██║╚██╗██║
██║ ╚═╝ ██║██║██║  ██╗██║  ██║██║ ╚═╝ ██║╚██████╔╝██║ ╚████║
╚═╝     ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
        F S O C I E T Y   CONTROL
        M I K H M O N v3
   MikroTik Hotspot Management Tool
EOF
echo -e "${RESET}"
echo -e "${YELLOW}       Mikhmon v3 Control Script${RESET}"
echo -e "${RED}        modded by Mr Robot — Fsociety${RESET}"
echo ""
}

# ===== FONCTION START =====
start() {
clear
logo
echo -e "${CYAN}--- Lancement de Mikhmon v3 ---${RESET}"

# Vérifier dossier
[[ ! -d "$INSTALL_DIR" ]] && { echo "Erreur : dossier introuvable"; exit 1; }

# Vérifier PHP
command -v php >/dev/null 2>&1 || { echo "Erreur : PHP non installé"; exit 1; }

# Déjà en ligne ?
if [[ -f "$PID_FILE" ]] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
    echo -e "${GREEN}[ ONLINE ] Serveur déjà actif${RESET}"
    echo -e "URL : ${CYAN}$URL${RESET}"
    exit 0
fi

cd "$INSTALL_DIR"

# Lancer serveur PHP
php -S 127.0.0.1:$PORT >/dev/null 2>&1 &
echo $! > "$PID_FILE"
sleep 1

echo -e "${GREEN}[ ONLINE ] Serveur lancé${RESET}"
echo -e "URL : ${CYAN}$URL${RESET}"

# Ouvrir navigateur
if command -v termux-open-url &>/dev/null; then
    termux-open-url "$URL"
elif command -v xdg-open &>/dev/null; then
    xdg-open "$URL" >/dev/null 2>&1
fi
}

# ===== FONCTION STOP =====
stop() {
clear
logo
if [[ -f "$PID_FILE" ]]; then
    PID=$(cat "$PID_FILE")
    if kill -0 $PID 2>/dev/null; then
        kill $PID
        echo -e "${RED}[ OFFLINE ] Serveur arrêté${RESET}"
    else
        echo -e "${RED}[ OFFLINE ] Processus introuvable${RESET}"
    fi
    rm -f "$PID_FILE"
else
    echo -e "${RED}[ OFFLINE ] Aucun serveur actif${RESET}"
fi
}

# ===== FONCTION STATUS =====
status() {
clear
logo
if [[ -f "$PID_FILE" ]] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
    echo -e "${GREEN}[ ONLINE ] Serveur actif${RESET}"
    echo -e "URL : ${CYAN}$URL${RESET}"
else
    echo -e "${RED}[ OFFLINE ] Serveur arrêté${RESET}"
fi
}

# ===== FONCTION RESTART =====
restart() {
logo
echo -e "${YELLOW}[ RESTART ] Redémarrage...${RESET}"
stop
sleep 1
start
}

# ===== FONCTION UPDATE =====
update() {
logo
echo -e "${CYAN}[ UPDATE ] Vérification des mises à jour...${RESET}"

if [[ ! -d "$INSTALL_DIR/.git" ]]; then
    echo "Git non détecté, impossible de mettre à jour automatiquement."
    exit 1
fi

cd "$INSTALL_DIR"
git fetch origin
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

if [ "$LOCAL" != "$REMOTE" ]; then
    echo -e "${YELLOW}[ UPDATE ] Nouvelle version disponible, mise à jour...${RESET}"
    stop
    git pull origin main
    start
    echo -e "${GREEN}[ UPDATE ] Mikhmon est à jour${RESET}"
else
    echo -e "${GREEN}[ UPDATE ] Vous êtes déjà à la dernière version${RESET}"
fi
}

# ===== COMMANDES =====
case "$1" in
    start) start ;;
    stop) stop ;;
    status) status ;;
    restart) restart ;;
    update) update ;;
    *) 
        logo
        echo "Usage :"
        echo "  mikhmon start"
        echo "  mikhmon stop"
        echo "  mikhmon status"
        echo "  mikhmon restart"
        echo "  mikhmon update"
    ;;
esac
