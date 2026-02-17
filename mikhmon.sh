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

# ===== FONCTION CHECK PORT =====
is_online() {
    if command -v lsof >/dev/null 2>&1; then
        lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1
    elif command -v ss >/dev/null 2>&1; then
        ss -ltn | grep -q ":$PORT"
    else
        netstat -tln 2>/dev/null | grep -q ":$PORT"
    fi
}

# ===== LOGO =====
logo() {

echo -e "${CYAN}"
cat << "EOF"
███╗   ███╗██╗██╗  ██╗██╗  ██╗███╗   ███╗ ██████╗ ███╗   ██╗
████╗ ████║██║██║ ██╔╝██║  ██║████╗ ████║██╔═══██╗████╗  ██║
██╔████╔██║██║█████╔╝ ███████║██╔████╔██║██║   ██║██╔██╗ ██║
██║╚██╔╝██║██║██╔═██╗ ██╔══██║██║╚██╔╝██║██║   ██║██║╚██╗██║
██║ ╚═╝ ██║██║██║  ██╗██║  ██║██║ ╚═╝ ██║╚██████╔╝██║ ╚████║
╚═╝     ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
        F S O C I E T Y   C O N T R O L
        M I K H M O N   v3
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

if [[ ! -d "$INSTALL_DIR" ]]; then
    echo "Erreur : dossier introuvable"
    exit 1
fi

if ! command -v php &> /dev/null; then
    echo "Erreur : PHP non installé"
    exit 1
fi

if is_online; then
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

if is_online; then
    PID=$(lsof -t -i:$PORT 2>/dev/null || true)
    kill $PID 2>/dev/null || true
    rm -f "$PID_FILE"
    echo -e "${RED}[ OFFLINE ] Serveur arrêté${RESET}"
else
    echo -e "${RED}[ OFFLINE ] Aucun serveur actif${RESET}"
fi
}

# ===== STATUS =====
status() {

logo

if is_online; then
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

if is_online; then
    PID=$(lsof -t -i:$PORT 2>/dev/null || true)
    kill $PID 2>/dev/null || true
fi

sleep 1

cd "$INSTALL_DIR"
php -S 127.0.0.1:$PORT >/dev/null 2>&1 &

echo $! > "$PID_FILE"

sleep 1

echo -e "${GREEN}[ ONLINE ] Serveur redémarré${RESET}"
echo -e "URL : ${CYAN}$URL${RESET}"

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
