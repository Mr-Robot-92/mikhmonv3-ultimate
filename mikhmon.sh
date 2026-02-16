#!/bin/bash

set -e  # Arrête le script en cas d'erreur

# Déterminer le dossier d'installation
if [[ "$HOME" == *"/com.termux/"* ]]; then
    INSTALL_DIR="$HOME/mikhmonv3"
else
    INSTALL_DIR="$HOME/mikhmonv3"
fi

echo "--- Lancement de Mikhmon v3 ---"

# Vérifier que le dossier existe
if [[ ! -d "$INSTALL_DIR" ]]; then
    echo "Erreur : Le dossier $INSTALL_DIR n'existe pas."
    exit 1
fi

cd "$INSTALL_DIR" || exit 1

# Vérifier que PHP est installé
if ! command -v php &> /dev/null; then
    echo "Erreur : PHP n'est pas installé."
    exit 1
fi

# Vérifier si le port 8080 est déjà utilisé
if command -v lsof &> /dev/null && lsof -Pi :8080 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo "Avertissement : Le port 8080 est déjà utilisé."
    read -p "Voulez-vous utiliser un autre port ? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "Entrez le numéro de port : " PORT
    else
        exit 1
    fi
else
    PORT=8080
fi

echo "Démarrage du serveur PHP sur http://127.0.0.1:$PORT"
echo "Appuyez sur Ctrl+C pour arrêter le serveur"
echo "----------------------------------------"

# Lancer le serveur PHP
php -S 127.0.0.1:$PORT
