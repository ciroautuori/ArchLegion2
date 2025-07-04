#!/bin/bash
# ArchLegion2 Applications Install Script

set -e

# === FASE 3: APPLICAZIONI ESSENZIALI ===
echo "--- FASE 3: Installazione applicazioni ---"

# 3.1 Installazione AUR helper (yay)
if ! command -v yay &> /dev/null; then
    sudo -u "$USER" bash -c "rm -rf /tmp/yay && git clone https://aur.archlinux.org/yay.git /tmp/yay && cd /tmp/yay && makepkg -si --noconfirm"
fi

# 3.2 Installazione applicazioni principali
yay -S --noconfirm \
    anydesk-bin whatsdesk-bin telegram-desktop-bin \
    spotify visual-studio-code-bin obsidian windsurf

# 3.3 Installazione strumenti di sistema e VPN
sudo pacman -Syu --noconfirm --needed \
    timeshift gnome-keyring libsecret seahorse \
    networkmanager-openvpn network-manager-applet openvpn

# 3.4 Installazione ottimizzazioni NVIDIA (solo su hardware fisico)
if ! systemd-detect-virt &> /dev/null; then  # Se non siamo in una VM
    echo "Rilevato hardware fisico, installo optimus-manager-qt..."
    yay -S --noconfirm optimus-manager-qt
fi

# 3.5 Configurazione GNOME Keyring e gestione segreti
echo "Configurazione del keyring..."
sudo sed -i '/^auth.*pam_gnome_keyring.so/!s/^auth.*/auth optional pam_gnome_keyring.so\n&/' /etc/pam.d/login
sudo sed -i '/^session.*pam_gnome_keyring.so/!s/^session.*/session optional pam_gnome_keyring.so auto_start\n&/' /etc/pam.d/login

# 3.6 Configurazione di ProtonVPN Free
echo "Configurazione di ProtonVPN Free..."

# Installa i pacchetti necessari
sudo pacman -S --noconfirm --needed \
    openvpn \
    networkmanager-openvpn \
    network-manager-applet \
    dialog \
    python-pip

# Installa ProtonVPN CLI
if ! command -v protonvpn &> /dev/null; then
    echo "Installazione di ProtonVPN CLI..."
    git clone https://github.com/ProtonVPN/protonvpn-cli.git /tmp/protonvpn
    cd /tmp/protonvpn
    sudo ./protonvpn-cli.sh --install
    cd -
    rm -rf /tmp/protonvpn
fi

# Configurazione automatica per utente free
if [ ! -f "$HOME/.config/protonvpn-cli/protonvpn_cli.cfg" ]; then
    echo "Configurazione iniziale di ProtonVPN..."
    echo "Ti verrà chiesto di inserire le tue credenziali ProtonVPN Free"
    echo "Puoi creare un account gratuito su: https://account.protonvpn.com/signup?plan=free"
    
    # Crea la directory di configurazione
    mkdir -p "$HOME/.config/protonvpn-cli"
    
    # Configurazione di base per utenti free
    cat > "$HOME/.config/protonvpn-cli/protonvpn_cli.cfg" << EOL
[USER]
# Credenziali (da inserire manualmente)
username = 
password = 

[USER_TIER]
# Impostazione per account free
tier = 0

[PROTOCOL]
# Protocollo consigliato per la versione free
protocol = udp

[CONNECTION]
# Configurazioni di connessione
dns_leak_protection = True
check_update_interval = 3
custom_dns = 
EOL
    
    chmod 600 "$HOME/.config/protonvpn-cli/protonvpn_cli.cfg"
    echo "Configurazione salvata in ~/.config/protonvpn-cli/protonvpn_cli.cfg"
    echo "Per favore, apri il file e inserisci le tue credenziali ProtonVPN Free"
    echo "Dopo aver configurato le credenziali, puoi connetterti con: protonvpn-cli connect -f"
fi

# Crea un alias comodo per la connessione rapida
echo "alias protonvpn-connect='protonvpn-cli connect -f'" >> "$HOME/.zshrc"
echo "alias protonvpn-disconnect='protonvpn-cli disconnect'" >> "$HOME/.zshrc"

# Messaggio di completamento
echo ""
echo "✅ Configurazione di ProtonVPN completata!"
echo "Per utilizzare ProtonVPN Free:"
echo "1. Modifica il file ~/.config/protonvpn-cli/protonvpn_cli.cfg"
echo "2. Aggiungi le tue credenziali ProtonVPN Free"
echo "3. Connettiti con: protonvpn-connect"
echo "4. Disconnettiti con: protonvpn-disconnect"

echo "--- Installazione applicazioni completata! ---"
