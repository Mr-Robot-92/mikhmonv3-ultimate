#!/usr/bin/env bash
set -e

INSTALL_DIR="$HOME/mikhmonv3"
PORT=8080
URL="http://127.0.0.1:$PORT"

# ===== COULEURS =====
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# ===== SYSTEME =====
if [ -d "/data/data/com.termux" ]; then
    SYS="TERMUX"
    HOST="0.0.0.0"
else
    SYS="LINUX"
    HOST="127.0.0.1"
fi

# ===== LOGO =====
logo() {
    clear
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
   MikroTik Hotspot Management Tool
EOF
    echo -e "${RESET}"
    echo -e "${YELLOW}       Mikhmon v3 Control Script${RESET}"
    echo -e "${RED}        modded by Mr Robot — Fsociety${RESET}"
    echo ""
}

# ===== CHECK ONLINE =====
is_online() {
    if command -v lsof &>/dev/null && lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null; then
        return 0
    else
        return 1
    fi
}

# ===== START =====
start() {
    logo
    echo -e "${CYAN}--- Lancement de Mikhmon v3 ---${RESET}"

    [[ ! -d "$INSTALL_DIR" ]] && { echo "Erreur : dossier introuvable"; exit 1; }
    command -v php >/dev/null 2>&1 || { echo "Erreur : PHP non installé"; exit 1; }

    if is_online; then
        echo -e "${GREEN}[ ONLINE ] Serveur déjà actif${RESET}"
        echo -e "URL : ${CYAN}$URL${RESET}"
        exit 0
    fi

    # Vérifier si le port est libre
    if command -v lsof &>/dev/null && lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null; then
        echo -e "${RED}[ ERROR ] Port $PORT déjà utilisé${RESET}"
        exit 1
    fi

    cd "$INSTALL_DIR"
    php -S $HOST:$PORT >/dev/null 2>&1 &

    sleep 1

    if is_online; then
        echo -e "${GREEN}[ ONLINE ] Serveur lancé${RESET}"
        echo -e "URL : ${CYAN}$URL${RESET}"
        # ouvrir navigateur
        if [ "$SYS" = "TERMUX" ] && command -v termux-open-url >/dev/null 2>&1; then
            termux-open-url "$URL"
        elif command -v xdg-open >/dev/null 2>&1; then
            xdg-open "$URL" >/dev/null 2>&1
        fi
    else
        echo -e "${RED}[ ERROR ] Impossible de lancer le serveur${RESET}"
        exit 1
    fi
}

# ===== STOP =====
stop() {
    logo
    if is_online; then
        PIDS=$(lsof -t -i:$PORT)
        echo "$PIDS" | xargs kill >/dev/null 2>&1
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
    stop
    sleep 1
    start
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
