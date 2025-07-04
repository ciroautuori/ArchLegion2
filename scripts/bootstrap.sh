#!/bin/bash
# ArchLegion2 Bootstrap Script
# Questo script avvia l'intero processo di ottimizzazione.

set -e

echo "--- ArchLegion2 Bootstrap ---"
echo "Questo script clonerà il repository e avvierà l'installazione automatica."

# Controlla se git è installato
if ! command -v git &> /dev/null; then
    echo "git non è installato. Installazione in corso..."
    sudo pacman -S --noconfirm git
fi

# Clona il repository in una directory temporanea
REPO_URL="https://github.com/CiroAutuori/ArchLegion2.git" # <-- Assicurati che questo URL sia corretto
CLONE_DIR="/tmp/ArchLegion2"
echo "Clonazione del repository da $REPO_URL..."
# Rimuovi la directory se esiste già
if [ -d "$CLONE_DIR" ]; then
    rm -rf "$CLONE_DIR"
fi
git clone "$REPO_URL" "$CLONE_DIR"

# Esegui lo script di setup principale
SETUP_SCRIPT="$CLONE_DIR/scripts/setup.sh"
if [ -f "$SETUP_SCRIPT" ]; then
    echo "Esecuzione dello script di setup principale..."
    cd "$CLONE_DIR/scripts"
    bash ./setup.sh # Eseguito come root perché bootstrap.sh è già sotto sudo
else
    echo "ERRORE: Script di setup non trovato in $SETUP_SCRIPT"
    exit 1
fi

# Pulizia finale
echo "Pulizia della directory temporanea..."
rm -rf "$CLONE_DIR"

echo "--- Bootstrap completato con successo! Riavvia il sistema quando richiesto dallo script principale. ---"
