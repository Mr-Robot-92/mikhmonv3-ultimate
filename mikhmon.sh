#!/usr/bin/env bash

set -e

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
 __  __ ___ _  ___  _   _ __  __  ___  _   _ 
|  \/  |_ _| |/ / || | | |  \/  |/ _ \| \ | |
| |\/| || || ' /| || |_| | |\/| | | | |  \| |
| |  | || || . \|__   _| |  | | |_| | |\  |
|_|  |_|___|_|\_\  |_| |_|  |_|\___/|_| \_|

        M I K H M O N   v3
   MikroTik Hotspot Management Tool
EOF
echo -e "${RESET}"

echo -e "${YELLOW}       Mikhmon v3 Control Script${RESET}"
echo -e "${RED}        modded by Mr Robot — Fsociety${RESET}"
echo ""
}

# ===== START =====
start() {

clear
logo

echo -e "${CYAN}--- Lancement de Mikhmon v3 ---${RESET}"

if [[ ! -d "$INSTALL_DIR" ]]; then
    echo "Erreur : dossier introuvable"
    exit 1
fi

if ! command -v php &> /dev/null; then
    echo "Erreur : PHP non installé"
    exit 1
fi

# Déjà actif ?
if [[ -f "$PID_FILE" ]] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
    echo -e "${GREEN}[ ONLINE ] Serveur déjà actif${RESET}"
    echo -e "URL : ${CYAN}$URL${RESET}"
    exit 0
fi

cd "$INSTALL_DIR"

php -S 127.0.0.1:$PORT >/dev/null 2>&1 &

echo $! > "$PID_FILE"

sleep 1

echo -e "${GREEN}[ ONLINE ] Serveur lancé${RESET}"
echo -e "URL : ${CYAN}$URL${RESET}"

# Ouvrir navigateur
if command -v termux-open-url &> /dev/null; then
    termux-open-url "$URL"
elif command -v xdg-open &> /dev/null; then
    xdg-open "$URL" >/dev/null 2>&1
fi
}

# ===== STOP =====
stop() {

logo

if [[ -f "$PID_FILE" ]]; then

    PID=$(cat "$PID_FILE")

    if kill -0 $PID 2>/dev/null; then
        kill $PID
        rm "$PID_FILE"
        echo -e "${RED}[ OFFLINE ] Serveur arrêté${RESET}"
    else
        rm "$PID_FILE"
        echo -e "${RED}[ OFFLINE ] Processus introuvable${RESET}"
    fi

else
    echo -e "${RED}[ OFFLINE ] Aucun serveur actif${RESET}"
fi
}

# ===== STATUS =====
status() {

logo

if [[ -f "$PID_FILE" ]] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
    echo -e "${GREEN}[ ONLINE ] Serveur actif${RESET}"
    echo -e "URL : ${CYAN}$URL${RESET}"
else
    echo -e "${RED}[ OFFLINE ] Serveur arrêté${RESET}"
fi
}

# ===== RESTART =====
restart() {

logo

echo -e "${YELLOW}[ RESTART ] Redémarrage...${RESET}"

if [[ -f "$PID_FILE" ]]; then
    PID=$(cat "$PID_FILE")
    kill $PID 2>/dev/null || true
    rm -f "$PID_FILE"
fi

sleep 1

cd "$INSTALL_DIR"
php -S 127.0.0.1:$PORT >/dev/null 2>&1 &

echo $! > "$PID_FILE"

sleep 1

echo -e "${GREEN}[ ONLINE ] Serveur redémarré${RESET}"
echo -e "URL : ${CYAN}$URL${RESET}"

# Ouvrir navigateur
if command -v termux-open-url &> /dev/null; then
    termux-open-url "$URL"
elif command -v xdg-open &> /dev/null; then
    xdg-open "$URL" >/dev/null 2>&1
fi
}

# ===== COMMANDES =====
case "$1" in
    start) start ;;
    stop) stop ;;
    status) status ;;
    restart) restart ;;
    *)
        logo
        echo "Usage :"
        echo "  mikhmon start"
        echo "  mikhmon stop"
        echo "  mikhmon status"
        echo "  mikhmon restart"
    ;;
esac
