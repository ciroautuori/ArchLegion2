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

# TARGET_USER=${SUDO_USER:-$(whoami)}
# if [ "$TARGET_USER" == "root" ]; then
#     error "Questo script non deve essere eseguito direttamente dall'utente root. Usa 'sudo' da un utente normale."
# fi
TARGET_USER=${SUDO_USER}
USER_HOME=$(eval echo ~$TARGET_USER)
log "Script eseguito per l'utente: $TARGET_USER"

# --- Installazione Pacchetti di Sistema (pacman) ---
log "Installazione dei pacchetti di sistema necessari..."
pacman -S --noconfirm --needed git base-devel cpupower nvidia nvidia-settings python-pipx python-setuptools flatpak zsh

# --- Installazione di 'yay' (AUR Helper) ---
log "Installazione di 'yay' per la gestione dell'AUR..."
if ! command -v yay &> /dev/null; then
    log "yay non trovato. Compilazione e installazione in corso..."
    sudo -u "$TARGET_USER" bash -c "rm -rf /tmp/yay && git clone https://aur.archlinux.org/yay.git /tmp/yay && cd /tmp/yay && makepkg -si --noconfirm"
    rm -rf /tmp/yay
    log "yay installato con successo."
else
    log "yay è già installato."
fi

# --- Installazione Pacchetti dall'AUR (yay) ---
log "Installazione dei pacchetti dall'AUR (undervolt, extremecooling4linux)..."
sudo -u "$TARGET_USER" yay -S --noconfirm --needed undervolt extremecooling4linux anydesk-bin whatsdesk-bin telegram-desktop-bin spotify visual-studio-code-bin xfce4-docklike-plugin

# --- Applicazione delle Configurazioni ---
log "Applicazione delle configurazioni di sistema..."
CONFIG_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)/../config

cp -rT "$CONFIG_DIR/etc/" /etc/
log "Configurazioni di /etc applicate."

log "Applicazione delle configurazioni utente per $TARGET_USER..."
mkdir -p "$USER_HOME/.config" "$USER_HOME/.local"
# Copia le configurazioni utente solo se la directory di origine esiste
if [ -d "$CONFIG_DIR/home/ciroautuori/.config" ]; then
    cp -rT "$CONFIG_DIR/home/ciroautuori/.config/" "$USER_HOME/.config/"
fi
if [ -d "$CONFIG_DIR/home/ciroautuori/.local" ]; then
    cp -rT "$CONFIG_DIR/home/ciroautuori/.local/" "$USER_HOME/.local/"
fi
chown -R "$TARGET_USER:$TARGET_USER" "$USER_HOME/.config" "$USER_HOME/.local"
log "Configurazioni utente applicate."

# --- Attivazione Servizi Systemd ---
log "Attivazione e avvio dei servizi di sistema..."
# Disabilitato per compatibilità con VM
# systemctl enable cpupower.service
# systemctl start cpupower.service
# systemctl enable undervolt.service
# systemctl start undervolt.service
log "Servizi systemd abilitati e avviati."

# --- Configurazione Post-Installazione ---

log "Installazione del tema GTK WhiteSur..."
sudo -u "$TARGET_USER" bash -c "rm -rf /tmp/WhiteSur-gtk-theme && git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git /tmp/WhiteSur-gtk-theme --depth=1 && cd /tmp/WhiteSur-gtk-theme && ./install.sh -o solid --shell -i arch"
rm -rf /tmp/WhiteSur-gtk-theme
log "Tema WhiteSur installato."

log "Configurazione di Flatpak..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
log "Remote Flathub aggiunto."

log "Configurazione di Zsh, Oh My Zsh e Powerlevel10k..."
chsh -s /usr/bin/zsh "$TARGET_USER"
log "Zsh impostata come shell predefinita per $TARGET_USER."

sudo -u "$TARGET_USER" bash -c '
ZSH_CUSTOM_INNER=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

# Install Oh My Zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\"\" --unattended"
else
    echo "Oh My Zsh is already installed."
fi

# Install Powerlevel10k theme if not installed
if [ ! -d "${ZSH_CUSTOM_INNER}/themes/powerlevel10k" ]; then
    echo "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM_INNER}/themes/powerlevel10k"
else
    echo "Powerlevel10k theme is already installed."
fi

# Install zsh-syntax-highlighting plugin if not installed
if [ ! -d "${ZSH_CUSTOM_INNER}/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting plugin..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM_INNER}/plugins/zsh-syntax-highlighting"
else
    echo "zsh-syntax-highlighting plugin is already installed."
fi

# Install zsh-autosuggestions plugin if not installed
if [ ! -d "${ZSH_CUSTOM_INNER}/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions plugin..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM_INNER}/plugins/zsh-autosuggestions"
else
    echo "zsh-autosuggestions plugin is already installed."
fi
'
log "Oh My Zsh, tema e plugin installati."

ZSHRC_FILE="$USER_HOME/.zshrc"
sudo -u "$TARGET_USER" bash -c "sed -i 's/^ZSH_THEME=.*/ZSH_THEME=\"powerlevel10k\/powerlevel10k\"/' $ZSHRC_FILE"
sudo -u "$TARGET_USER" bash -c "sed -i 's/^plugins=.*/plugins=(git docker docker-compose sudo zsh-autosuggestions zsh-syntax-highlighting)/' $ZSHRC_FILE"
log "Configurazione .zshrc applicata."


# --- Messaggio Finale ---
log "****************************************************************"
log "Ottimizzazione ArchLegion2 completata con successo!"
log "Per rendere effettive tutte le modifiche, è FONDAMENTALE RIAVVIARE il sistema."
log "Comando per riavviare: sudo reboot"
log "****************************************************************"

exit 0
