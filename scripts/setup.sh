#!/bin/bash

# ArchLegion2: Script di Ottimizzazione Automatica
# Creato da Cascade per Lenovo Legion Y520

set -e

# --- Funzioni di Utility ---
log() {
    echo -e "\n\e[1;34m--- [INFO] $1 ---\e[0m"
}

error() {
    echo -e "\n\e[1;31m--- [ERROR] $1 ---\e[0m" >&2
    exit 1
}

# --- Controllo Root ---
log "Verifica dei permessi..."
if [[ $EUID -ne 0 ]]; then
   error "Questo script deve essere eseguito come root. Usa 'sudo bash ./setup.sh'"
fi

TARGET_USER=${SUDO_USER:-$(whoami)}
if [ "$TARGET_USER" == "root" ]; then
    error "Questo script non deve essere eseguito direttamente dall'utente root. Usa 'sudo' da un utente normale."
fi
USER_HOME=$(eval echo ~$TARGET_USER)
log "Script eseguito per l'utente: $TARGET_USER"

# --- Installazione Pacchetti di Sistema (pacman) ---
log "Installazione dei pacchetti di sistema necessari..."
pacman -S --noconfirm --needed git base-devel cpupower nvidia nvidia-settings python-pipx python-setuptools

# --- Installazione di 'yay' (AUR Helper) ---
log "Installazione di 'yay' per la gestione dell'AUR..."
if ! command -v yay &> /dev/null; then
    log "yay non trovato. Compilazione e installazione in corso..."
    sudo -u "$TARGET_USER" bash -c "git clone https://aur.archlinux.org/yay.git /tmp/yay && cd /tmp/yay && makepkg -si --noconfirm"
    rm -rf /tmp/yay
    log "yay installato con successo."
else
    log "yay è già installato."
fi

# --- Installazione Pacchetti dall'AUR (yay) ---
log "Installazione dei pacchetti dall'AUR (undervolt, extremecooling4linux)..."
sudo -u "$TARGET_USER" yay -S --noconfirm --needed undervolt extremecooling4linux

# --- Applicazione delle Configurazioni ---
log "Applicazione delle configurazioni di sistema..."
CONFIG_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)/../config

cp -rT "$CONFIG_DIR/etc/" /etc/
log "Configurazioni di /etc applicate."

log "Applicazione delle configurazioni utente per $TARGET_USER..."
mkdir -p "$USER_HOME/.config" "$USER_HOME/.local"
cp -rT "$CONFIG_DIR/home/ciroautuori/.config/" "$USER_HOME/.config/"
cp -rT "$CONFIG_DIR/home/ciroautuori/.local/" "$USER_HOME/.local/"
chown -R "$TARGET_USER:$TARGET_USER" "$USER_HOME/.config" "$USER_HOME/.local"
log "Configurazioni utente applicate."

# --- Attivazione Servizi Systemd ---
log "Attivazione e avvio dei servizi di sistema..."
systemctl enable cpupower.service
systemctl start cpupower.service
systemctl enable undervolt.service
systemctl start undervolt.service
log "Servizi systemd abilitati e avviati."

# --- Messaggio Finale ---
log "****************************************************************"
log "Ottimizzazione ArchLegion2 completata con successo!"
log "Per rendere effettive tutte le modifiche, è FONDAMENTALE RIAVVIARE il sistema."
log "Comando per riavviare: sudo reboot"
log "****************************************************************"

exit 0
